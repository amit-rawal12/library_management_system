/*import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';

class Book {
  final int? id;
  final String title;
  final String author;
  final String isbn;
  final int quantity;

  Book({this.id, required this.title, required this.author, required this.isbn, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'quantity': quantity,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      isbn: map['isbn'],
      quantity: map['quantity'],
    );
  }
}

class BookProvider with ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  Future<void> fetchBooks() async {
    final bookMaps = await DatabaseHelper.instance.queryAllBooks();
    _books = bookMaps.map((map) => Book.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    final id = await DatabaseHelper.instance.insertBook(book.toMap());
    final newBook = Book(
      id: id,
      title: book.title,
      author: book.author,
      isbn: book.isbn,
      quantity: book.quantity,
    );
    _books.add(newBook);
    notifyListeners();
  }

  Future<void> updateBook(Book book) async {
    await DatabaseHelper.instance.updateBook(book.toMap());
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      _books[index] = book;
      notifyListeners();
    }
  }

  Future<void> deleteBook(int id) async {
    await DatabaseHelper.instance.deleteBook(id);
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }
}*/

import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';

class Book {
  final int? id;
  final String title;
  final String author;
  final String isbn;
  final int quantity;

  Book({this.id, required this.title, required this.author, required this.isbn, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'quantity': quantity,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      isbn: map['isbn'],
      quantity: map['quantity'],
    );
  }
}

class BookProvider with ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  Future<void> fetchBooks() async {
    final bookMaps = await DatabaseHelper.instance.queryAllBooks();
    _books = bookMaps.map((map) => Book.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addBook(Book book) async {
    final id = await DatabaseHelper.instance.insertBook(book.toMap());
    final newBook = Book(
      id: id,
      title: book.title,
      author: book.author,
      isbn: book.isbn,
      quantity: book.quantity,
    );
    _books.add(newBook);
    notifyListeners();
  }

  Future<void> updateBook(Book book) async {
    await DatabaseHelper.instance.updateBook(book.toMap());
    final index = _books.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      _books[index] = book;
      notifyListeners();
    }
  }

  Future<void> deleteBook(int id) async {
    await DatabaseHelper.instance.deleteBook(id);
    _books.removeWhere((book) => book.id == id);
    notifyListeners();
  }
}

