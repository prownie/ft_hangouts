import 'package:flutter/material.dart';

class Contact {
  final String firstName;
  final String lastName;
  final String phoneNumber;

  Contact({
    required final String this.firstName,
    required final String this.lastName,
    required final String this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    };
  }
}
