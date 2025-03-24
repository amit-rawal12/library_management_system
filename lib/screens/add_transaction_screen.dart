/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _bookId;
  String? _memberName;
  String? _memberPhone;
  String? _memberAddress;
  late String _issuedDate;
  String? _returnDate; // Add a variable for return date

  @override
  void initState() {
    super.initState();
    _issuedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _addTransaction(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
      try {
        await transactionProvider.addTransaction(Transaction(
          bookId: _bookId!,
          memberName: _memberName!,
          memberPhone: _memberPhone!,
          memberAddress: _memberAddress!,
          issuedDate: _issuedDate,
          returnDate: _returnDate, // Save the return date
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding transaction: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Book'),
                items: bookProvider.books.map((book) {
                  return DropdownMenuItem(
                    value: book.id,
                    child: Text(book.title),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a book';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _bookId = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Member Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a member name';
                  }
                  return null;
                },
                onSaved: (value) => _memberName = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Member Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                onSaved: (value) => _memberPhone = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Member Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
                onSaved: (value) => _memberAddress = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Issued Date'),
                initialValue: _issuedDate,
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
                      _issuedDate = DateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Return Date',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                controller: TextEditingController(text: _returnDate ?? ''),
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
                onPressed: () => _addTransaction(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _bookId;
  String? _memberName;
  String? _memberPhone;
  String? _memberAddress;
  late String _issuedDate;
  String? _returnDate;
  double _paymentAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _issuedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _addTransaction(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
      try {
        await transactionProvider.addTransaction(Transaction(
          bookId: _bookId!,
          memberName: _memberName!,
          memberPhone: _memberPhone!,
          memberAddress: _memberAddress!,
          issuedDate: _issuedDate,
          returnDate: _returnDate,
          paymentAmount: _paymentAmount,
        ));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding transaction: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
        backgroundColor: const Color(0xFFF68056),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: 'Book'),
                items: bookProvider.books.map((book) {
                  return DropdownMenuItem(
                    value: book.id,
                    child: Text(book.title),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a book';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _bookId = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Member Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a member name';
                  }
                  return null;
                },
                onSaved: (value) => _memberName = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Member Phone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
                onSaved: (value) => _memberPhone = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Member Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
                onSaved: (value) => _memberAddress = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Issued Date'),
                initialValue: _issuedDate,
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
                      _issuedDate = DateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Return Date',
                  labelStyle: TextStyle(color: Colors.black),
                ),
                controller: TextEditingController(text: _returnDate ?? ''),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Payment Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a payment amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) => _paymentAmount = double.parse(value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _addTransaction(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF68056),
                ),
                child: const Text('Add Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

