/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    int totalBooks = bookProvider.books.length;
    int totalTransactions = transactionProvider.transactions.length;
    int booksInCirculation = transactionProvider.transactions
        .where((t) => t.returnDate == null)
        .length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Library Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildReportCard('Total Books', totalBooks.toString()),
          _buildReportCard('Total Transactions', totalTransactions.toString()),
          _buildReportCard('Books in Circulation', booksInCirculation.toString()),
          SizedBox(height: 24),
          Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildRecentTransactionsList(transactionProvider.transactions),
          SizedBox(height: 24),
          Text(
            'Most Popular Books',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildPopularBooksList(bookProvider.books, transactionProvider.transactions),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _generatePdfReport(context, bookProvider, transactionProvider),
                child: Text('PDF Report'),
              ),
              ElevatedButton(
                onPressed: () => _generateExcelReport(context, bookProvider, transactionProvider),
                child: Text('Excel Report'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String value) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 18)),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsList(List<Transaction> transactions) {
    final recentTransactions = transactions.take(5).toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recentTransactions.length,
      itemBuilder: (context, index) {
        final transaction = recentTransactions[index];
        return ListTile(
          title: Text('Book ID: ${transaction.bookId}'),
          subtitle: Text('Member: ${transaction.memberName}'),
          trailing: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction.issuedDate))),
        );
      },
    );
  }

  Widget _buildPopularBooksList(List<Book> books, List<Transaction> transactions) {
    final bookIssueCounts = <int, int>{};
    for (var transaction in transactions) {
      bookIssueCounts[transaction.bookId] = (bookIssueCounts[transaction.bookId] ?? 0) + 1;
    }

    final sortedBooks = books.where((book) => bookIssueCounts.containsKey(book.id!))
        .toList()
      ..sort((a, b) => (bookIssueCounts[b.id!] ?? 0).compareTo(bookIssueCounts[a.id!] ?? 0));

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: sortedBooks.length > 5 ? 5 : sortedBooks.length,
      itemBuilder: (context, index) {
        final book = sortedBooks[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          trailing: Text('Issues: ${bookIssueCounts[book.id]}'),
        );
      },
    );
  }

  Future<void> _generatePdfReport(BuildContext context, BookProvider bookProvider, TransactionProvider transactionProvider) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, child: pw.Text('Library Report')),
              pw.Header(level: 1, child: pw.Text('Overview')),
              pw.Paragraph(text: 'Total Books: ${bookProvider.books.length}'),
              pw.Paragraph(text: 'Total Transactions: ${transactionProvider.transactions.length}'),
              pw.Paragraph(text: 'Books in Circulation: ${transactionProvider.transactions.where((t) => t.returnDate == null).length}'),
              pw.Header(level: 1, child: pw.Text('Recent Transactions')),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Book ID', 'Member Name', 'Issue Date'],
                  ...transactionProvider.transactions.take(5).map((t) => [t.bookId.toString(), t.memberName, t.issuedDate]),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/library_report.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  Future<void> _generateExcelReport(BuildContext context, BookProvider bookProvider, TransactionProvider transactionProvider) async {
    var excel = Excel.createExcel();

    excel.sheets['Sheet1']!.cell(CellIndex.indexByString('A1')).value = 'Library Report';
    excel.sheets['Sheet1']!.cell(CellIndex.indexByString('A2')).value = 'Total Books';
    excel.sheets['Sheet1']!.cell(CellIndex.indexByString('B2')).value = bookProvider.books.length;
    excel.sheets['Sheet1']!.cell(CellIndex.indexByString('A3')).value = 'Total Transactions';
    excel.sheets['Sheet1']!.cell(CellIndex.indexByString('B3')).value = transactionProvider.transactions.length;
    excel.sheets['Sheet1']!.cell(CellIndex.indexByString('A4')).value = 'Books in Circulation';
    excel.sheets['Sheet1']!.cell(CellIndex.indexByString('B4')).value = transactionProvider.transactions.where((t) => t.returnDate == null).length;

    excel.sheets['Sheet1']!.cell(CellIndex.indexByString('A6')).value = 'Recent Transactions';
    excel.sheets['Sheet1']!.cell(CellIndex.indexByString('A7')).value = 'Book ID';
    excel.sheets['Sheet1']!.cell(CellIndex.indexByString('B7')).value = 'Member Name';
    excel.sheets['Sheet1']!.cell(CellIndex.indexByString('C7')).value = 'Issue Date';

    for (var i = 0; i < 5 && i < transactionProvider.transactions.length; i++) {
      var transaction = transactionProvider.transactions[i];
      excel.sheets['Sheet1']!.cell(CellIndex.indexByString('A${8 + i}')).value = transaction.bookId;
      excel.sheets['Sheet1']!.cell(CellIndex.indexByString('B${8 + i}')).value = transaction.memberName;
      excel.sheets['Sheet1']!.cell(CellIndex.indexByString('C${8 + i}')).value = transaction.issuedDate;
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/library_report.xlsx');
    await file.writeAsBytes(excel.encode()!);

    OpenFile.open(file.path);
  }
}*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    int totalBooks = bookProvider.books.length;
    int totalTransactions = transactionProvider.transactions.length;
    int booksInCirculation = transactionProvider.transactions
        .where((t) => t.returnDate == null)
        .length;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Library Overview',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildReportCard('Total Books', totalBooks.toString()),
          _buildReportCard('Total Transactions', totalTransactions.toString()),
          _buildReportCard('Books in Circulation', booksInCirculation.toString()),
          SizedBox(height: 24),
          Text(
            'Recent Transactions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildRecentTransactionsList(transactionProvider.transactions),
          SizedBox(height: 24),
          Text(
            'Most Popular Books',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildPopularBooksList(bookProvider.books, transactionProvider.transactions),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _generatePdfReport(context, bookProvider, transactionProvider),
                child: Text('PDF Report'),
              ),
              ElevatedButton(
                onPressed: () => _generateExcelReport(context, bookProvider, transactionProvider),
                child: Text('Excel Report'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String value) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: TextStyle(fontSize: 18)),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactionsList(List<Transaction> transactions) {
    final recentTransactions = transactions.take(5).toList();
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: recentTransactions.length,
      itemBuilder: (context, index) {
        final transaction = recentTransactions[index];
        return ListTile(
          title: Text('Book ID: ${transaction.bookId}'),
          subtitle: Text('Member: ${transaction.memberName}'),
          trailing: Text(DateFormat('yyyy-MM-dd').format(DateTime.parse(transaction.issuedDate))),
        );
      },
    );
  }

  Widget _buildPopularBooksList(List<Book> books, List<Transaction> transactions) {
    final bookIssueCounts = <int, int>{};
    for (var transaction in transactions) {
      bookIssueCounts[transaction.bookId] = (bookIssueCounts[transaction.bookId] ?? 0) + 1;
    }

    final sortedBooks = books.where((book) => bookIssueCounts.containsKey(book.id!))
        .toList()
      ..sort((a, b) => (bookIssueCounts[b.id!] ?? 0).compareTo(bookIssueCounts[a.id!] ?? 0));

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: sortedBooks.length > 5 ? 5 : sortedBooks.length,
      itemBuilder: (context, index) {
        final book = sortedBooks[index];
        return ListTile(
          title: Text(book.title),
          subtitle: Text(book.author),
          trailing: Text('Issues: ${bookIssueCounts[book.id]}'),
        );
      },
    );
  }

  Future<void> _generatePdfReport(BuildContext context, BookProvider bookProvider, TransactionProvider transactionProvider) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Header(level: 0, child: pw.Text('Library Report')),
            pw.Header(level: 1, child: pw.Text('Overview')),
            pw.Paragraph(text: 'Total Books: ${bookProvider.books.length}'),
            pw.Paragraph(text: 'Total Transactions: ${transactionProvider.transactions.length}'),
            pw.Paragraph(text: 'Books in Circulation: ${transactionProvider.transactions.where((t) => t.returnDate == null).length}'),
            pw.Header(level: 1, child: pw.Text('All Transactions')),
            pw.Table.fromTextArray(
              context: context,
              headers: ['Book ID', 'Member Name', 'Issue Date', 'Return Date', 'Payment Amount'],
              data: transactionProvider.transactions.map((t) => [
                t.bookId.toString(),
                t.memberName,
                t.issuedDate,
                t.returnDate ?? 'Not returned',
                '\$${t.paymentAmount.toStringAsFixed(2)}',
              ]).toList(),
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/library_report.pdf');
    await file.writeAsBytes(await pdf.save());

    OpenFile.open(file.path);
  }

  Future<void> _generateExcelReport(BuildContext context, BookProvider bookProvider, TransactionProvider transactionProvider) async {
    var excel = Excel.createExcel();

    // Overview sheet
    var overviewSheet = excel['Overview'];
    overviewSheet.cell(CellIndex.indexByString('A1')).value = 'Library Report Overview';
    overviewSheet.cell(CellIndex.indexByString('A2')).value = 'Total Books';
    overviewSheet.cell(CellIndex.indexByString('B2')).value = bookProvider.books.length;
    overviewSheet.cell(CellIndex.indexByString('A3')).value = 'Total Transactions';
    overviewSheet.cell(CellIndex.indexByString('B3')).value = transactionProvider.transactions.length;
    overviewSheet.cell(CellIndex.indexByString('A4')).value = 'Books in Circulation';
    overviewSheet.cell(CellIndex.indexByString('B4')).value = transactionProvider.transactions.where((t) => t.returnDate == null).length;

    // Transactions sheet
    var transactionsSheet = excel['Transactions'];
    transactionsSheet.cell(CellIndex.indexByString('A1')).value = 'Book ID';
    transactionsSheet.cell(CellIndex.indexByString('B1')).value = 'Member Name';
    transactionsSheet.cell(CellIndex.indexByString('C1')).value = 'Issue Date';
    transactionsSheet.cell(CellIndex.indexByString('D1')).value = 'Return Date';
    transactionsSheet.cell(CellIndex.indexByString('E1')).value = 'Payment Amount';

    for (var i = 0; i < transactionProvider.transactions.length; i++) {
      var transaction = transactionProvider.transactions[i];
      transactionsSheet.cell(CellIndex.indexByString('A${i + 2}')).value = transaction.bookId;
      transactionsSheet.cell(CellIndex.indexByString('B${i + 2}')).value = transaction.memberName;
      transactionsSheet.cell(CellIndex.indexByString('C${i + 2}')).value = transaction.issuedDate;
      transactionsSheet.cell(CellIndex.indexByString('D${i + 2}')).value = transaction.returnDate ?? 'Not returned';
      transactionsSheet.cell(CellIndex.indexByString('E${i + 2}')).value = transaction.paymentAmount;
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/library_report.xlsx');
    await file.writeAsBytes(excel.encode()!);

    OpenFile.open(file.path);
  }
}


