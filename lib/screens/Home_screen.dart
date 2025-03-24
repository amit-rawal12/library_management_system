/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/transaction_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDashboardCard('Total Books', '${bookProvider.books.length}', Icons.book),
              _buildDashboardCard('Transactions', '${transactionProvider.transactions.length}', Icons.receipt_long),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildRecentTransactionsList(transactionProvider.transactions),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.orange),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsList(List<Transaction> transactions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length > 5 ? 5 : transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: Icon(Icons.book, color: Colors.orange),
          title: Text('Book ID: ${transaction.bookId}'),
          subtitle: Text('Issued to: ${transaction.memberName}'),
          trailing: Text(transaction.issuedDate),
        );
      },
    );
  }
}*/


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/transaction_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDashboardCard('Total Books', '${bookProvider.books.length}', Icons.book),
              _buildDashboardCard('Transactions', '${transactionProvider.transactions.length}', Icons.receipt_long),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          _buildRecentTransactionsList(transactionProvider.transactions),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Colors.orange),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 16)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsList(List<Transaction> transactions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length > 5 ? 5 : transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return ListTile(
          leading: Icon(Icons.book, color: Colors.orange),
          title: Text('Book ID: ${transaction.bookId}'),
          subtitle: Text('Issued to: ${transaction.memberName}'),
          trailing: Text(transaction.issuedDate),
        );
      },
    );
  }
}


