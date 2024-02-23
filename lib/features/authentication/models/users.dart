class Users {
  Users({
    this.userId = '',
    required this.username,
    required this.profileUrl,
  });

  String userId;
  String username;
  String profileUrl;

  static Users fromJson(Map<String, dynamic> json) => Users(
        userId: json['userId'] ?? '',
        username: json['username'] ?? '',
        profileUrl: json['profileUrl'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'username': username,
        'profileUrl': profileUrl,
      };
}
