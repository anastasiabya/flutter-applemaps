import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:flutter/material.dart';

class AppleMaps extends StatefulWidget {
  const AppleMaps({Key? key}) : super(key: key);

  @override
  State<AppleMaps> createState() => _AppleMapsState();
}

class _AppleMapsState extends State<AppleMaps> {
  late AppleMapController mapController;
  Map<CircleId, Circle> circles = <CircleId, Circle>{};
  int _circleIdCounter = 1;
  CircleId? selectedCircle;

  @override
  void dispose() {
    super.dispose();
  }

  void _onMapCreated(AppleMapController controller) {
    mapController = controller;
  }

  void _onCircleTapped(CircleId circleId) {
    setState(() {
      selectedCircle = circleId;
    });
  }

  void _remove() {
    setState(() {
      if (circles.containsKey(selectedCircle)) {
        circles.remove(selectedCircle);
      }
      selectedCircle = null;
    });
  }

  void _add(LatLng latLng) {
    final int circleCount = circles.length;

    if (circleCount == 12) {
      return;
    }

    final String circleIdVal = 'circle_id_$_circleIdCounter';
    _circleIdCounter++;
    final CircleId circleId = CircleId(circleIdVal);

    final Circle circle = Circle(
      circleId: circleId,
      consumeTapEvents: true,
      fillColor: Colors.black,
      center: _createLatLng(latLng.latitude, latLng.longitude),
      radius: 5,
      onTap: () {
        _onCircleTapped(circleId);
      },
    );

    setState(() {
      circles[circleId] = circle;
    });
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  void _onLongPress(LatLng latlng) {
    _add(latlng);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        actions: [
          selectedCircle != null
              ? TextButton(
                  child: const Text(
                    'remove',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: (selectedCircle == null) ? null : _remove,
                )
              : Container(),
        ],
      ),
      body: Stack(
        children: [
          AppleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(0.0, 0.0),
            ),
            circles: Set<Circle>.of(circles.values),
            onLongPress: _onLongPress,
          ),
          Positioned(
            bottom: 60,
            right: 15,
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.white.withOpacity(0.6),
                    child: const Center(
                      child: Text(
                        '+',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  onTap: () {
                    mapController.moveCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                ),
                GestureDetector(
                  child: Container(
                    height: 30,
                    width: 30,
                    color: Colors.white.withOpacity(0.6),
                    child: const Center(
                        child: Text(
                      '-',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                  onTap: () {
                    mapController.moveCamera(
                      CameraUpdate.zoomOut(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
