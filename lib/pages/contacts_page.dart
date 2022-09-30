import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ft_hangouts/database_controller.dart';

class contactsPage extends StatefulWidget {
  const contactsPage({super.key});

  @override
  State<contactsPage> createState() => _contactsPageState();
}

class _contactsPageState extends State<contactsPage> {
  List<Map>? _contactList;
  void _getContacts() async {
    _contactList = await databaseController.instance.getContacts();
    print('debug');
    print(_contactList);
  }

  initState() {
    _getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
