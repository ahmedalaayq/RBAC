enum UserRoleEnum { user, admin }

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });
  final String id;
  final String name;
  final String email;
  final UserRoleEnum role;

  bool isAdmin(UserRoleEnum role) => role == .admin;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'] ?? json['displayName'],
      role: UserRoleEnum.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () {
          return UserRoleEnum.user;
        },
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'displayName': name, 'role': role.name};
  }
}
