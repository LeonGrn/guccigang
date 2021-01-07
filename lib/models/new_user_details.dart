class NewUserDetails {
  String email;
  String role;
  String username;
  String avatar;

  NewUserDetails({this.email, this.role, this.username, this.avatar});

  Map<String, dynamic> toJson() => {
        'email': email,
        'role': role,
        'username': username,
        'avatar': avatar,
      };
}
