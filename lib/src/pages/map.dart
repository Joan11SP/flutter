import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:nannys/src/services/api_request.dart';
import 'package:toast/toast.dart';
import 'package:location_permissions/location_permissions.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart' as http;

class MapOpen extends StatefulWidget {
  @override
  _MapOSM createState() => _MapOSM();
}

class _MapOSM extends State<MapOpen> {
  Map address;
  double lat,lon;
  GlobalKey<OSMFlutterState> mapKey = GlobalKey<OSMFlutterState>();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PermissionStatus _permission;
  void drawRoadOnMap() async {
    try {
      await mapKey.currentState.drawRoad(
          GeoPoint(latitude: 28.596429, longitude: 77.190628),
          GeoPoint(latitude: 28.4573802, longitude: 73.1424312));
    } on RoadException catch (e) {
      print("${e.errorMessage()}");
    }
  }

  void getPosition() async {
    try {
      GeoPoint points = await mapKey.currentState.myLocation();
      lat = points.latitude;
      lon = points.longitude;
      
      http.Response response = await getAdress(lat, lon);
      address = json.decode(response.body);

      Toast.show('${address['features'][0]['properties']['display_name']}', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

      if (response.statusCode == 201) {
        return print(address['features'][0]['properties']['display_name']);
      } else {
        return print(json.decode(response.body));
      }
    } catch (e) {
      print("${e.errorMessage()}");
    }
  }

  void newPosition() async {

    GeoPoint geoPoint = await mapKey.currentState.selectPosition();
    double latitud = geoPoint.latitude;
    double longuitud = geoPoint.longitude;
    Toast.show('$latitud + " " + $longuitud ', context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  OSMFlutter viewMap() {
    return OSMFlutter(
      key: mapKey,
      currentLocation: true,  
      onGeoPointClicked: (points){

      },          
      markerIcon: MarkerIcon(
        icon: Icon(
          Icons.person_pin_circle,
          color: Colors.blue,
          size: 56,
        ),
      ),
    );
  }
Future<void> _checkServiceLocation() async {
    ServiceStatus serviceStatus =
        await LocationPermissions().checkServiceStatus();
    if (serviceStatus == ServiceStatus.disabled) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            title: Text("GPS desabilitado"),
            content: Text(
                "Necesitamos saber tu uboicación, activa el GPS"),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context),
                color: Theme.of(context).primaryColor,
                child: Text(
                  "Aceptar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else if (serviceStatus == ServiceStatus.enabled) {
        await mapKey.currentState.currentLocation();
    }
  }
  permisos() {
     Future.delayed(Duration(milliseconds: 150), () async {
      //check location permission
      _permission = await LocationPermissions().checkPermissionStatus();
      if (_permission == PermissionStatus.denied) {
        //request location permission
        _permission = await LocationPermissions().requestPermissions();
        if (_permission == PermissionStatus.granted) {
          await _checkServiceLocation();
        }
      } else if (_permission == PermissionStatus.granted) {
              await _checkServiceLocation();
       }
     });
  }
   

  @override
  void initState() {
    super.initState();
    permisos();
  } 

  //header of the activity
  appBar() {
    return AppBar(
      title: const Text('Mi Dirección'),
      actions: <Widget>[
        IconButton(
          onPressed: () async {
           
          },
          icon: Icon(Icons.pin_drop),
        ),
        IconButton(
          onPressed: () async {
            GeoPoint p = await mapKey.currentState.selectPosition();
            double latitud = p.latitude;
            double longuitud = p.longitude;
            Toast.show('$latitud+ " " + $longuitud ', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          },
          icon: Icon(Icons.search),
        ),
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () async {
            await mapKey.currentState.setStaticPosition([
              GeoPoint(latitude: 47.434541, longitude: 8.467369),
              GeoPoint(latitude: 47.436207, longitude: 8.464072),
              GeoPoint(latitude: 47.437688, longitude: 8.460832),
            ], "static");
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text("static point changed"),
              duration: Duration(seconds: 10),
            ));
          },
        )
      ],
    );
  }

  //en el footer
  bottonNavigationBar(){
    return  BottomNavigationBar(
       currentIndex: 0, // this will be set when a new tab is tapped
       type: BottomNavigationBarType.fixed,//cuando es mas de 4 items
       items:<BottomNavigationBarItem> [
         BottomNavigationBarItem(
           icon: new Icon(Icons.home),
           title: new Text('Home'),
         ),
         BottomNavigationBarItem(           
           icon: new Icon(Icons.mail),
           title: new Text('Messages'),
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.person),           
           title: Text('Profile')
         ),
         BottomNavigationBarItem(
           icon: Icon(Icons.directions_car),
           title: Text('Ubicacion')
         ),
       ],
     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBar(),
      body: Card(
        
          child: OSMFlutter(
          key: mapKey,
          currentLocation:true,          
          onGeoPointClicked: (geoPoint)  {
            double lat = geoPoint.latitude;
            double lon = geoPoint.longitude;
            Toast.show('$lat+ " " + $lon ', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
            print('AKSKASDASLKDSDLKASJDLASKDJASLDJKASLDAS');
            print('AKSKASDASLKDSDLKASJDLASKDJASLDJKASLDAS');
            print('AKSKASDASLKDSDLKASJDLASKDJASLDJKASLDAS');
          },
          //mostar marcas en puntos que no cambian          
          staticPoints: [
            StaticPositionGeoPoint(
              "static",

              MarkerIcon(
                icon: Icon(
                  Icons.train,
                  color: Colors.green,
                  size: 48,
                ),
              ),
              [
                GeoPoint(latitude: 47.4333594, longitude: 8.4680184),
                GeoPoint(latitude: 47.4317782, longitude: 8.4716146),
              ],
            ),
          ],
          road: Road(
              startIcon: MarkerIcon(
                icon: Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.brown,

                ),
              ),
              roadColor: Colors.yellowAccent),
          markerIcon: MarkerIcon(
            icon: Icon(
              Icons.person_pin_circle,
              color: Colors.blue,
              size: 56,              
            ),            
          ),
          //trackMyPosition: true,
          //initPosition: GeoPoint(latitude: 47.35387, longitude: 8.43609),
          useSecureURL: false,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          getPosition();
        },
        child: Icon(Icons.my_location),
      ),
      bottomNavigationBar: bottonNavigationBar(),
    );
  }
}


