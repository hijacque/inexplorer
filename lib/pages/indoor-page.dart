import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'package:inexplorer_app/location.dart';
import 'package:inexplorer_app/interactive-map/map.dart';

class IndoorPage extends StatefulWidget {
  final int? parentMapID;
  final int mapID;
  final List indoorMapIDs;
  final String locationName;

  const IndoorPage(
    this.mapID, {
    Key? key,
    required this.locationName,
    this.indoorMapIDs = const [],
    this.parentMapID,
  }) : super(key: key);

  @override
  State<IndoorPage> createState() => _IndoorPageState();
}

class _IndoorPageState extends State<IndoorPage> {
  late int mapID;

  Future<List<Map<String, dynamic>>> _searchLocations(String query) async {
    List results = await InexplorerAPI.search(mapID, query: query);

    List<Map<String, dynamic>> locations = results.map((location) {
      List bounds = location['bounds'];

      return {
        'map_id': mapID,
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
        'address': location['address'],
        'lat': location['center']['lat'],
        'lon': location['center']['lng'],
        'bounds': LatLngBounds(
          LatLng(bounds[0], bounds[1]),
          LatLng(bounds[2], bounds[3]),
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
      debugPrint(error.toString());
      return [];
    }

    List<Map<String, dynamic>> visibleLocations = results.map((location) {
      List bounds = location['bounds'];
      return <String, dynamic>{
        'id': location['id'],
        'type': location['type'],
        'name': location['tags']['name'],
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
      debugPrint(error.toString());
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
      'name': selected['tags']['name'],
      'address': selected['tags']['addr:full'],
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
      debugPrint(error.toString());
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
          defaultLocation: const LatLng(0, 0),
          initialZoom: 1,
          minZoom: 0,
          maxZoom: 3,
          onChangeMapLevel: _onChangeLevel,
          isIndoors: true,
        ),
      ),
    );
  }
}
