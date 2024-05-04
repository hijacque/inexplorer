import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:inexplorer_app/location.dart';
import 'package:inexplorer_app/interactive-map/map.dart';

class IndoorPage extends StatefulWidget {
  final int mapID;
  final List indoorMapIDs;
  final String locationName;

  const IndoorPage(this.mapID,
      {Key? key, required this.locationName, this.indoorMapIDs = const []})
      : super(key: key);

  @override
  State<IndoorPage> createState() => _IndoorPageState();
}

class _IndoorPageState extends State<IndoorPage> {
  late int mapID;

  Future<List<Map<String, dynamic>>> _searchLocations(String query) async {
    List results = await InexplorerAPI.search(mapID, query: query);

    List<Map<String, dynamic>> locations = results.map((location) {
      print(location);
      List bounds = location['bounds'];

      return {
        'id': location['id'],
        'type': location['type'],
        'category': location['category']
            .toString()
            .split('_')
            .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1)
            : '')
            .join(' '),
        'name': location['name'],
        'address': location['addr'],
        'lat': location['center']['lat'],
        'lon': location['center']['lng'],
        // 'bounds': bounds
        'bounds': LatLngBounds(
          LatLng(bounds[0],bounds[1]), LatLng(bounds[2],bounds[3]),
        ),
      };
    }).toList();

    return locations;
  }

  Future<List<Map<String, dynamic>>> _fetchVisibleLocations(
      LatLngBounds visibleBounds) async {
    late List results;
    try {
      results = await InexplorerAPI.searchBounds(visibleBounds, mapID);
    } catch (error) {
      print(error);
      return [];
    }

    List<Map<String, dynamic>> visibleLocations = results.map((location) {
      List bounds = location['bounds'];
      return <String, dynamic>{
        'id': location['id'],
        'type': location['type'],
        'category': location['tags']['amenity'],
        'center': LatLng(location['center']['lat'], location['center']['lng']),
        'bounds': LatLngBounds(
            LatLng(bounds[0], bounds[1]), LatLng(bounds[2], bounds[3])),
      };
    }).toList();

    return visibleLocations;
  }

  Future<Map<String, dynamic>?> _lookupSelectedLocation(
      int id, String type) async {
    String elemID = '${type[0]}$id'.toString().toUpperCase();
    late Map selected;
    try {
      List elements = await InexplorerAPI.lookup([elemID]);
      if (elements.isEmpty) return null;

      selected = elements[0];
    } catch (error) {
      print(error);
      return null;
    }

    List bounds = selected['bounds'];
    Map<String, dynamic> location = {
      'id': id,
      'type': '${type[0].toUpperCase()}${type.substring(1)}',
      'category': selected['tags']['amenity']
          .toString()
          .split('_')
          .map((word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
          .join(' '),
      'name': selected['tags']['name'] ?? null,
      'address': selected['tags']['addr:full'] ?? null,
      'lat': selected['center']['lat'],
      'lon': selected['center']['lng'],
      'bounds': LatLngBounds(
          LatLng(bounds[0], bounds[1]), LatLng(bounds[2], bounds[3])),
    };

    // Check if location has more indoor map locations
    try {
      List? indoorMap = await InexplorerAPI.lookupMap(
          parentElementID: elemID, parentMapID: mapID);
      if (indoorMap != null) {
        location['indoors'] = indoorMap;
      }
    } catch (error) {
      print(error);
    }

    return location;
  }

  void _onChangeLevel(int currentLevel) {
    setState(() {
      mapID = widget.indoorMapIDs[currentLevel]['map_id'];
    });
  }

  @override
  void initState() {
    super.initState();
    mapID = widget.indoorMapIDs[0]['map_id'];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.locationName),
        ),
        body: InteractiveMap(
          mapTiles: List.generate(
            widget.indoorMapIDs.length,
            (index) => InexplorerAPI.getTiles(
              widget.indoorMapIDs[index]['map_id'].toString(),
            ),
          ),
          searchLocations: _searchLocations,
          fetchVisibleLocations: _fetchVisibleLocations,
          fetchSelectedLocation: _lookupSelectedLocation,
          defaultLocation: LatLng(0, 0),
          initialZoom: 1,
          minZoom: 0,
          maxZoom: 3,
          onChangeMapLevel: _onChangeLevel,
          is_indoors: true,
        ),
      ),
    );
  }
}

class IndoorMap {
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  static const maxLat = 90;
  static const maxLng = 180;
  static const minLat = -90;
  static const minLng = -180;

  const IndoorMap(this.minX, this.minY, this.maxX, this.maxY);

  LatLng convertCoordinates(double x, double y) {
    // validate coordinates in bounds
    x = x > maxX
        ? maxX
        : x < minX
            ? minX
            : x;
    y = y > maxY
        ? maxY
        : y < minY
            ? minY
            : y;

    // Calculate the latitude and longitude using linear interpolation
    double latitude = ((maxLat - minLat) / (maxY - minY)) * y + minLat;
    double longitude = ((maxLng - minLng) / (maxX - minX)) * x + minLng;
    print('($latitude, $longitude)');
    return LatLng(latitude, longitude);
  }
}
