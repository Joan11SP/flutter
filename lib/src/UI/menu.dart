import 'package:flutter/material.dart';
import 'package:nannys/src/pages/login.dart';
import 'package:nannys/src/services/anyServices.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.account_circle, text: 'Mi Perfil', onTap: () {}),
          _logOut(
              icon: Icons.exit_to_app,
              text: 'Salir',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Cerrar Sesión"),
                        content: const Text('Esta seguro de salir?'),
                        actions: <Widget>[
                          FlatButton(
                              child: Text('Cancelar'),
                              onPressed: () => Navigator.pop(context)),
                          FlatButton(
                              child: Text('Aceptar'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginPage()),
                                );
                                removeSharedPreferences();
                              })
                        ],
                      );
                    });
              })
        ],
      ),
    );
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _logOut({IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/logo/alaOrden.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w100))),
        ]));
  }
}
