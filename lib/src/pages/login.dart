import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:nannys/src/Models/model_user.dart';
import 'package:nannys/src/pages/map.dart';
import 'package:nannys/src/pages/users.dart';
import 'package:nannys/src/services/api_request.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<LoginPage> {
  bool isLogged = false;

  final _formKey = GlobalKey<FormState>();
  Person _person = new Person();

  loginSharedPreferences(data) async {
    final sharedPrefences = await SharedPreferences.getInstance();
    sharedPrefences.setString('sesionAlaOrden', jsonDecode(data));
  }

  logged(bool login) {
    setState(() {
      isLogged = login;
    });
  }

  logOut() async {
    final sharedPrefences = await SharedPreferences.getInstance();
    sharedPrefences.remove('sesionAlaOrden');
  }

  iraHome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => MapOpen()),
    );
  }

  final kHintTextStyle = TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  final kLabelStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- O -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Registrate con',
          style: kLabelStyle,
        ),
      ],
    );
  }

  //logo for register with fb or
  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => iraHome(),
            AssetImage(
              'assets/logo/fb.jpg',
            ),
          ),
          /*_buildSocialBtn(
            () => print('Login with Google'),
            AssetImage(
              'assets/logos/google.jpg',
            ),
          ),*/
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => Users()),
        );
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'No tienes una cuenta?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Resgistrate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //form for login
  formLogin() {
    return Form(
        child: Column(
            key: _formKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
          new ListTile(
            title: new TextFormField(
              decoration: InputDecoration(labelText: 'Correo'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Ingrese su correo';
                }
                return null;
              },
              onSaved: (value) => _person.firstName = value,
            ),
          ),
          new ListTile(
            title: new TextFormField(
                decoration: InputDecoration(labelText: 'Contraseña'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Ingrese su contraseña';
                  }
                  return null;
                },
                onSaved: (value) => _person.email = value),
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
                    }
                  },
                  child: Text('Iniciar Sesión'),
                ),
              ),
            ),
        ]));
  }

  //veiw of the page login
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              Container(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 120.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Alá Orden',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      formLogin(),
                      _buildSignupBtn(),
                      //_buildSignInWithText(),
                      //_buildSocialBtnRow(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
