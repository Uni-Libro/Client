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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (firstName != null) data['firstName'] = firstName;
    if (lastName != null) data['lastName'] = lastName;
    if (username != null) data['username'] = username;
    if (email != null) data['email'] = email;
    if (password != null) data['password'] = password;
    return data;
  }

  @override
  String toString() {
    return 'UserModel{firstName: $firstName,  lastName: $lastName, username: $username, email: $email, password: $password}';
  }
}
