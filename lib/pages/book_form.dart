import 'package:flutter/material.dart';
import '../models/book.dart'; // Assurez-vous que votre modèle Book est bien importé
import '../services/book_service.dart';

class BookForm extends StatefulWidget {
  final Book? book;
  final Function? onFormSubmitted; // Callback à exécuter après soumission

  BookForm({this.book, this.onFormSubmitted});

  @override
  _BookFormState createState() => _BookFormState();
}

class _BookFormState extends State<BookForm> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _categoryController;
  late bool _available;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController = TextEditingController(text: widget.book!.title);
      _authorController = TextEditingController(text: widget.book!.author);
      _categoryController = TextEditingController(text: widget.book!.category);
      _available = widget.book!.available;
    } else {
      _titleController = TextEditingController();
      _authorController = TextEditingController();
      _categoryController = TextEditingController();
      _available = true; // Par défaut disponible
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book == null ? 'Ajouter un Livre' : 'Modifier un Livre',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Champ Titre
              _buildTextField(_titleController, 'Titre'),

              // Champ Auteur
              _buildTextField(_authorController, 'Auteur'),

              // Champ Catégorie
              _buildTextField(_categoryController, 'Catégorie'),

              // Switch Disponible
              SwitchListTile(
                title: Text('Disponible'),
                value: _available,
                onChanged: (value) {
                  setState(() {
                    _available = value;
                  });
                },
                activeColor: Colors.deepPurple,
              ),

              SizedBox(height: 20),

              // Bouton Ajouter/Modifier
              ElevatedButton(
                onPressed: () async {
                  final book = Book(
                    id: widget.book?.id ?? '', // Si un nouvel ajout, ID vide
                    title: _titleController.text,
                    author: _authorController.text,
                    category: _categoryController.text,
                    available: _available,
                  );

                  try {
                    if (widget.book == null) {
                      // Ajout
                      await BookService().addBook(book);
                    } else {
                      // Modification
                      await BookService().updateBook(book);
                    }
                    widget.onFormSubmitted?.call(); // Notifier le parent
                    Navigator.pop(context);
                  } catch (error) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Erreur : ${error.toString()}'),
                    ));
                  }
                },
                child: Text(
                  widget.book == null ? 'Ajouter' : 'Modifier',
                  style: TextStyle(
                      color:
                          Colors.white), // Changer la couleur du texte en blanc
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Couleur du bouton
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour simplifier la création des champs de texte
  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.deepPurple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
