import 'package:flutter/material.dart';
import 'package:ft_hangouts/utils/database_controller.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'models/models.dart';
import 'pages/pages.dart';
import 'main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  ValueNotifier<bool> updater = ValueNotifier(false);
  ValueNotifier<bool> smsUpdater = ValueNotifier(false);
  final List<AppLifecycleState> _stateHistoryList = <AppLifecycleState>[];
  int _selectedIndex = 0;
  DateTime? appPausedDatetime;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {
      _stateHistoryList.add(WidgetsBinding.instance.lifecycleState!);
    }
    _widgetOptions = <Widget>[
      conversationsPage(smsUpdater),
      contactsPage(updater),
      profile(),
    ];
    _selectedIndex = _selectedIndex;
    sms_controller.initPermission();
    sms_controller().smsReceived().listen((event) {
      sms_controller
          .storeMessageInDb(event['message'], event['sender'], 0)
          .then((value) {
        updater.value = !updater.value;
        smsUpdater.value = !smsUpdater.value;
        print('smsupdater Updated');
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _stateHistoryList.add(state);
      if (_stateHistoryList[_stateHistoryList.length - 1] ==
          AppLifecycleState.paused) {
        appPausedDatetime = DateTime.now();
      } else if (_stateHistoryList[_stateHistoryList.length - 1] ==
          AppLifecycleState.resumed) {
        if (appPausedDatetime != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)!.appHasBeenPaused +
                    appPausedDatetime!.hour.toString() +
                    ':' +
                    appPausedDatetime!.minute.toString())),
          );
        }
      }
      ;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _getActionButton(BuildContext context) {
    if (_selectedIndex != 2) {
      if (_selectedIndex == 0) {
        return FloatingActionButton.extended(
            label: Text(AppLocalizations.of(context)!.newMessage),
            icon: const Icon(Icons.message_rounded),
            foregroundColor: Color.fromARGB(255, 239, 239, 241),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => createDiscussion(smsUpdater),
                ),
              );
            });
      } else if (_selectedIndex == 1) {
        return FloatingActionButton.extended(
            label: Text(AppLocalizations.of(context)!.newContact),
            icon: const Icon(Icons.perm_contact_cal_rounded),
            foregroundColor: Color.fromARGB(255, 239, 239, 241),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => createContact(updater),
                ),
              );
            });
      }
    }
    return SizedBox.shrink();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ft_hangouts'),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: _getActionButton(context),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.message_outlined), label: 'Discussions'),
            BottomNavigationBarItem(
                icon: Icon(Icons.contact_page_outlined), label: 'Contacts'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped),
    );
  }
}
