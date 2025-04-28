class User {
  final String id;
  late final String name;
  late final String email;
  final String birthDate;
  late final String userType;
  final String? token;
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    required this.userType,
    this.token,
    this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      birthDate: json['birthDate'] ?? '',
      userType: json['userType'] ?? '',
      token: json['token'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'birthDate': birthDate,
      'userType': userType,
      'token': token,
      'profileImage': profileImage,
    };
  }
}
