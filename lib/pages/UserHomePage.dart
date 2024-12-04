import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../services/BorrowedBooksService.dart'; // Service pour gérer les livres empruntés
import '../models/book.dart';
import '../models/user.dart';
import './BorrowedBooksPage.dart'; // Page pour voir les livres empruntés

class UserDashboard extends StatefulWidget {
  final User user;

  const UserDashboard({Key? key, required this.user}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  late Future<List<Book>> _futureBooks;
  final BookService _bookService = BookService();
  final BorrowedBooksService _borrowedBooksService = BorrowedBooksService();

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  // Charger la liste des livres disponibles
  void _loadBooks() {
    setState(() {
      _futureBooks = _bookService.getBooks();
    });
  }

  // Fonction pour emprunter un livre
  Future<void> _borrowBook(String bookId) async {
    try {
      // Récupérer le token de manière sécurisée
      String token =
          await _getToken(); // Remplacer avec votre méthode pour obtenir un token

      await _borrowedBooksService.borrowBook(
          bookId, token); // Appel au service pour emprunter le livre

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Livre emprunté avec succès')),
      );
      _loadBooks(); // Recharge les livres après un emprunt
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'emprunt : $e')),
      );
    }
  }

  // Récupérer le token (remplacer par la logique de votre application)
  Future<String> _getToken() async {
    // Remplacer par la récupération du token réel
    return "votre_token_securise";
  }

  // Naviguer vers la page des livres empruntés
  void _viewBorrowedBooks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BorrowedBooksPage(userId: widget.user.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Livres disponibles - ${widget.user.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _viewBorrowedBooks,
            tooltip: 'Voir les livres empruntés',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Menu utilisateur'),
            ),
            ListTile(
              title: Text('Livres empruntés'),
              onTap: _viewBorrowedBooks,
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Book>>(
        future: _futureBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun livre disponible.'));
          } else {
            final books = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: book.available
                              ? () => _borrowBook(book.id)
                              : null,
                          child: Text(
                            book.available ? 'Emprunter' : 'Indisponible',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
