// lib/models/book.dart

class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final bool available;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.available,
  });

  // Convertir un livre en un objet JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'available': available,
    };
  }

  // Convertir un JSON en un livre
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      author: json['author'],
      category: json['category'],
      available: json['available'],
    );
  }
}
