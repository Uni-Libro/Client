class UserModel {
  String? firstName;
  String? lastName;
  String? username;
  String? email;
  String? password;
  String? confirmPassword;

  UserModel();

  UserModel.create({
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.password,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'UserModel{firstName: $firstName,  lastName: $lastName, username: $username, email: $email, password: $password}';
  }
}
