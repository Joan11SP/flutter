class Person {
  String name;
  String email;
  String last_name;

  Person({this.name, this.email, this.last_name});

  user() {
    return {'name': name, 'email': email,'last_name':last_name};
  }

}
