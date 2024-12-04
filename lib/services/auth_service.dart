import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

class AuthService {
  final String baseUrl = 'http://localhost:3000/api/auth'; // URL backend
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Méthode de connexion
  Future<User?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['token'] != null && responseData['role'] != null) {
          String token = responseData['token'];
          String role = responseData['role'];

          // Créez un objet utilisateur avec l'ID, le nom d'utilisateur et le rôle
          User user = User(id: 'Unknown ID', username: username, role: role);

          // Stockez le token dans un stockage sécurisé
          await _secureStorage.write(key: 'auth_token', value: token);

          return user;
        } else {
          print('Erreur: données manquantes dans la réponse');
        }
      } else {
        print('Erreur lors de la connexion: ${response.body}');
      }
    } catch (e) {
      print('Erreur réseau: $e');
    }
    return null;
  }

  // Méthode de déconnexion
  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: 'auth_token');
      print('Déconnexion réussie');
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
    }
  }

  // Méthode d'inscription
  Future<bool> register(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
