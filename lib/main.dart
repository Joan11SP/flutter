import 'package:flutter/material.dart';
import 'package:nannys/src/pages/login.dart';
import 'package:nannys/src/pages/map.dart';
import 'package:nannys/src/pages/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var materialApp = MaterialApp(
        themeMode:ThemeMode.dark,        
        title: 'Ala Orden',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
          color: Color(0xFF004080),
        )),
        home: LogedOrNo());
    return materialApp;
  }
  
}

class LogedOrNo extends StatefulWidget {
  @override
  _LogedOrNoState createState() => _LogedOrNoState();
}

class _LogedOrNoState extends State<LogedOrNo> {
  
  bool logged = false;
  loged() async{
    final shared =  await SharedPreferences.getInstance();
    final getShared = shared.getString('sesionAlaOrden');
    print(getShared);
    if(getShared !=null){
      setState(() {
      logged = true;
    });
    }
    else{
      setState(() {
      logged = false;
    });
    }
    return getShared;
    
  }
  @override
  void initState() {    
    super.initState();
    loged();
  }
  @override 
  Widget build(BuildContext context){

        if(logged==true){
          return  MapOpen();
        }
        else{
          return  LoginPage();
        }
  }
}
  
  