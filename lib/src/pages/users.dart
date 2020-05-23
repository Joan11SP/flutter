import 'package:flutter/material.dart';
import '../Models/model_user.dart';

Person _person = new Person();

class Users extends StatefulWidget {
  @override
  _UsersView createState() => _UsersView();
}

class _UsersView extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Nuevo Usuario"),
        ),
        body: new Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new ListTile(
                title:new TextFormField(
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
var name = TextEditingController();
var email = TextEditingController();
final _formKey = GlobalKey<FormState>();
final controllerForm = TextEditingController();
