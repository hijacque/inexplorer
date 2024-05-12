import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:async';

import 'package:inexplorer_app/style.dart';
import 'package:inexplorer_app/location.dart';
import 'package:inexplorer_app/search.dart';
import 'package:inexplorer_app/pages/indoor-page.dart';
import 'package:inexplorer_app/pages/directions-page.dart';

const Map<String, IconData> locationMarkerIcons = {
  'school': Icons.school,
  'college': Icons.school,
  'university': Icons.school,
  'restaurant': Icons.local_dining,
  'fast_food': Icons.local_dining,
  'parking': Icons.local_parking,
  'building': Icons.location_city,
  'entrance': Icons.login,
  'office': Icons.corporate_fare,
  'clinic': Icons.local_hospital,
  'comfort_room': Icons.wc,
  'classroom': Icons.school,
  'learning_laboratory': Icons.school,
  'hall': Icons.account_balance,
};

class MapData {
  final TileLayer tileLayer;

  List<Marker> visibleLocationMarkers = [];
  List<Marker> pathMarkers = [];
  List<Marker> markers = [];
  List<Polyline> polyLines = [];

  MapData({
    required this.tileLayer,
  });
}

class InteractiveMap extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function(String query)
      searchLocations;
  final Future<List<Map<String, dynamic>>> Function(LatLngBounds visibleBounds)
      fetchVisibleLocations;
  final Function(int id, String type) fetchSelectedLocation;
  final Function(int startNode, int goalNode)? getDirections;

  final LatLng defaultLocation;
  final double maxZoom;
  final double minZoom;
  final double initialZoom;

  final void Function(int newLevel)? onChangeMapLevel;
  final List<TileLayer> mapTiles;

  final bool isIndoors;

  const InteractiveMap({
    Key? key,
    required this.mapTiles,
    required this.searchLocations,
    required this.fetchVisibleLocations,
    required this.fetchSelectedLocation,
    required this.maxZoom,
    required this.minZoom,
    this.initialZoom = 0,
    this.defaultLocation = const LatLng(0, 0),
    this.isIndoors = false,
    this.getDirections,
    this.onChangeMapLevel,
  }) : super(key: key);

  @override
  State<InteractiveMap> createState() => _InteractiveMapState();
}

class _InteractiveMapState extends State<InteractiveMap> {
  bool _isSearchingLocation = false;
  bool _isLoadingLocation = true;

  final TextEditingController _locationFieldController =
      TextEditingController();
  late final FocusNode _locationFieldFocusNode;
  late final PageController? _mapLevelController;
  late List<MapController> _mapControllers;
  late final List<MapData> _mapLevels;

  int _currentMapIndex = 0;
  Map<String, dynamic>? _selectedLocation;
  LatLng? _userLocation;
  Timer? _updateMarkersTimer;
  List? _routes;
  int _currentRoute = 0;

  void moveToCurrentLocation() async {
    late Position currentPosition;
    try {
      currentPosition = await determinePosition();
      _userLocation =
          LatLng(currentPosition.latitude, currentPosition.longitude);
    } catch (error) {
      debugPrint(error.toString());
      _userLocation = null;
    }

    MapController controller = _mapControllers[_currentMapIndex];
    controller.move(
        _userLocation ?? widget.defaultLocation, controller.camera.zoom);
    updateMapMarkers();
  }

