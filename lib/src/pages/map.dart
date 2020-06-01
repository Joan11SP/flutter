import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nannys/src/UI/menu.dart';
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
  MapboxMapController mapController;
  String _myLocation;
  bool gps = false;
  Position _currentPosition;
  String mylocation;
  int idPedido= 0 ; 
  //cualquier posicion
  getAddressPosition(lat, long) async {
    http.Response response = await getAddress(lat, long);
    address = json.decode(response.body);

    setState(() => address = json.decode(response.body));

    if (response.statusCode == 201) {
      return Toast.show(
          '${address['features'][0]['properties']['display_name']}', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
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

  // ! si el gps esta encendido
  _checkGps() async {
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
      setState(() {
        gps = false;
      });
    } else {
      setState(() {
        gps = true;
      });
    }
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator();
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  getLocation() async {
    http.Response response =
        await getAddress(_currentPosition.latitude, _currentPosition.longitude);
    address = json.decode(response.body);

    setState(() {
      address = json.decode(response.body);
      mylocation = address['features'][0]['properties']['display_name'];
      _myLocation = address['features'][0]['properties']['name'];
    });
  }

  @override
  void initState() {
    super.initState();
    permission();
    _checkGps();
    _getCurrentLocation();
    getLocation();
  }

  viewMap() {
    return Card(
      child: MapboxMap(
        myLocationEnabled:true,
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
    );
  }

  //header of the activity
  appBar() {
    return AppBar(
      title: Image.asset(
        'assets/logo/alaOrdenCopia.png',
        width: 250,
        height: 50,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        )
      ],
    );
  }

  myLocation() {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: EdgeInsets.symmetric(vertical: 18.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.room,
                        color: Colors.green,
                      ),
                      if (_currentPosition != null && mylocation != null)
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$mylocation',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      FlatButton(
                        child: Text("Obtener posición"),
                        onPressed: () {
                          _getCurrentLocation();
                          getLocation();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
            color: Color(0xFF01579B),
          ),
        ),
      ),
    );
  }

  botonFooter(){
    return Row(      
      mainAxisSize: MainAxisSize.max,      
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          child: Image.asset('assets/logo/moto.png', width: 50, height: 50),
          onTap: () {
             
          },
        ),
        InkWell(
          child: Image.asset('assets/logo/taxi.png', width: 50, height: 50),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Card(
                    child: formPedidos()
                  );
                });
            setState(()=>print(idPedido = 1) );
          },
        ),
        InkWell(
          child:Image.asset('assets/logo/flete.png', width: 50, height: 50),
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Card(
                    child: formPedidos()
                  );
                });
            setState(()=>print(idPedido = 2) );
          },
        ),
        InkWell(          
          child: Image.asset('assets/logo/camioneta.png', width: 50, height: 50),          
          onTap: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Card(
                    child: formPedidos()
                  );
                });
            setState(()=>print(idPedido = 3) );
          },
        ),
      ],
    );    
  }
  formPedidos() {
    return Form(
      //key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new ListTile(
              title: new TextFormField(
                decoration: const InputDecoration(
                    hintText:'Calle Principal', icon: Icon(Icons.flag)),
                
                onSaved: (value) {
                  // _person.cedula = value;
                },
                initialValue: _myLocation,
              ),
            ),
            new ListTile(
              title: new TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Calle Secundaria', icon: Icon(Icons.flag)),
                
                // onSaved: (value) => _person.firstName = value,
              ),
            ),
            new ListTile(
              title: new TextFormField(
                decoration: const InputDecoration(
                    hintText: 'Referencia', icon: Icon(Icons.location_city)),
                
                onSaved: (value) {
                  //  _person.lastName = value;
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  elevation: 5.0,
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  color: Color(0xFF01579B),
                  textColor: Color(0xFFFFFFFF),
                  onPressed: () {
                    if (true) {
                      // Si el formulario es válido, queremos mostrar un Snackbar
                      //final FormState formState = _formKey.currentState;
                      //formState.save();

                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MapOpen()),
                      );*/
                    }
                  },
                  child: Text('Aceptar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: Menu(),
      body: Stack(
        children: <Widget>[
          viewMap(),
          myLocation(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF004080),
        onPressed: () async {
          _getCurrentLocation();
          getLocation();
        },
        child: Icon(Icons.person_pin_circle),
      ),
      bottomNavigationBar: BottomAppBar(
        child: botonFooter(),
        color: Color(0xFF004080),
      ),
    );
  }

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: LatLng(-33.852, 151.211),
    zoom: 100.0,
  );

  CameraPosition _position = _kInitialPosition;
  bool _isMoving = false;

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
}
