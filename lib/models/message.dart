import 'package:flutter/material.dart';

class Message {
  final String message;
  final int contactId;
  final int mine;
  final int? datetime;

  Message({
    required final String this.message,
    required final int this.contactId,
    required final int this.mine,
    final int? this.datetime,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'contactId': contactId,
      'mine': mine,
      'datetime': datetime,
    };
  }
}
