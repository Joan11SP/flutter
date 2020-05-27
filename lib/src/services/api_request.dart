
import 'package:http/http.dart' as http;

final url='https://proyecto-investigacionitsl.herokuapp.com/SistemaInvestigacion';

loginUser(login){
  return http.post('$url/login',body: login);
}

getAdress(latitud,longitud){
  return http.post('https://nominatim.openstreetmap.org/reverse?format=geojson&lat=$latitud&lon=$longitud');
}