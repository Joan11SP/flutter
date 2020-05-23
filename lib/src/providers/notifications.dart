

class Notifications {
 /* FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  
  final stramControllerMessage = StreamController<String>.broadcast();
  
  Stream<String> get messages => stramControllerMessage.stream;
   

  /*initNotification() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token){
      print(token);
    });*/
    
    //fo_F__GRzig:APA91bHO1MhZUNM9XLQnRalNAeIsFNfvYu7Fp083opbTcA6UFbuKGh9MH3hx7_6abACRztzUJJ-UVvHV00UpjGIL5tEcritegpZfq1B_ov6kP3fJBMDl9eo7g4QEr9ZzYF29t--gxUct
    _firebaseMessaging.configure(
      //dentro de la app
      onMessage: (text) {
        print('!!!!!!!!!!!! on message');
        print(text);

        String argumento = 'no_data';
        
        if(Platform.isAndroid){
          argumento = text['data']['puto'] ?? 'no_data';
        }
        
        stramControllerMessage.sink.add(argumento);

      },
      //en segundo plano
      onLaunch: (infor) {
        print('!!!!!!!!!!!! on launch');
        
        final data = infor['data']['Puto'];
        print('!!!!!!!!!!!! on resume  $data');
      },
      onResume: (informa) {
        print('!!!!!!!!!!!! on resume');
        print(informa);

      },
    );
  }

  dispose(){
    // ? para saber si existe
    stramControllerMessage?.close();
  }*/
}
