class BorrowedBook {
  final String id;
  final Book book;
  final DateTime returnDate;
  final bool returned;

  BorrowedBook({
    required this.id,
    required this.book,
    required this.returnDate,
    required this.returned,
  });

  factory BorrowedBook.fromJson(Map<String, dynamic> json) {
    return BorrowedBook(
      id: json['_id'],
      book: Book.fromJson(json['bookId']),
      returnDate: DateTime.parse(json['returnDate']),
      returned: json['returned'],
    );
  }
}

class Book {
  final String id;
  final String title;

  Book({
    required this.id,
    required this.title,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
    );
  }
}
