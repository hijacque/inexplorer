import 'package:flutter/material.dart';

import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:inexplorer_app/search.dart';
import 'package:inexplorer_app/location.dart';
import 'package:inexplorer_app/style.dart';

class DirectionsPage extends StatefulWidget {
  const DirectionsPage({Key? key}) : super(key: key);

  @override
  State<DirectionsPage> createState() => _DirectionsPageState();
}

class _DirectionsPageState extends State<DirectionsPage> {
  int mapID = 1;
  bool _isSearchingStart = false;
  bool _isSearchingGoal = false;
  late FocusNode _startLocationFieldFocusNode;
  final TextEditingController _startLocationFieldController =
      TextEditingController();

  late FocusNode _goalLocationFieldFocusNode;
  final TextEditingController _goalLocationFieldController =
      TextEditingController();

  Map? _startLocation;
  Map? _goalLocation;

  Future<List<Map<String, dynamic>>> _searchLocations(String query) async {
    List results = await InexplorerAPI.search(mapID, query: query, deepSearch: true);

    List<Map<String, dynamic>> locations = results.map((location) {
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
        'bounds': LatLngBounds(
          LatLng(bounds[0],bounds[1]), LatLng(bounds[2],bounds[3]),
        ),
      };
    }).toList();

    return locations;
  }

  void _lookupSelectedLocation(Map selected) {
    print(selected);
  }

  @override
  initState() {
    super.initState();
    _startLocationFieldFocusNode = FocusNode();
    _startLocationFieldFocusNode.addListener(() {
      if (_startLocation != null) {
        String startLocationText = _startLocationFieldController.text;
        if (startLocationText.isEmpty || startLocationText != _startLocation?['name']) {
          _startLocation = null;
        }
      }

      setState(() {
        _isSearchingStart = _startLocationFieldFocusNode.hasFocus;
      });
    });

    _goalLocationFieldFocusNode = FocusNode();
    _goalLocationFieldFocusNode.addListener(() {
      if (_goalLocation != null) {
        String goalLocationText = _goalLocationFieldController.text;
        if (goalLocationText.isEmpty || goalLocationText != _goalLocation?['name']) {
          _goalLocation = null;
        }
      }

      setState(() {
        _isSearchingGoal = _goalLocationFieldFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('PLM'),
          elevation: 2,
          shadowColor: Colors.white70,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            children: [
              Text('Enter your starting location and destination.'),
              SizedBox(height: 32),
              LocationSearchTextField(
                hintText: 'Origin',
                fieldFocusNode: _startLocationFieldFocusNode,
                fieldTextController: _startLocationFieldController,
                loadOptions: _searchLocations,
                onSelected: (Map selected) {
                  _startLocation = selected;
                },
              ),
              SizedBox(height: 24),
              LocationSearchTextField(
                hintText: 'Destination',
                fieldFocusNode: _goalLocationFieldFocusNode,
                fieldTextController: _goalLocationFieldController,
                loadOptions: _searchLocations,
                onSelected: (Map selected) {
                  _goalLocation = selected;
                },
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  if (_startLocation == null || _goalLocation == null) {
                    print('Incomplete locations input. Please check your start and goal locations.');
                    return;
                  }
                  print(_startLocation);
                  print(_goalLocation);
                },
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: LIGHT,
                    fontSize: 16,
                  ),
                ),
                style: primaryButtonStyle.merge(TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                )),
              ),
              Visibility(
                visible: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Divider(height: 56),
                    Text(
                      'Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RouteCard extends StatelessWidget {
  const RouteCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(12),
        width: double.infinity,
        child: Text('Butt'),
      ),
    );
  }
}
