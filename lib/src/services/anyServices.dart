import 'package:nannys/src/Models/model_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

String validateEmail =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

// validar email.
validate(String email) {
  RegExp regExp = new RegExp(validateEmail);
  if (email.isEmpty) {
    return 'Ingrese su correo';
  }
  if (regExp.hasMatch(email)) {
    return null;
  } else {
    return 'El Email suministrado no es válido. Intente otro correo electrónico';
  }
}

loginSharedPreferences(data) async {
  final sharedPrefences = await SharedPreferences.getInstance();
  sharedPrefences.setString('sesionAlaOrden', userToJson(data));
}

removeSharedPreferences() async {
  final sharedPrefences = await SharedPreferences.getInstance();
  sharedPrefences.remove('sesionAlaOrden');
}
