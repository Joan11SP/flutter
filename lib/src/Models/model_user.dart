class Person {
  String name;
  String email;
  String last_name;

  Person({this.name, this.email});

  user() {
    return {'dni':name, 'password': email};
  }

}
