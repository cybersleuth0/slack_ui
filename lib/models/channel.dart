class Channel {
  final String id;
  final String name;
  final int unreadCount;

  Channel({required this.id, required this.name, this.unreadCount = 0});

  factory Channel.fromJson(Map<String, dynamic> json) =>
      Channel(id: json["id"], name: json["name"], unreadCount: json["unreadCount"] ?? 0);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "unreadCount": unreadCount};
}
