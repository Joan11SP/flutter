import 'dart:convert';

import 'package:nannys/src/pages/map.dart';
import 'package:nannys/src/services/anyServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import '../Models/model_user.dart';
import 'package:http/http.dart' as http;
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

Person _person = new Person();

class Users extends StatefulWidget {
  @override
  _UsersView createState() => _UsersView();
}

class _UsersView extends State<Users> {
  DateTime _dateTime;
  Map login;
  int _currentCity;
  final format = DateFormat('MMMM d, yyyy');

  var cities = <String>['Zamora'];
  Future createAccount(body) async {
    http.Response response = await http.post(
        'https://certificado-nodejs.herokuapp.com/api/datos_usuario/getLogin',
        body: body);
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  formCreateAccount() {
    return new Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new ListTile(
                title: new TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Cédula', icon: Icon(Icons.assignment_ind)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese su cédula';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _person.cedula = value;
                  },
                ),
              ),
              new ListTile(
                title: new TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Nombre', icon: Icon(Icons.person)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese su nombre';
                    }
                    return null;
                  },
                  onSaved: (value) => _person.firstName = value,
                ),
              ),
              new ListTile(
                title: new TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Apellido', icon: Icon(Icons.person)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese su apellido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _person.lastName = value;
                  },
                ),
              ),
              new ListTile(
                title: new TextFormField(
                  decoration: const InputDecoration(
                      hintText: 'Correo', icon: Icon(Icons.email)),
                  validator: (value)=>validate(value),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    _person.email = value;
                  },
                ),
              ),
              new ListTile(
                title: new TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Teléfono', icon: Icon(Icons.phone)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Ingrese su teléfono';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _person.telefono = value;
                  },
                ),
              ),
              new ListTile(
                title: DateTimeField(
                  format: format,
                  decoration: InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      icon: Icon(Icons.calendar_today)),
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime.now());
                  },
                  onChanged: (value) =>
                      _person.fechaNacimiento = value.toString(),
                  validator: (value) {
                    if (value == null) {
                      return 'Ingrese su fecha de nacimiento';
                    }
                    return null;
                  },
                ),
              ),
              new ListTile(
                title: DropdownButtonFormField(
                  decoration: InputDecoration(
                      labelText: 'Lugar de residencia',
                      icon: Icon(Icons.location_city)),
                  value: _currentCity == null ? null : cities[_currentCity],
                  items: cities.map((String value) {
                    return new DropdownMenuItem<String>(
                      value: value,
                      child: new Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _currentCity = cities.indexOf(value);
                      _person.ciudad = _currentCity + 1;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Escoga la ciudad donde vive';
                    }
                    return null;
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
                      if (_formKey.currentState.validate()) {
                        // Si el formulario es válido, queremos mostrar un Snackbar
                        final FormState formState = _formKey.currentState;
                        formState.save();
                        loginSharedPreferences(_person);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MapOpen()),
                        );
                      }
                    },
                    child: Text('Aceptar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crea tu cuenta"),
        ),
        body: formCreateAccount());
  }
}

/// para acceder al form
///
final _formKey = GlobalKey<FormState>();
