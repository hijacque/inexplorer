import 'package:http/http.dart';
import 'dart:convert';

import 'package:flutter_map/flutter_map.dart';
import 'package:xml/xml.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  final int id;
  final String type;
  final String name;
  final String category;
  final LatLng centerCoordinate;
  final String? address;

  const Location({
    required this.id,
    required this.type,
    required this.name,
    required this.category,
    required this.centerCoordinate,
    this.address,
  });
}

convertResponse(Response response) {
  late dynamic responseJson;

  try {
    responseJson = jsonDecode(response.body);
  } catch (exception) {
    final document = XmlDocument.parse(response.body);
    final paragraphs = document.findAllElements("p");

    for (var element in paragraphs) {
      if (element.text.trim() == '') {
        return;
      }
    }
    return {'status': response.statusCode};
  }

  return responseJson;
}

class OverpassAPI {
  static const String _apiURL = 'overpass-api.de';
  static const String _apiPath = '/api/interpreter';

  static Future<List> query(String rawQuery) async {
    Response responseText =
        await post(Uri.https(_apiURL, _apiPath), body: {'data': rawQuery});

    var responseJson = convertResponse(responseText);
    if (responseJson['elements'] == null) {
      return [];
    }

    List resultList = [];

    for (var location in responseJson['elements']) {
      resultList.add(location);
    }

    return resultList;
  }
}

class NominatimAPI {
  static const String _apiURL = 'nominatim.openstreetmap.org';

  static Future<List> search({
    String q = '',
    Map<String, String>? structuredQuery,
    bool moreNameDetails = false,
    bool moreAddressDetails = false,
    int limit = 0,
  }) async {
    Map<String, String>? params = {'format': 'jsonv2'};

    if (q != '') {
      params['q'] = q;
    } else {
      params = structuredQuery;
    }

    if (limit > 0) params?['limit'] = limit.toString();
    if (moreNameDetails) params?['namedetails'] = '1';
    if (moreAddressDetails) params?['addressdetails'] = '1';

    Response responseText = await get(Uri.https(_apiURL, '/search', params));

    return convertResponse(responseText);
  }

  static Future<List> lookup(List<String> osmIDs) async {
    Map<String, String> params = {
      'osm_ids': osmIDs.join(','),
      'format': 'jsonv2',
    };
    Response responseText = await get(Uri.https(_apiURL, '/lookup', params));

    return convertResponse(responseText);
  }
}

class InexplorerAPI {
  static const String _apiURL = '172.20.102.80:8000'; // domain of the server

  static Future<List> routes(Map startLocation, Map goalLocation) async {
    Response responseText = await get(Uri.http(
      _apiURL,
      '/routes',
      <String, String>{
        'start_map': startLocation['map_id'].toString(),
        'start_loc': '${startLocation['type'][0].toString().toUpperCase()}${startLocation['id']}',
        'goal_map': goalLocation['map_id'].toString(),
        'goal_loc': '${goalLocation['type'][0].toString().toUpperCase()}${goalLocation['id']}',
      },
    ));

    var result = convertResponse(responseText);
    if (result['status'] != 200) {
      return [];
    }

    List path = result['body'];
    // print(path);
    return path;
  }

  static Future<List> search(int mapID,
      {String query = '', bool deepSearch = false}) async {
    Response responseText = await get(Uri.http(
      _apiURL,
      '/search',
      <String, String>{
        'map_id': mapID.toString(),
        'q': query,
        'deep': deepSearch ? '1' : '',
      },
    ));

    var result = convertResponse(responseText);
    if (result['status'] != 200) {
      return [];
    }

    List locations = result['body'];
    return locations;
  }

  static Future<List?> lookupMap({
    int parentMapID = 0,
    String parentElementID = '0',
    int? mapID,
  }) async {
    late Response responseText;
    if (mapID == null) {
      responseText = await get(Uri.http(
        _apiURL,
        '/lookup-map',
        <String, String>{
          'parent_element': parentElementID,
          'parent_map': parentMapID.toString(),
        },
      ));
    } else {
      responseText = await get(Uri.http(
        _apiURL,
        '/lookup-map',
        <String, String>{
          'map_id': mapID.toString(),
        },
      ));
    }

    var result = convertResponse(responseText);
    if (result['status'] == 200) {
      return result['body'];
    }

    return null;
  }

  static Future<List> searchBounds(LatLngBounds bounds, int mapID) async {
    LatLng minPoint = bounds.southWest;
    LatLng maxPoint = bounds.northEast;

    Response responseText = await get(Uri.http(
      _apiURL,
      '/search-bounds',
      <String, String>{
        'bounds':
            '${minPoint.latitude},${minPoint.longitude},${maxPoint.latitude},${maxPoint.longitude}',
        'map_id': mapID.toString()
      },
    ));

    var response = convertResponse(responseText);

    if (response['status'] != 200) {
      return Future.error(response['body']);
    }

    return response['body'];
  }

  static Future<List> lookup(List<String> elementIDs,
      {bool withGeometry = false}) async {
    Response responseText = await get(Uri.http(
      _apiURL,
      '/lookup',
      <String, String>{
        'element_ids': elementIDs.join(','),
        'geom': withGeometry ? '1' : '0'
      },
    ));
    var response = convertResponse(responseText);

    if (response['status'] != 200) {
      return Future.error(response['body']);
    }

    return response['body'];
  }

  static TileLayer getTiles(String mapID) => TileLayer(
        urlTemplate: 'http://$_apiURL/tile/{map_id}/{z}/{x}/{y}',
        additionalOptions: {'map_id': mapID},
      );
}

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return await Geolocator.getCurrentPosition();
}
