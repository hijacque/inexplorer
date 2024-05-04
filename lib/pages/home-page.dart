import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'dart:async';

import 'package:inexplorer_app/style.dart';
import 'package:inexplorer_app/location.dart';
import 'package:inexplorer_app/interactive-map/map.dart';

TileLayer get osmTileLayer => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Map<String, dynamic>>> _searchLocations(String query) async {
    var results = await NominatimAPI.search(q: query);

    List<Map<String, dynamic>> locations = results.map((location) {
      String display = location['display_name'].toString();
      List bounds = location['boundingbox'];

      return {
        'id': location['osm_id'],
        'type': location['osm_type'],
        'category': location['type']
            .toString()
            .split('_')
            .map((word) => word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1)
                : '')
            .join(' '),
        'name': location['name'],
        'address': display.substring(display.indexOf(',') + 2),
        'lat': double.parse(location['lat']),
        'lon': double.parse(location['lon']),
        // 'bounds': bounds
        'bounds': LatLngBounds(
          LatLng(double.parse(bounds[0]), double.parse(bounds[2])),
          LatLng(double.parse(bounds[1]), double.parse(bounds[3])),
        ),
      };
    }).toList();

    return locations;
  }

  Future<List<Map<String, dynamic>>> _fetchVisibleLocations(
      LatLngBounds visibleBounds) async {
    double minLat = visibleBounds.south;
    double minLng = visibleBounds.west;
    double maxLat = visibleBounds.north;
    double maxLng = visibleBounds.east;

    String query = '[out:json];(' +
        'way["amenity"]($minLat, $minLng, $maxLat, $maxLng);' +
        'relation["amenity"]($minLat, $minLng, $maxLat, $maxLng);' +
        '); out center;';

    var overpassResults = await OverpassAPI.query(query);

    List<Map<String, dynamic>> visibleLocations =
        overpassResults.map((location) {
      return {
        'id': location['id'],
        'type': location['type'],
        'category': location['tags']['amenity'],
        'center': LatLng(location['center']['lat'], location['center']['lon']),
        'bounds': location['bounds'],
      };
    }).toList();

    return visibleLocations;
  }

  Future<Map<String, dynamic>?> _lookupSelectedLocation(
      int id, String type) async {
    // Lookup location information with Nominatim API
    String osmID = '${type[0]}$id'.toString().toUpperCase();
    dynamic selected = await NominatimAPI.lookup([osmID]);
    selected = selected[0];
    String displayName = selected['display_name'];

    List bounds = selected['boundingbox'];
    LatLng center = LatLng(
      double.parse(selected['lat']),
      double.parse(selected['lon']),
    );

    Map<String, dynamic> location = {
      'id': id,
      'type': type,
      'category': selected['type']
          .toString()
          .split('_')
          .map((word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
          .join(' '),
      'name': selected['name'] ?? null,
      'address': displayName.substring(displayName.indexOf(',') + 2),
      'lat': center.latitude,
      'lon': center.longitude,
      'bounds': LatLngBounds(
        LatLng(double.parse(bounds[0]), double.parse(bounds[2])),
        LatLng(double.parse(bounds[1]), double.parse(bounds[3])),
      ),
    };

    // Check if location is registered in Inexplorer database
    try {
      List? indoorMap = await InexplorerAPI.lookupMap(parentElementID: osmID);
      if (indoorMap != null) {
        location['indoors'] = indoorMap;
      }
    } catch (error) {
      print(error);
    }

    return location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InteractiveMap(
          mapTiles: [
            osmTileLayer
          ],
          searchLocations: _searchLocations,
          fetchVisibleLocations: _fetchVisibleLocations,
          fetchSelectedLocation: _lookupSelectedLocation,
          initialZoom: 18,
          defaultLocation: LatLng(14.5868936, 120.9763617906138),
          minZoom: 0,
          maxZoom: 18,
        ),
      ),
    );
  }
}
