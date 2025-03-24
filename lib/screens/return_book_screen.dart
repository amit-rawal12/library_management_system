import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';

class ReturnBookScreen extends StatefulWidget {
  final Transaction transaction;

  const ReturnBookScreen({Key? key, required this.transaction}) : super(key: key);

  @override
  _ReturnBookScreenState createState() => _ReturnBookScreenState();
}

class _ReturnBookScreenState extends State<ReturnBookScreen> {
  late String _returnDate;

  @override
  void initState() {
    super.initState();
    _returnDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _returnBook(BuildContext context) async {
    final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
    try {
      await transactionProvider.returnBook(widget.transaction.id!, _returnDate);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book returned successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error returning book: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Return Book'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Book ID: ${widget.transaction.bookId}'),
            Text('Member Name: ${widget.transaction.memberName}'),
            Text('Issued Date: ${widget.transaction.issuedDate}'),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Return Date'),
              initialValue: _returnDate,
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _returnDate = DateFormat('yyyy-MM-dd').format(picked);
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _returnBook(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text('Return Book'),
            ),
          ],
        ),
      ),
    );
  }
}

