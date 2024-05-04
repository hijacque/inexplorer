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
  List<Marker> markers = [];

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

  final bool is_indoors;

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
    this.is_indoors = false,
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

  // TODO: separate function for detecting user's current location
  void moveToCurrentLocation() async {
    late Position currentPosition;
    try {
      currentPosition = await determinePosition();
      _userLocation =
          LatLng(currentPosition.latitude, currentPosition.longitude);
    } catch (error) {
      print(error);
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
      currentMap.markers = [
        Marker(
          point: _userLocation ?? widget.defaultLocation,
          child: Icon(
            Icons.radio_button_checked_outlined,
            color: Colors.blue,
          ),
        )
      ];
    } else {
      currentMap.markers.clear();
    }

    // plot visible locations of known places in the map
    List<Map<String, dynamic>> visibleLocations =
        await widget.fetchVisibleLocations(visibleBounds);

    currentMap.visibleLocationMarkers.clear();
    for (Map<String, dynamic> location in visibleLocations) {
      currentMap.visibleLocationMarkers.add(
        Marker(
          point: location['center'],
          alignment: Alignment.center,
          child: IconButton(
            icon: Icon(
              locationMarkerIcons[location['category']] ??
                  Icons.radio_button_checked,
              color: BLUE,
            ),
            style: TextButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: LIGHT,
                padding: EdgeInsets.all(2),
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
                if (_selectedLocation != null)
                  updateMapLocation(_selectedLocation?['bounds']);
                _isLoadingLocation = false;
              });
            },
          ),
        ),
      );
    }

    setState(() {
      currentMap.markers.addAll(currentMap.visibleLocationMarkers);
    });
  }

  void _startUpdateMarkerTimer() {
    _updateMarkersTimer?.cancel();
    _updateMarkersTimer = Timer(Duration(seconds: 2), updateMapMarkers);
  }

  void updateMapLocation(LatLngBounds bounds) {
    _mapControllers[_currentMapIndex].fitCamera(CameraFit.coordinates(
      coordinates: [bounds.southWest, bounds.northEast],
      forceIntegerZoomLevel: true,
      padding: const EdgeInsets.all(0),
    ));
  }

  Widget myMap(MapData map) {
    return FlutterMap(
      mapController: _mapControllers[_mapLevels.indexOf(map)],
      children: [
        map.tileLayer,
        MarkerLayer(markers: map.markers),
      ],
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
        onTap: (position, point) => print([point.latitude, point.longitude]),
        onPositionChanged: (position, hasGesture) => _startUpdateMarkerTimer(),
        interactionOptions: InteractionOptions(
          flags: _isLoadingLocation
              ? ~InteractiveFlag.all // disable all interaction features
              : InteractiveFlag.all &
                  ~InteractiveFlag
                      .rotate, // enable all interactions except rotate
        ),
      ),
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
                  child: SizedBox(
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
                    margin: EdgeInsets.all(24),
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
                        SizedBox(
                          height: 12,
                        ),
// Map action buttons
                        Wrap(
                          direction: Axis.horizontal,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          children: [
// To get user's current location
                            IconButton(
                              onPressed: () {
                                setState(() => _isLoadingLocation = true);
                                _selectedLocation = null;
                                moveToCurrentLocation();
                                setState(() => _isLoadingLocation = false);
                              },
                              icon: Icon(Icons.my_location),
                              iconSize: 26,
                              color: BLUE,
                              style: lightButtonStyle,
                              tooltip: 'Find my location',
                            ),
// Adjusts the zoom level of the map
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
                                  icon: Icon(
                                    Icons.add,
                                    size: 20,
                                  ),
                                  color: (mapController.camera.zoom + 1 <=
                                          (mapController.camera.maxZoom ??
                                              mapController.camera.zoom))
                                      ? PURPLE
                                      : LIGHT_GREY,
                                  padding: EdgeInsets.only(left: 14, right: 12),
                                  style: lightButtonStyle.merge(
                                    TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
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
                                  icon: Icon(
                                    Icons.remove,
                                    size: 20,
                                  ),
                                  color: (mapController.camera.zoom - 1 >
                                          (mapController.camera.minZoom ??
                                              mapController.camera.zoom))
                                      ? PURPLE
                                      : LIGHT_GREY,
                                  padding: EdgeInsets.only(left: 12, right: 14),
                                  style: lightButtonStyle.merge(
                                    TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
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
                              visible: widget.is_indoors,
                              child: TextButton(
                                onPressed: () async {
                                  final path = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DirectionsPage(),
                                    ),
                                  );
                                  if (path == null) return;
                                  print(path);
                                  // plot the path
                                  // animate how destination will be reached
                                },
                                child: Text(
                                  'Get directions',
                                  style: TextStyle(
                                    color: BLUE,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                style: lightButtonStyle,
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
                            // To move from one map level to another
                            Visibility(
                              visible: !_isSearchingLocation,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: _selectedLocation == null ? 12 : 0,
                                ),
                                child: widget.mapTiles.length > 1
                                    ? LevelNavigator(
                                        maxLevel: widget.mapTiles.length,
                                        initialLevel: _currentMapIndex + 1,
                                        onChangeLevel: (int level) {
                                          _mapLevelController?.animateToPage(
                                            level,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.linear,
                                          );
                                          setState(() {
                                            _selectedLocation = null;
                                          });
                                        },
                                      )
                                    : IconButton(
                                        onPressed: () {},
                                        icon: Icon(
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
                                      builder: (context) => new IndoorPage(
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
                                    padding:
                                        EdgeInsets.only(left: 12, right: 18),
                                  ),
                                ),
                                child: Row(
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
                                icon: Icon(
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
                          location: _selectedLocation ?? Map(),
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
        decoration: BoxDecoration(
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
              style: TextStyle(
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
      decoration: BoxDecoration(
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
            style: TextStyle(
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
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 4.0), // Adjust the vertical padding as needed
            child: Divider(thickness: 1.5),
          ),
          Text(
            location['address'] ?? 'Address',
            style: TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// TODO: Add onChangeLevel function property
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
        boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 8.0, spreadRadius: 1),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Floor level',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: PURPLE,
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: floorFieldController,
            decoration: LightTextFieldStyle.copyWith(
              prefixIcon: IconButton(
                onPressed: () {
                  if (currentLevel < widget.maxLevel)
                    currentLevel += 1;
                  else
                    return;

                  widget.onChangeLevel(currentLevel - 1);
                  setState(() {
                    floorFieldController.text = currentLevel.toString();
                  });
                },
                icon: Icon(
                  Icons.arrow_upward,
                  size: 20,
                ),
                padding: EdgeInsets.all(2),
              ),
              prefixIconColor:
                  (currentLevel < widget.maxLevel) ? BLUE : Colors.grey,
              suffixIcon: IconButton(
                onPressed: () {
                  if (currentLevel > widget.minLevel)
                    currentLevel -= 1;
                  else
                    return;

                  widget.onChangeLevel(currentLevel - 1);
                  setState(() {
                    floorFieldController.text = currentLevel.toString();
                  });
                },
                icon: Icon(
                  Icons.arrow_downward,
                  size: 20,
                ),
              ),
              suffixIconColor:
                  (currentLevel > widget.minLevel) ? BLUE : Colors.grey,
            ),
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ],
      ),
    );
  }
}
