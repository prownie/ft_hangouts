import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Contact {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final int? id;

  Contact(
      {required final String this.firstName,
      required final String this.lastName,
      required final String this.phoneNumber,
      final this.id});

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'id': id
    };
  }
}
