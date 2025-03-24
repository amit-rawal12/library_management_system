/*import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';

class Transaction {
  final int? id;
  final int bookId;
  final String memberName;
  final String memberPhone;
  final String memberAddress;
  final String issuedDate;
  late final String? returnDate;


  Transaction({
    this.id,
    required this.bookId,
    required this.memberName,
    required this.memberPhone,
    required this.memberAddress,
    required this.issuedDate,
    this.returnDate, required double paymentAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'memberName': memberName,
      'memberPhone': memberPhone,
      'memberAddress': memberAddress,
      'issuedDate': issuedDate,
      'returnDate': returnDate,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      bookId: map['bookId'],
      memberName: map['memberName'],
      memberPhone: map['memberPhone'] ?? '',
      memberAddress: map['memberAddress'] ?? '',
      issuedDate: map['issuedDate'],
      returnDate: map['returnDate'], paymentAmount: null,
    );
  }
}


class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  // Add Transaction method
  Future<void> addTransaction(Transaction transaction) async {
    try {
      // Yahan aap apna transaction add kar sakte hain
      _transactions.add(transaction);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  // Return Book method (updated)
  Future<void> returnBook(int transactionId, String returnDate) async {
    try {
      // Transaction ko find kar rahe hain
      final transaction = _transactions.firstWhere((t) => t.id == transactionId);

      // Return date ko set kar rahe hain
      transaction.returnDate = returnDate;

      // Database mein bhi update karna hai
      await DatabaseHelper.instance.updateTransactionReturnDate(transactionId, returnDate);

      notifyListeners();  // UI ko notify karein update hone ke baad
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }
}*/



import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';

class Transaction {
  final int? id;
  final int bookId;
  final String memberName;
  final String memberPhone;
  final String memberAddress;
  final String issuedDate;
  String? returnDate;
  final double paymentAmount;

  Transaction({
    this.id,
    required this.bookId,
    required this.memberName,
    required this.memberPhone,
    required this.memberAddress,
    required this.issuedDate,
    this.returnDate,
    required this.paymentAmount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'memberName': memberName,
      'memberPhone': memberPhone,
      'memberAddress': memberAddress,
      'issuedDate': issuedDate,
      'returnDate': returnDate,
      'paymentAmount': paymentAmount,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      bookId: map['bookId'],
      memberName: map['memberName'],
      memberPhone: map['memberPhone'] ?? '',
      memberAddress: map['memberAddress'] ?? '',
      issuedDate: map['issuedDate'],
      returnDate: map['returnDate'],
      paymentAmount: map['paymentAmount'] ?? 0.0,
    );
  }
}

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions => _transactions;

  Future<void> fetchTransactions() async {
    final transactionMaps = await DatabaseHelper.instance.queryAllTransactions();
    _transactions = transactionMaps.map((map) => Transaction.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      final id = await DatabaseHelper.instance.insertTransaction(transaction.toMap());
      final newTransaction = Transaction(
        id: id,
        bookId: transaction.bookId,
        memberName: transaction.memberName,
        memberPhone: transaction.memberPhone,
        memberAddress: transaction.memberAddress,
        issuedDate: transaction.issuedDate,
        paymentAmount: transaction.paymentAmount,
      );
      _transactions.add(newTransaction);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  Future<void> returnBook(int transactionId, String returnDate) async {
    try {
      await DatabaseHelper.instance.updateTransactionReturnDate(transactionId, returnDate);
      final index = _transactions.indexWhere((t) => t.id == transactionId);
      if (index != -1) {
        _transactions[index].returnDate = returnDate;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }
}

