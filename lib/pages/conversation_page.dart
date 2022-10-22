import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class conversationPage extends StatefulWidget {
  final ValueNotifier<bool> updater;
  final String contactId;

  conversationPage(this.contactId, this.updater);

  @override
  State<conversationPage> createState() => _conversationPageState();
}

class _conversationPageState extends State<conversationPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
