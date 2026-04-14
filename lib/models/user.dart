class User {
  final String id;
  final String name;
  final String email;
  final bool isOnline;

  User({required this.id, required this.name, required this.email, this.isOnline = false});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json["id"], name: json["name"], email: json["email"], isOnline: json["isOnline"] ?? false);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "email": email, "isOnline": isOnline};
}
