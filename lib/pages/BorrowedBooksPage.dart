import 'package:flutter/material.dart';
import '../services/BorrowedBooksService.dart';
import '../models/BorrowedBook.dart';

class BorrowedBooksPage extends StatefulWidget {
  final String userId;

  const BorrowedBooksPage({Key? key, required this.userId}) : super(key: key);

  @override
  _BorrowedBooksPageState createState() => _BorrowedBooksPageState();
}

class _BorrowedBooksPageState extends State<BorrowedBooksPage> {
  late Future<List<BorrowedBook>> _borrowedBooks;
  final BorrowedBooksService _borrowedBooksService = BorrowedBooksService();

  @override
  void initState() {
    super.initState();
    _loadBorrowedBooks();
  }

  void _loadBorrowedBooks() {
    setState(() {
      _borrowedBooks = _borrowedBooksService.getBorrowedBooks(widget.userId);
    });
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Livres empruntés')),
      body: FutureBuilder<List<BorrowedBook>>(
        future: _borrowedBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun livre emprunté.'));
          } else {
            final borrowedBooks = snapshot.data!;
            return ListView.builder(
              itemCount: borrowedBooks.length,
              itemBuilder: (context, index) {
                final borrowedBook = borrowedBooks[index];
                return ListTile(
                  title: Text(borrowedBook.book.title),
                  subtitle: Text(
                      'Retour prévu : ${formatDate(borrowedBook.returnDate)}'),
                  trailing: borrowedBook.returned
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.close, color: Colors.red),
                );
              },
            );
          }
        },
      ),
    );
  }
}
