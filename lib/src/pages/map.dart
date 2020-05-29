import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nannys/src/UI/menu.dart';
import 'package:nannys/src/pages/users.dart';
import 'package:nannys/src/services/api_request.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
class MapOpen extends StatefulWidget {
  @override
  _MapOSM createState() => _MapOSM();
}


class _MapOSM extends State<MapOpen> {
  Map address;
  double lat, lon;
  MapboxMapController mapController;
  bool _myLocationEnabled = true;
  //Permission _permission;
//check permission location
  getAddressPosition(lat,long) async {
    http.Response response = await getAddress(lat, long);
    address = json.decode(response.body);

    setState(() => address = json.decode(response.body));
    
    Toast.show('${address['features'][0]['properties']['display_name']}', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

    if (response.statusCode == 201) {
      return print(address);
    } else {
      return print(address);
    }
  }

  permission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    print(statuses[Permission.location]);
  }

  //si el gps esta encendido
  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("GPS desabilitado"),
              content: const Text(
                  'Por favor asegurate de que este encendido el gps'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Aceptar'),
                    onPressed: () => Navigator.pop(context))
              ],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    permission();
    _checkGps();
  }

  //header of the activity
  appBar() {
    return AppBar(
      title: const Text('Mi Dirección'),
      actions: <Widget>[
        IconButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => Users()),
            );
          },
          icon: Icon(Icons.directions_bike),
        ),
        IconButton(
          onPressed: () async {
            Toast.show('', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          },
          icon: Icon(Icons.search),
        )
      ],
    );
  }

  //en el footer
  bottonNavigationBar() {
    return BottomNavigationBar(
      currentIndex: 0, // this will be set when a new tab is tapped
      type: BottomNavigationBarType.fixed, //cuando es mas de 4 items
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: new Icon(Icons.home),
          title: new Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: new Icon(Icons.mail),
          title: new Text('Messages'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person), title: Text('Profile')),
        BottomNavigationBarItem(
            icon: Icon(Icons.directions_car), title: Text('Ubicacion')),
      ],
    );
  }

  Widget _bottonAction(IconData data) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(data),
        
      ),
      onTap: () {},
    );
  }

  boton() {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[ 
          _bottonAction(Icons.time_to_leave),
          _bottonAction(Icons.time_to_leave),
          _bottonAction(Icons.time_to_leave),
          _bottonAction(Icons.time_to_leave),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: Menu(),
      body: Card(
        child: MapboxMap(
          myLocationEnabled: _myLocationEnabled,
          initialCameraPosition: CameraPosition(
              target: LatLng(-3.982726555151, -79.35828888), zoom: 15),
          onMapClick: (point, latLng) {
            getAddressPosition(latLng.latitude, latLng.longitude);
          },
          styleString: MapboxStyles.MAPBOX_STREETS,
          compassEnabled: false,
          rotateGesturesEnabled: false,
          onMapCreated: onMapCreated,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:Color(0xFF01579B),
        onPressed: () async {},
        child: Icon(Icons.my_location),
      ),
      bottomNavigationBar: boton(),
    );
  }

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 100.0,
  );

  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;
  //bool _compassEnabled = true;
  //CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  //MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  //String _styleString = MapboxStyles.MAPBOX_STREETS;
  //bool _rotateGesturesEnabled = true;
  //bool _scrollGesturesEnabled = true;
  //bool _tiltGesturesEnabled = true;
  //bool _zoomGesturesEnabled = true;
  //bool _myLocationEnabled = true;
  //MyLocationTrackingMode _myLocationTrackingMode = MyLocationTrackingMode.Tracking;

  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    _extractMapInfo();
  }

  void _onMapChanged() {
    setState(() {
      _extractMapInfo();
    });
  }

  void _extractMapInfo() {
    _position = mapController.cameraPosition;
    _isMoving = mapController.isCameraMoving;
  }

  @override
  void dispose() {
    mapController.removeListener(_onMapChanged);
    super.dispose();
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Card(
        child: MapboxMap(
          onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      trackCameraPosition: true,
      compassEnabled: _compassEnabled,
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,
      styleString: _styleString,
      rotateGesturesEnabled: _rotateGesturesEnabled,
      scrollGesturesEnabled: _scrollGesturesEnabled,
      tiltGesturesEnabled: _tiltGesturesEnabled,
      zoomGesturesEnabled: _zoomGesturesEnabled,
      myLocationEnabled: _myLocationEnabled,
      myLocationTrackingMode: _myLocationTrackingMode,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      onMapClick: (point, latLng) async {
        Icon(Icons.person_pin_circle);
                Toast.show('${latLng.latitude}/${latLng.longitude}', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      
        List features = await mapController.queryRenderedFeatures(point, [],null);
        if (features.length>0) {
          print(features[0]);
        }
      },
        ),
      ),
    );
  }
  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
    mapController.addListener(_onMapChanged);
    _extractMapInfo();

    
  }*/
}
