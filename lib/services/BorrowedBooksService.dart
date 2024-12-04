import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/BorrowedBook.dart';

class BorrowedBooksService {
  // Utilisez l'URL correcte de votre serveur backend ici.
  static const String baseUrl = 'http://localhost:3000/api/borrowed-books';

  // Emprunter un livre
  Future<void> borrowBook(String bookId, String userId) async {
    if (userId.length != 24) {
      print("ID utilisateur invalide : $userId");
      return; // Arrêter la requête si l'ID utilisateur n'est pas valide
    }

    final url = Uri.parse('$baseUrl/borrow/$bookId');
    final headers = {
      "Content-Type": "application/json",
    };

    final body = jsonEncode({"userId": userId});

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Livre emprunté avec succès : ${responseData['message']}');
      } else {
        print('Erreur lors de l\'emprunt du livre : ${response.body}');
      }
    } catch (error) {
      print('Erreur réseau: $error');
    }
  }

  // Récupérer les livres empruntés
  Future<List<BorrowedBook>> getBorrowedBooks(String userId) async {
    final url = Uri.parse(
        '$baseUrl/borrowed-books/user/$userId'); // URL pour récupérer les livres empruntés par un utilisateur

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((book) => BorrowedBook.fromJson(book)).toList();
      } else {
        throw Exception(
            'Erreur lors de la récupération des livres empruntés : ${response.body}');
      }
    } catch (error) {
      print('Erreur lors de la récupération des livres empruntés : $error');
      throw Exception('Erreur réseau ou autre erreur de serveur');
    }
  }
}
