class UserModel {
  String? phone;
  String? password;
  String? confirmPassword;

  UserModel({
    this.phone,
    this.password,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (phone != null) data['phone'] = phone;
    if (password != null) data['password'] = password;
    return data;
  }

  @override
  String toString() {
    return 'UserModel{phone: $phone, password: $password}';
  }
}
