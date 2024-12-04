class User {
  final String id;
  final String username;
  final String role;

  // Constructeur avec id, username et role
  User({required this.id, required this.username, required this.role});

  // Fonction pour créer un utilisateur depuis une réponse JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 'Unknown ID', // Valeur par défaut si 'id' est absent
      username: json['username'] ??
          'Unknown', // Valeur par défaut si 'username' est absent
      role: json['role'] ?? 'guest', // Valeur par défaut si 'role' est absent
    );
  }
}
