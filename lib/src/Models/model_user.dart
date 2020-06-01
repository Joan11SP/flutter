
import 'dart:convert';

Person userFromJson(String str) => Person.fromJson(json.decode(str));

String userToJson(Person data) => json.encode(data.toJson());

class Person {
    String firstName;
    String lastName;
    int ciudad;
    String telefono;
    String password;
    String email;
    String fechaNacimiento;
    String cedula;

    Person({
        this.firstName,
        this.lastName,
        this.ciudad,
        this.telefono,
        this.password,
        this.email,
        this.fechaNacimiento,
        this.cedula,
    });

    factory Person.fromJson(Map<String, dynamic> json) => Person(
        firstName: json["first_name"],
        lastName: json["last_name"],
        ciudad: json["ciudad"],
        telefono: json["telefono"],
        password: json["password"],
        email: json["email"],
        fechaNacimiento: json["fecha_nacimiento"],
        cedula: json["cedula"],
    );

    Map<String, dynamic> toJson() => {
        "first_name": firstName,
        "last_name": lastName,
        "ciudad": ciudad,
        "telefono": telefono,
        "password": password,
        "email": email,
        "fecha_nacimiento": fechaNacimiento,
        "cedula": cedula,
    };
}
