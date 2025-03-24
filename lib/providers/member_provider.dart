import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';

class Member {
  final int? id;
  final String name;
  final String phone;
  final String address;
  final String membershipType;
  final String membershipExpiryDate;

  Member({
    this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.membershipType,
    required this.membershipExpiryDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'membershipType': membershipType,
      'membershipExpiryDate': membershipExpiryDate,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      membershipType: map['membershipType'],
      membershipExpiryDate: map['membershipExpiryDate'],
    );
  }
}

class MemberProvider with ChangeNotifier {
  List<Member> _members = [];

  List<Member> get members => _members;

  Future<void> fetchMembers() async {
    final memberMaps = await DatabaseHelper.instance.queryAllMembers();
    _members = memberMaps.map((map) => Member.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addMember(Member member) async {
    try {
      final id = await DatabaseHelper.instance.insertMember(member.toMap());
      final newMember = Member(
        id: id,
        name: member.name,
        phone: member.phone,
        address: member.address,
        membershipType: member.membershipType,
        membershipExpiryDate: member.membershipExpiryDate,
      );
      _members.add(newMember);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }
}

