import 'dart:convert';

import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import '../Models/model_user.dart';
import 'package:http/http.dart' as http;

Person _person = new Person();

class Users extends StatefulWidget {
  @override
  _UsersView createState() => _UsersView();
}

final url = 'http://localhost:3000/Persona/';

class _UsersView extends State<Users> {
  var body = jsonEncode(
      <String, String>{'dni': _person.name, 'password': _person.email}
      );
  Map login;
  Future createAccount(body) async {
    http.Response response = await http.post(
      'https://certificado-nodejs.herokuapp.com/api/datos_usuario/getLogin',body: body);
    login = json.decode(response.body);
    if (response.statusCode == 201) {
      return Toast.show('Bienvenido', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);

    } else {
      return Toast.show('Datos Incorrectos', context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crea tu cuenta"),
        ),
        body: new Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new ListTile(
                title: new TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Nombre',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }

                    return null;
                  },
                  onSaved: (value) => _person.name = value,
                ),
              ),
              new ListTile(
                title: new TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'email@gmail.com',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _person.email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: RaisedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // Si el formulario es válido, queremos mostrar un Snackbar
                      final FormState formState = _formKey.currentState;
                      formState.save();
                      print(_person.user());
                      createAccount(_person.user());
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ));
  }
}

/// para acceder al form
///
final _formKey = GlobalKey<FormState>();

