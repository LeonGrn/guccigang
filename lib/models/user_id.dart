class UserId {
  String space;
  String email;

  UserId({this.space, this.email});

  Map<String, dynamic> toJson() => {
        'space': space,
        'email': email,
      };

  factory UserId.fromJson(Map<String, dynamic> json) {
    return UserId(space: json['space'], email: json['email']);
  }
}
