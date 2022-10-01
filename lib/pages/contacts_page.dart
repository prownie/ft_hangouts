import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ft_hangouts/database_controller.dart';
import 'package:ft_hangouts/constants.dart';
import 'package:ft_hangouts/pages/chat_page.dart';

class contactsPage extends StatefulWidget {
  const contactsPage({super.key});

  @override
  State<contactsPage> createState() => _contactsPageState();
}

class _contactsPageState extends State<contactsPage> {
  List<Map>? _contactList;
  final List messages = [
    {
      'senderProfile':
          'images/avatar/christopher-campbell-rDEOVtE7vOs-unsplash.jpg',
      'senderName': 'Lara',
      'message': 'Hello! how are you',
      'unRead': 0,
      'date': '16:35',
    },
    {
      'senderProfile': 'images/avatar/erik-lucatero-d2MSDujJl2g-unsplash.jpg',
      'senderName': 'Stive',
      'message': 'Hello! how are you',
      'unRead': 3,
      'date': '07:31',
    },
    {
      'senderProfile': 'images/avatar/huston-wilson-nJHvhXS4C0U-unsplash.jpg',
      'senderName': 'Stive',
      'message': 'Hello! how are you',
      'unRead': 3,
      'date': '07:31',
    },
    {
      'senderProfile': 'images/avatar/joseph-gonzalez-iFgRcqHznqg-unsplash.jpg',
      'senderName': 'Stive',
      'message': 'Hello! how are you',
      'unRead': 3,
      'date': '07:31',
    },
    {
      'senderProfile': 'images/avatar/matheus-ferrero-pg_WCHWSdT8-unsplash.jpg',
      'senderName': 'Stive',
      'message': 'Hello! how are you',
      'unRead': 3,
      'date': '07:31',
    },
    {
      'senderProfile': 'images/avatar/matheus-ferrero-pg_WCHWSdT8-unsplash.jpg',
      'senderName': 'Stive',
      'message': 'Hello! how are you',
      'unRead': 3,
      'date': '07:31',
    },
    {
      'senderProfile': 'images/avatar/matheus-ferrero-pg_WCHWSdT8-unsplash.jpg',
      'senderName': 'Stive',
      'message': 'Hello! how are you',
      'unRead': 3,
      'date': '07:31',
    },
  ];

  initState() {
    databaseController.instance.getContacts().then((value) {
      _contactList = value;
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: messages.map<Widget>((message) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const chatPage(),
                ),
              );
            },
            splashColor: Constants.Blue,
            child: Container(
              padding: const EdgeInsets.only(left: 30, right: 10, top: 15),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 23),
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(message['senderProfile']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    message['senderName'],
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Wrap(children: [
                                    Text(
                                      message['message'],
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ]),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(message['date']),
                                message['unRead'] != 0
                                    ? Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                          color: Constants.Blue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          message['unRead'].toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          color: Colors.grey[400],
                          height: 0.5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
//{id: 1, firstName: Robin, lastName: Pichon, phoneNumber: 0123456789}
