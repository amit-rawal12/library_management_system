import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';

class Reservation {
  final int? id;
  final int bookId;
  final int memberId;
  final String reservationDate;

  Reservation({
    this.id,
    required this.bookId,
    required this.memberId,
    required this.reservationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'memberId': memberId,
      'reservationDate': reservationDate,
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'],
      bookId: map['bookId'],
      memberId: map['memberId'],
      reservationDate: map['reservationDate'],
    );
  }
}

class ReservationProvider with ChangeNotifier {
  List<Reservation> _reservations = [];

  List<Reservation> get reservations => _reservations;

  Future<void> fetchReservations() async {
    final reservationMaps = await DatabaseHelper.instance.queryAllReservations();
    _reservations = reservationMaps.map((map) => Reservation.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addReservation(Reservation reservation) async {
    try {
      final id = await DatabaseHelper.instance.insertReservation(reservation.toMap());
      final newReservation = Reservation(
        id: id,
        bookId: reservation.bookId,
        memberId: reservation.memberId,
        reservationDate: reservation.reservationDate,
      );
      _reservations.add(newReservation);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add reservation: $e');
    }
  }
}

