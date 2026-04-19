class User {
  final String id;
  String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? '';
    final name = json['name'] as String? ?? 'Planner';
    return User(id: id.isEmpty ? 'default-user' : id, name: name);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
