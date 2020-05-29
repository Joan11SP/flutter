class Person {
  String name;
  String email;
  String lastName;
  String dni; 
  int city;
  String dateBirth;
  String phone;

  Person({this.name, this.email});

  Person.jsonUser(Map json){
    name = json['name'];
    email = json['email'];
    lastName = json['last_name'];
    dni = json['cedula'];
    city = json['ciudad'];
    dateBirth = json['fecha_nacimiento'];
    phone = json['telefono'];

  }
  user() {
    return {
      'name':name, 
      'email': email,
      'last_name':lastName,
      'cedula':dni,
      'ciudad':city,
      'fecha_nacimiento':dateBirth,
      'telefono':phone
      };
  }

}
