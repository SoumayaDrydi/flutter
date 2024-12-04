import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class BookService {
  static const String baseUrl = 'http://localhost:3000/api/books';

  // Récupérer tous les livres
  Future<List<Book>> getBooks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Échec de la récupération des livres');
      }
    } catch (error) {
      throw Exception('Erreur lors de la connexion: $error');
    }
  }

  Future<void> addBook(Book book) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(book.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Erreur lors de l\'ajout du livre : ${response.body}');
      }
    } catch (error) {
      throw Exception('Erreur lors de la connexion: $error');
    }
  }

  Future<void> updateBook(Book book) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update/${book.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(book.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Erreur lors de la mise à jour du livre : ${response.body}');
      }
    } catch (error) {
      throw Exception('Erreur lors de la connexion: $error');
    }
  }

  // Supprimer un livre
  Future<void> deleteBook(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/delete/$id'));

      if (response.statusCode != 200) {
        throw Exception('Erreur lors de la suppression du livre');
      }
    } catch (error) {
      throw Exception('Erreur lors de la connexion: $error');
    }
  }

  // Recherche de livres
  Future<List<Book>> searchBooks(String query) async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/search?query=$query'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Book.fromJson(json)).toList();
      } else {
        throw Exception('Erreur lors de la recherche de livres');
      }
    } catch (error) {
      throw Exception('Erreur lors de la connexion: $error');
    }
  }
}
