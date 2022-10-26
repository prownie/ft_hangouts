import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Contact {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final int? id;
  final int? unreadMessages;
  final String? profilePicture;

  Contact(
      {required String this.firstName,
      String? this.lastName,
      required String this.phoneNumber,
      this.id,
      this.unreadMessages,
      this.profilePicture});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'id': id,
      'unreadMessages': unreadMessages
    };
  }
}
