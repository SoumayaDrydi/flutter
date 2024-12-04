import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../models/book.dart';
import '../models/user.dart';
import 'book_form.dart';

class AdminDashboard extends StatefulWidget {
  final User user;

  const AdminDashboard({Key? key, required this.user}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<List<Book>> _futureBooks;
  final BookService _bookService = BookService();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      _futureBooks = _bookService.getBooks();
    });
  }

  void _searchBooks(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isEmpty) {
        _futureBooks = _bookService.getBooks();
      } else {
        _futureBooks = _bookService.searchBooks(_searchQuery);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin (${widget.user.username})'),
        backgroundColor: Colors.deepPurple,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 250,
              child: TextField(
                controller: _searchController,
                onChanged: _searchBooks,
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  suffixIcon: Icon(Icons.search, color: Colors.deepPurple),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.deepPurple[50],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text(
                  'Admin Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.add, color: Colors.blueAccent),
                title: Text('Ajouter un Livre'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookForm(
                        onFormSubmitted: _loadBooks,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text('Déconnexion'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          ),
        ),
      ),
      body: FutureBuilder<List<Book>>(
        future: _futureBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun livre disponible'));
          } else {
            final books = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Auteur: ${book.author}',
                              style: TextStyle(fontSize: 14)),
                          Text('Catégorie: ${book.category}',
                              style: TextStyle(fontSize: 14)),
                          Text('Disponible: ${book.available ? "Oui" : "Non"}',
                              style: TextStyle(fontSize: 14)),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BookForm(
                                        book: book,
                                        onFormSubmitted: _loadBooks,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  try {
                                    await _bookService.deleteBook(book.id);
                                    _loadBooks();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Livre supprimé avec succès')),
                                    );
                                  } catch (error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Erreur : ${error.toString()}')),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
