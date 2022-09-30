import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/contacts_page.dart';
import 'package:ft_hangouts/pages/conversations_page.dart';
import 'package:ft_hangouts/pages/profile.dart';
import 'dart:async';
import 'menu_section.dart';
import 'package:flutter/services.dart';
// import 'sms_helper.dart';

const Blue = Color.fromARGB(255, 68, 137, 202);
const White = Color.fromARGB(255, 216, 229, 227);
const Black = Color.fromARGB(255, 38, 37, 35);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    conversationsPage(),
    contactsPage(),
    profile(),
  ];

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
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
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
