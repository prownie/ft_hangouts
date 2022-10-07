import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ft_hangouts/database_controller.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  void _createContacts() async {
    final _contactList = await databaseController.instance.CreationsForTest();
  }

  initState() {
    _createContacts();
  }
}
