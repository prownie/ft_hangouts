import 'package:flutter/material.dart';
import 'package:ft_hangouts/database_controller.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'models/models.dart';
import 'pages/pages.dart';
import 'main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<bool> updater = ValueNotifier(false);
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    _widgetOptions = <Widget>[
      conversationsPage(),
      contactsPage(updater),
      profile(),
    ];
    _selectedIndex = _selectedIndex;
  }

  Widget _getActionButton() {
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
                  builder: (context) => createDiscussion(),
                ),
              );
            });
        // onPressed: () {
        //   globalColor.value = Colors.pink;
        //   print('new color = ${globalColor.value}');
        // });
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
      floatingActionButton: _getActionButton(),
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

// class HomePage extends StatelessWidget {
//   static const platform = MethodChannel('ft_hangouts.com');
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('ft_hangouts'),
//         elevation: 0,
//         backgroundColor: Black,
//         leading: IconButton(
//           onPressed: () async {
//             await platform.invokeMethod("requestPermissionForSms");
//           },
//           icon: const Icon(
//             Icons.menu,
//             color: White,
//             size: 30,
//           ),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {},
//               icon: const Icon(
//                 Icons.account_circle,
//                 color: White,
//                 size: 30,
//               ))
//         ],
//       ),
//       body: Column(
//         children: [
//           MenuSection(),
//           // FavoriteSection(),
//           // Expanded(child: MessageSection())
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//           onPressed: () {},
//           backgroundColor: Blue,
//           child: const Icon(
//             Icons.edit,
//             size: 20,
//           )),
//       // bottomNavigationBar: NavigationBar(
//       //   height: 60,
//       // ),
//     );
//   }
// }
