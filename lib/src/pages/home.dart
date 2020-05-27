import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nannys/src/pages/map.dart';
import 'package:nannys/src/pages/users.dart';
import 'dart:async';
import 'package:toast/toast.dart';
//import 'users.dart';
//import '../providers/notifications.dart';
//import '../services/api_request.dart';

class MyHome extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
//creo clase para iniciar la peticion http

class _MyAppState extends State<MyHome> {
  List data = [];
  List data2 = [];
  Future<void> getApi() async {
    http.Response response =
        await http.get('https://jsonplaceholder.typicode.com/users');
    setState(() {
      data = json.decode(response.body);
      
    });
  }
  @override
  void initState() {
    super.initState();
    getApi();
    //final notification = new Notifications();
    //notification.initNotification();
  }

  //retorna un snniper
  loading() {
    return Center(child: CircularProgressIndicator());
  }

  //retorna cuando no hay datos
  showLoadingDialog() {
    return data.length == 0;
  }

  loadingOrList() {
    if (showLoadingDialog()) {
      return loading();
    } else {
      return listUser();
    }
  }

  //listar usuarios en tarjetas
  ListView listUser() => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, int index) {
          return Card(
              child: InkWell(
            //inkWell que envuelve el ontap
            child: Row(
              children: <Widget>[
                Icon(Icons.person),
                Text('${data[index]["name"]}'),
                //Text('${data[index]["address"]["city"]}'),
              ],
            ),
            onTap: () async {
              //final snackBar =  SnackBar(content: Text('${data[index]["name"]}'));
              Toast.show('${data[index]["name"]}', context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
              // Scaffold.of(context).showSnackBar(snackBar);
             //Navigator.push(
             //  context,
             //  MaterialPageRoute(builder: (BuildContext context) => Users()),
             //);
              //_settingModalBottomSheet(context, data, index);
            },
          ));
        },
      );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usuarios'),
        actions: <Widget>[
          IconButton(
              icon: new Icon(Icons.person_add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => MapOpen()),
                );
              }),
        ],
      ),
      body: loadingOrList(),
    );
  }
}

// show information of a person
/*_settingModalBottomSheet(context, List data, int index) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Card(
          child: Row(
            children: <Widget>[
              Text('Nombre: '),
              Text('${data[index]["name"]}'),
            ],
          ),
        );
      });
}*/
