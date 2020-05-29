import 'package:toast/toast.dart';

String validateEmail = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

// validar email.
validate(email,context){
  RegExp regExp = new RegExp(validateEmail);

  if(regExp.hasMatch(email)){
    return true;
  }
  else{
    Toast.show('Correo Invalido', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }
}