  void updateMapMarkers() async {
    LatLngBounds visibleBounds =
        _mapControllers[_currentMapIndex].camera.visibleBounds;
    MapData currentMap = _mapLevels[_currentMapIndex];
    // plot current location of the user in the map
    if (_userLocation != null &&
        visibleBounds.contains(_userLocation ?? widget.defaultLocation)) {
      currentMap.visibleLocationMarkers = [
        Marker(
          point: _userLocation ?? widget.defaultLocation,
          child: const Icon(
            Icons.radio_button_checked_outlined,
            color: Colors.blue,
          ),
        )
      ];
    } else {
      currentMap.visibleLocationMarkers.clear();
    }

    // plot visible locations of known places in the map
    List<Map<String, dynamic>> visibleLocations =
        await widget.fetchVisibleLocations(visibleBounds);

    for (Map<String, dynamic> location in visibleLocations) {
      currentMap.visibleLocationMarkers.add(
        Marker(
            width: 150,
            height: 150,
            point: location['center'],
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  location['name'] ??
                      location['category']
                          .toString()
                          .split('_')
                          .map((word) => word.isNotEmpty
                              ? word[0].toUpperCase() + word.substring(1)
                              : '')
                          .join(' '),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: DARK, height: 1),
                ),
                IconButton(
                  icon: Icon(
                    locationMarkerIcons[location['category']] ??
                        Icons.radio_button_checked,
                    color: BLUE,
                  ),
                  style: TextButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: LIGHT,
                      padding: const EdgeInsets.all(2),
                      shadowColor: Colors.grey,
                      elevation: 2),
                  onPressed: () async {
                    if (_isLoadingLocation) return;

                    setState(() {
                      _isLoadingLocation = true;
                    });

                    _selectedLocation = await widget.fetchSelectedLocation(
                      location['id'],
                      location['type'],
                    );

                    setState(() {
                      if (_selectedLocation != null) {
                        updateMapLocation(_selectedLocation?['bounds']);
                      }
                      _isLoadingLocation = false;
                    });
                  },
                ),
              ],
            )),
      );
    }

    setState(() {});
  }

  void _startUpdateMarkerTimer() {
    _updateMarkersTimer?.cancel();
    _updateMarkersTimer = Timer(const Duration(seconds: 2), updateMapMarkers);
  }

  void updateMapLocation(LatLngBounds bounds) {
    _mapControllers[_currentMapIndex].fitCamera(CameraFit.coordinates(
      coordinates: [bounds.southWest, bounds.northEast],
      forceIntegerZoomLevel: true,
      padding: const EdgeInsets.all(0),
    ));
  }

  void plotPath(List path) {
    // Clear path markers
    for (MapData level in _mapLevels) {
      level.pathMarkers.clear();
    }

    Map<int, List<LatLng>> pathsPerMapLevel = {};
    // convert nodes to Latlng in their respective maps
    for (Map node in path) {
      int level = node['level'] - 1;
      if (!pathsPerMapLevel.containsKey(level)) {
        pathsPerMapLevel[level] = <LatLng>[];
      }
      pathsPerMapLevel[level]?.add(LatLng(node['lat'], node['lng']));
      if (path.last == node) {
        _mapLevels[level].pathMarkers.add(Marker(
              point: LatLng(node['lat'], node['lng']),
              child: const Icon(
                Icons.radio_button_checked,
                color: Colors.redAccent,
                size: 36,
              ),
            ));
      } else if (path.first == node) {
        _mapLevels[level].pathMarkers.add(Marker(
              point: LatLng(node['lat'], node['lng']),
              child: const Icon(
                Icons.radio_button_checked,
                color: Colors.blueAccent,
                size: 36,
              ),
            ));
      }
    }

    // plot path in map
    int initialLevel = pathsPerMapLevel.keys.first;
    for (int level in pathsPerMapLevel.keys) {
      Polyline line = Polyline(
        points: pathsPerMapLevel[level] ?? [],
        isDotted: true,
        strokeWidth: 6,
        strokeCap: StrokeCap.round,
        color: DARK,
      );
      _mapLevels[level].polyLines.clear();
      _mapLevels[level].polyLines.add(line);

      Timer(
        Duration(seconds: (level - initialLevel).abs() * 3, milliseconds: 500),
        () async {
          await _mapLevelController?.animateToPage(
            level,
            duration: const Duration(milliseconds: 500),
            curve: Curves.linear,
          );
          setState(() {
            updateMapLocation(line.boundingBox);
          });
        },
      );
    }
  }

  Widget myMap(MapData map) {
    return FlutterMap(
      mapController: _mapControllers[_mapLevels.indexOf(map)],
      options: MapOptions(
        keepAlive: true,
        initialCenter: widget.defaultLocation,
        initialZoom: widget.initialZoom,
        minZoom: widget.minZoom,
        maxZoom: widget.maxZoom,
        onMapReady: () {
          setState(() => _isLoadingLocation = true);
          moveToCurrentLocation();
          setState(() => _isLoadingLocation = false);
        },
        onPositionChanged: (position, hasGesture) => _startUpdateMarkerTimer(),
        interactionOptions: InteractionOptions(
          flags: _isLoadingLocation
              ? ~InteractiveFlag.all // disable all interaction features
              : InteractiveFlag.all &
                  ~InteractiveFlag
                      .rotate, // enable all interactions except rotate
        ),
      ),
      children: [
        map.tileLayer,
        PolylineLayer(polylines: map.polyLines),
        MarkerLayer(markers: map.visibleLocationMarkers + map.pathMarkers),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    if (widget.mapTiles.length > 1) {
      _mapLevelController = PageController(initialPage: 0);
    } else {
      _mapLevelController = null;
    }

    _mapLevels = [];
    _mapControllers = [];
    for (int i = 0; i < widget.mapTiles.length; i++) {
      _mapLevels.add(MapData(
        tileLayer: widget.mapTiles[i],
      ));
      _mapControllers.add(MapController());
    }

    _locationFieldFocusNode = FocusNode();
    _locationFieldFocusNode.addListener(() {
      setState(() {
        _isSearchingLocation = _locationFieldFocusNode.hasFocus;
      });
    });
  }

  @override
  dispose() {
    _locationFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MapData currentMap = _mapLevels[_currentMapIndex];
    final MapController mapController = _mapControllers[_currentMapIndex];

    return Stack(
      alignment: AlignmentDirectional.topCenter,
      fit: StackFit.expand,
      children: [
        (_mapLevels.length > 1)
            ? PageView.builder(
                controller: _mapLevelController,
                itemCount: _mapLevels.length,
                itemBuilder: (context, index) => myMap(_mapLevels[index]),
                onPageChanged: (int level) {
                  _updateMarkersTimer?.cancel();
                  setState(() {
                    _currentMapIndex = level;
                    _startUpdateMarkerTimer();
                  });
                  widget.onChangeMapLevel?.call(level);
                },
                scrollDirection: Axis.vertical,
                reverse: true,
              )
            : myMap(currentMap),
        _isLoadingLocation
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
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LocationSearchTextField(
                          hintText: 'Search location',
                          fieldFocusNode: _locationFieldFocusNode,
                          fieldTextController: _locationFieldController,
                          loadOptions: (value) => widget.searchLocations(value),
                          onSelected: (selected) async {
                            _isSearchingLocation = false;
                            setState(() {
                              _isLoadingLocation = true;
                            });
                            _selectedLocation =
                                await widget.fetchSelectedLocation(
                              selected['id'],
                              selected['type'],
                            );

                            setState(() {
                              updateMapLocation(selected['bounds']);
                              _isLoadingLocation = false;
                            });
                          },
                          delayOptionLoad: true,
                          loadDelay: const Duration(seconds: 2),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() => _isLoadingLocation = true);
                                _selectedLocation = null;
                                moveToCurrentLocation();
                                setState(() => _isLoadingLocation = false);
                              },
                              icon: const Icon(Icons.my_location),
                              iconSize: 26,
                              color: BLUE,
                              style: lightButtonStyle,
                              tooltip: 'Find my location',
                            ),
                            Wrap(
                              direction: Axis.horizontal,
                              spacing: -3,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    double currentZoom =
                                        mapController.camera.zoom;
                                    double maxZoom =
                                        mapController.camera.maxZoom ??
                                            currentZoom;

                                    if (currentZoom + 1 <= maxZoom) {
                                      setState(() {
                                        mapController.move(
                                          mapController.camera.center,
                                          currentZoom + 1,
                                        );
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.add, size: 20),
                                  color: (mapController.camera.zoom + 1 <=
                                          (mapController.camera.maxZoom ??
                                              mapController.camera.zoom))
                                      ? PURPLE
                                      : LIGHT_GREY,
                                  padding: const EdgeInsets.only(left: 14, right: 12),
                                  style: lightButtonStyle.merge(
                                    TextButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          bottomLeft: Radius.circular(50),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    double currentZoom =
                                        mapController.camera.zoom;

                                    double minZoom =
                                        mapController.camera.minZoom ??
                                            currentZoom;

                                    if (currentZoom - 1 > minZoom) {
                                      setState(() {
                                        mapController.move(
                                            mapController.camera.center,
                                            currentZoom - 1);
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.remove, size: 20),
                                  color: (mapController.camera.zoom - 1 >
                                          (mapController.camera.minZoom ??
                                              mapController.camera.zoom))
                                      ? PURPLE
                                      : LIGHT_GREY,
                                  padding: const EdgeInsets.only(left: 12, right: 14),
                                  style: lightButtonStyle.merge(
                                    TextButton.styleFrom(
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(50),
                                          bottomRight: Radius.circular(50),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Button for rute recommendation
                            Visibility(
                              visible: widget.isIndoors,
                              child: TextButton(
                                onPressed: () async {
                                  for (MapData level in _mapLevels) {
                                    level.polyLines.clear();
                                    level.pathMarkers.clear();
                                  }
                                  setState(() {
                                    _selectedLocation = null;
                                  });

                                  final List? results = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DirectionsPage(
                                        existingRoutes: _routes,
                                      ),
                                    ),
                                  );

                                  if (results == null) {
                                    setState(() {
                                      _routes = null;
                                    });
                                    return;
                                  }

                                  _currentRoute = results[0];
                                  _routes = results[1];
                                  List path = _routes?[_currentRoute]['path'];
                                  setState(() {
                                    plotPath(path);
                                  });
                                  // plot the path
                                  // animate how destination will be reached
                                },
                                style: lightButtonStyle,
                                child: Text(
                                  _routes == null
                                      ? 'Get directions'
                                      : 'Change route',
                                  style: TextStyle(
                                    color: _routes == null ? BLUE : SUCCESS,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // action widgets for selected location
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: !_isSearchingLocation,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: _selectedLocation == null ? 12 : 0,
                                ),
                                child: widget.mapTiles.length > 1
                                    ? FloorNavigator(
                                        floor: _currentMapIndex + 1,
                                        maxLevel: widget.mapTiles.length,
                                        onLevelUp: () async {
                                          await _mapLevelController
                                              ?.animateToPage(
                                            _currentMapIndex + 1,
                                            duration: const Duration(milliseconds: 500),
                                            curve: Curves.easeIn,
                                          );
                                          setState(() {
                                            _selectedLocation = null;
                                          });
                                        },
                                        onLevelDown: () async {
                                          await _mapLevelController
                                              ?.animateToPage(
                                            _currentMapIndex - 1,
                                            duration: const Duration(milliseconds: 500),
                                            curve: Curves.easeIn,
                                          );
                                          setState(() {
                                            _selectedLocation = null;
                                          });
                                        },
                                      )
                                    : IconButton(
                                        onPressed: null,
                                        icon: const Icon(
                                          Icons.question_mark,
                                          size: 24,
                                          color: LIGHT_GREY,
                                        ),
                                        padding: EdgeInsets.zero,
                                        style: lightButtonStyle,
                                      ),
                              ),
                            ),
                            // Explore indoor map of selected location
                            Visibility(
                              visible: _selectedLocation != null &&
                                  _selectedLocation?['indoors'] != null &&
                                  !_isSearchingLocation,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IndoorPage(
                                        6,
                                        locationName:
                                            _selectedLocation?['name'],
                                        indoorMapIDs:
                                            _selectedLocation?['indoors'],
                                      ),
                                    ),
                                  );
                                },
                                style: primaryButtonStyle.merge(
                                  TextButton.styleFrom(
                                    padding: const EdgeInsets.only(left: 12, right: 18),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.door_back_door_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Explore inside',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Unselect location button
                            Visibility(
                              visible: _selectedLocation != null &&
                                  !_isSearchingLocation,
                              child: IconButton(
                                onPressed: () {
                                  setState(() => _selectedLocation = null);
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: BLUE,
                                  size: 24,
                                ),
                                padding: EdgeInsets.zero,
                                style: lightButtonStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible:
                            _selectedLocation != null && !_isSearchingLocation,
                        child: LocationCard(
                          location: _selectedLocation ?? {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ],
    );
  }
}

class LocationCard extends StatelessWidget {
  final Map<String, dynamic> location;

  const LocationCard({
    Key? key,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (location['address'] == null) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 8.0, spreadRadius: 1),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(22),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location['name'] == null
                  ? location['category'] ?? 'Category'
                  : location['name'] ?? 'Name',
              softWrap: true,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
            Text(
              location['name'] == null
                  ? location['type'] ?? 'Type'
                  : location['category'] ?? 'Category',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
                height: 2,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 8.0, spreadRadius: 1),
        ],
      ),
      // height: 300,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 12),
      padding: const EdgeInsets.only(left: 22, right: 22, top: 22, bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            location['name'] == ''
                ? location['category'] ?? 'Category'
                : location['name'] ?? 'Name',
            softWrap: true,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          Text(
            location['name'] == ''
                ? location['type'] ?? 'Type'
                : location['category'] ?? 'Category',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              height: 2,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Divider(thickness: 1.5),
          ),
          Text(
            location['address'] ?? 'Address',
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class FloorNavigator extends StatelessWidget {
  final int floor;
  final int maxLevel;
  final int minLevel;
  final void Function() onLevelUp;
  final void Function() onLevelDown;

  const FloorNavigator({
    Key? key,
    required this.floor,
    required this.onLevelUp,
    required this.onLevelDown,
    this.maxLevel = 1,
    this.minLevel = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 8.0, spreadRadius: 1),
        ],
      ),
      child: Wrap(
        direction: Axis.horizontal,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          IconButton(
            onPressed: floor > minLevel ? onLevelDown : null,
            icon: const Icon(Icons.arrow_downward, size: 24),
            color: PURPLE,
            // padding: EdgeInsets.only(left: 14, right: 12),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
            ),
          ),
          Container(
            width: 64,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: LIGHT, width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              floor.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          IconButton(
            onPressed: floor < maxLevel ? onLevelUp : null,
            icon: const Icon(Icons.arrow_upward, size: 24),
            color: PURPLE,
            // padding: EdgeInsets.only(left: 14, right: 12),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LevelNavigator extends StatefulWidget {
  final int maxLevel;
  final int minLevel;
  final int initialLevel;

  final void Function(int newLevel) onChangeLevel;

  const LevelNavigator({
    Key? key,
    required this.maxLevel,
    required this.onChangeLevel,
    this.minLevel = 1,
    this.initialLevel = 1,
  }) : super(key: key);

  @override
  State<LevelNavigator> createState() => _LevelNavigatorState();
}

class _LevelNavigatorState extends State<LevelNavigator> {
  final TextEditingController floorFieldController = TextEditingController();
  late int currentLevel;

  @override
  initState() {
    super.initState();
    currentLevel = widget.initialLevel;
    floorFieldController.text = currentLevel.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 12),
      width: 150,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: LIGHT, width: 1.5),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 8.0, spreadRadius: 1),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Floor level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: PURPLE,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: floorFieldController,
            decoration: LightTextFieldStyle.copyWith(
              prefixIcon: IconButton(
                onPressed: () {
                  if (currentLevel >= widget.maxLevel) {
                    return;
                  }

                  currentLevel += 1;
                  widget.onChangeLevel(currentLevel - 1);
                  setState(() {
                    floorFieldController.text = currentLevel.toString();
                  });
                },
                icon: const Icon(Icons.arrow_upward, size: 20),
                padding: const EdgeInsets.all(2),
              ),
              prefixIconColor:
                  (currentLevel < widget.maxLevel) ? BLUE : Colors.grey,
              suffixIcon: IconButton(
                onPressed: () {
                  if (currentLevel <= widget.minLevel) {
                    return;
                  }

                  currentLevel -= 1;
                  widget.onChangeLevel(currentLevel - 1);
                  setState(() {
                    floorFieldController.text = currentLevel.toString();
                  });
                },
                icon: const Icon(Icons.arrow_downward, size: 20),
              ),
              suffixIconColor: (currentLevel > widget.minLevel) ? BLUE : Colors.grey,
            ),
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
    );
  }
}
