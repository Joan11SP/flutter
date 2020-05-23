import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'home.dart';
import 'package:toast/toast.dart';

class MapOpen extends StatefulWidget {
  @override
  _MapOSM createState() => _MapOSM();
}

class _MapOSM extends State<MapOpen> {
  GlobalKey<OSMFlutterState> mapKey = GlobalKey<OSMFlutterState>();

  

  drawRoadOnMap() async {
    try {
      await mapKey.currentState.drawRoad(
          GeoPoint(latitude: 28.596429, longitude: 77.190628),
          GeoPoint(latitude: 28.4573802, longitude: 73.1424312));
    } on RoadException catch (e) {
      print("${e.errorMessage()}");
    }
  }

  viewMap()  {
    return OSMFlutter(
      key: mapKey,
      currentLocation:true,
      road: Road(
        startIcon: MarkerIcon(          
          icon: Icon(
            Icons.person,
            size: 64,
            color: Colors.brown,
          ),
        ),
        roadColor: Colors.yellowAccent,
      ),
      markerIcon: MarkerIcon(
        icon: Icon(
          Icons.person_pin_circle,
          color: Colors.blue,
          
          size: 56,
        ),
      ),
      //initPosition: GeoPoint(latitude: 5,longitude: 89),
    );
  }

  @override
  void initState() {
    super.initState();
    drawRoadOnMap();
  }
  @override
  void dispose(){
    super.dispose();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MyHome()),
                );
              }),
        ],
      ),
      body: viewMap(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async { 
          //get current position   
          await mapKey.currentState.currentLocation();      
          Toast.show('h', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
//<uses-permission  android:name="android.permission.ACCESS_FINE_LOCATION"  />

//<uses-permission  android:name="android.permission.ACCESS_COARSE_LOCATION"  />

//<uses-permission  android:name="android.permission.INTERNET"  />
