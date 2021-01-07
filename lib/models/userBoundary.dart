import 'package:guccigang/models/user_id.dart';

class UserBoundary {
  UserId userId;
  String role;
  String username;
  String avatar;

  UserBoundary({this.userId, this.role, this.username, this.avatar});

  Map<String, dynamic> toJson() => {
        'userId': userId.toJson(),
        'role': role,
        'username': username,
        'avatar': avatar,
      };

  factory UserBoundary.fromJson(Map<String, dynamic> parsedJson) {
    return UserBoundary(
        userId: UserId.fromJson(parsedJson['userId']),
        role: parsedJson['role'],
        username: parsedJson['username'],
        avatar: parsedJson['avatar']);
  }
}
