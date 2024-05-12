import 'package:flutter/material.dart';

import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:inexplorer_app/search.dart';
import 'package:inexplorer_app/location.dart';
import 'package:inexplorer_app/style.dart';

class DirectionsPage extends StatefulWidget {
  final List? existingRoutes;
  const DirectionsPage({Key? key, this.existingRoutes}) : super(key: key);

  @override
  State<DirectionsPage> createState() => _DirectionsPageState();
}

class _DirectionsPageState extends State<DirectionsPage> {
  int mapID = 1;
  bool _isSearchingRoutes = false;
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
  List? _routes;

  Future<List<Map<String, dynamic>>> _searchLocations(String query) async {
    List results =
        await InexplorerAPI.search(mapID, query: query, deepSearch: true);

    List<Map<String, dynamic>> locations = results.map((location) {
      List bounds = location['bounds'];

      return {
        'map_id': location['map_id'],
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
        'lng': location['center']['lng'],
        'bounds': LatLngBounds(
          LatLng(bounds[0], bounds[1]),
          LatLng(bounds[2], bounds[3]),
        ),
      };
    }).toList();

    return locations;
  }

  @override
  initState() {
    super.initState();
    if (widget.existingRoutes != null) {
      _routes = widget.existingRoutes;
    }

    _startLocationFieldFocusNode = FocusNode();
    _startLocationFieldController.addListener(() {
      if (_startLocation != null) {
        String startLocationText = _startLocationFieldController.text;
        if (startLocationText.isEmpty ||
            startLocationText != _startLocation?['name']) {
          _startLocation = null;
          setState(() {
            _routes = null;
          });
        }
      }
    });
    _startLocationFieldFocusNode.addListener(() {
      setState(() {
        _isSearchingStart = _startLocationFieldFocusNode.hasFocus;
      });
    });

    _goalLocationFieldController.addListener(() {
      if (_goalLocation != null) {
        String goalLocationText = _goalLocationFieldController.text;
        if (goalLocationText.isEmpty ||
            goalLocationText != _goalLocation?['name']) {
          _goalLocation = null;
          setState(() {
            _routes = null;
          });
        }
      }
    });
    _goalLocationFieldFocusNode = FocusNode();
    _goalLocationFieldFocusNode.addListener(() {
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
        body: _isSearchingRoutes
            ? Center(
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const SizedBox(
                    height: 72,
                    width: 72,
                    child: CircularProgressIndicator(
                      strokeWidth: 8,
                      color: PURPLE,
                    ),
                  ),
                ),
              )
            : _routes != null
                ? Container(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Available routes',
                          style: TextStyle(
                            fontSize: 16,
                            color: BLUE,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _routes?.length,
                            itemBuilder: (context, index) {
                              Map route = _routes?[index];
                              String time = route['cost']['travel time']
                                  .toStringAsFixed(3);
                              List secondsDuration = time.split('.');
                              Duration travelTime = Duration(
                                seconds: int.parse(secondsDuration[0]),
                                milliseconds: int.parse(secondsDuration[1]),
                              );
                              double pathLength = double.parse(route['cost']
                                      ['path length']
                                  .toStringAsFixed(6));
                              return RouteCard(
                                algorithm: 'PATH #${index + 1}',
                                routeLength: pathLength,
                                routeDuration: travelTime,
                                onTap: () {
                                  Navigator.pop(context, [index, _routes]);
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _startLocation = null;
                              _startLocationFieldController.text = '';
                              _goalLocation = null;
                              _goalLocationFieldController.text = '';
                              _routes = null;
                            });
                          },
                          style: primaryButtonStyle.merge(TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                          child: const Text(
                            'New search',
                            style: TextStyle(
                              color: LIGHT,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: lightButtonStyle.merge(TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: DANGER,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
                    width: double.infinity,
                    // height: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 24),
                    child: Column(
                      children: [
                        const Text(
                            'Enter your starting location and destination.',
                        ),
                        const SizedBox(height: 32),
                        LocationSearchTextField(
                          hintText: 'Origin',
                          fieldFocusNode: _startLocationFieldFocusNode,
                          fieldTextController: _startLocationFieldController,
                          loadDelay: const Duration(seconds: 3),
                          loadOptions: _searchLocations,
                          onSelected: (Map selected) {
                            _startLocation = selected;
                          },
                        ),
                        const SizedBox(height: 24),
                        LocationSearchTextField(
                          hintText: 'Destination',
                          fieldFocusNode: _goalLocationFieldFocusNode,
                          fieldTextController: _goalLocationFieldController,
                          loadDelay: const Duration(seconds: 3),
                          loadOptions: _searchLocations,
                          onSelected: (Map selected) {
                            _goalLocation = selected;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () async {
                            if (_startLocation == null ||
                                _goalLocation == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text(
                                  'Incomplete locations input.\nPlease check your start and goal locations.',
                                ),
                              ));
                              return;
                            }
                            setState(() {
                              _isSearchingRoutes = true;
                            });
                            List routes = await InexplorerAPI.routes(
                                _startLocation ?? {}, _goalLocation ?? {});

                            setState(() {
                              _routes = routes;
                              _isSearchingRoutes = false;
                            });
                          },
                          style: primaryButtonStyle.merge(TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                          child: const Text(
                            'Search',
                            style: TextStyle(
                              color: LIGHT,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: lightButtonStyle.merge(TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          )),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: DANGER,
                              fontSize: 16,
                            ),
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
  final double routeLength;
  final Duration routeDuration;
  final String algorithm;
  final void Function() onTap;

  const RouteCard(
      {Key? key,
      required this.algorithm,
      required this.routeLength,
      required this.routeDuration,
      required this.onTap})
      : super(key: key);

  String formatRouteDuration(Duration duration) {
    List<String> formattedDuration = [];
    if (duration.inHours > 0) {
      formattedDuration.add('${duration.inHours}h');
    }
    if (duration.inMinutes % 60 > 0) {
      formattedDuration.add('${duration.inMinutes % 60}m');
    }
    if (duration.inSeconds % 60 > 0) {
      // print(duration.inSeconds % 60);
      formattedDuration
          .add('${duration.inSeconds % 60}.${duration.inMilliseconds % 1000}s');
    }
    return formattedDuration.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        // margin: EdgeInsets.only(top: 18),
        child: Container(
          margin: EdgeInsets.all(18),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                algorithm,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: INDIGO,
                ),
              ),
              const Divider(),
              Text(
                'Estimated distance: ${routeLength}m',
                // textAlign: TextAlign.start,
              ),
              Text(
                'Estimated travel time: ${formatRouteDuration(routeDuration)}',
                // textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
