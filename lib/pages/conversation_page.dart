import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:ft_hangouts/database_controller.dart';
import '../models/contact.dart';
import 'text_message.dart';
import '../main.dart';
import 'package:intl/intl.dart';

class conversationPage extends StatefulWidget {
  final ValueNotifier<bool> smsUpdater;
  final int contactId;

  conversationPage(this.contactId, this.smsUpdater);

  @override
  State<conversationPage> createState() => _conversationPageState();
}

class _conversationPageState extends State<conversationPage> {
  List<Map<String, dynamic>>? _messages;
  Contact? _contactInfos;
  String senderProfile = 'images/avatar/profile-placeholder.jpg';
  String receiverProfile = 'images/avatar/profile-placeholder.jpg';

  Future<void> getConversationWithContact() async {
    databaseController.instance
        .getConversationWithContact(widget.contactId)
        .then((value) {
      List<Map<String, dynamic>> tmp = [];
      for (final val in value) {
        tmp.add(Map.of(val));
      }
      _messages = tmp;
      for (final message in _messages!) {
        message['date'] = DateFormat("yy-MM-dd").format(
            DateTime.fromMillisecondsSinceEpoch(message['datetime'] * 1000));
        message['time'] =
            DateTime.fromMillisecondsSinceEpoch(message['datetime'] * 1000)
                    .hour
                    .toString() +
                ':' +
                DateTime.fromMillisecondsSinceEpoch(message['datetime'] * 1000)
                    .minute
                    .toString();
      }
      _messages!.add({
        'message': 'localtest',
        'date': _messages![0]['date'],
        'time': _messages![0]['time'],
        'mine': 1
      });
      print('date=' + _messages![0]['date']);
      print('time=' + _messages![0]['time']);
    });
    databaseController.instance
        .getContactFromId(widget.contactId.toString())
        .then((value) {
      _contactInfos = new Contact(
          id: value[0]['id'],
          firstName: value[0]['firstName'],
          lastName: value[0]['lastName'],
          phoneNumber: value[0]['phoneNumber']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.smsUpdater,
        builder: ((context, value, child) {
          return FutureBuilder(
              future: getConversationWithContact(),
              builder: (BuildContext context, toto) {
                if (toto.connectionState != ConnectionState.done ||
                    _contactInfos == null) {
                  return SizedBox.shrink();
                } else {
                  return Scaffold(
                      appBar: AppBar(
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                          title: Text(_contactInfos!.firstName! +
                              ' ' +
                              _contactInfos!.lastName!)),
                      body: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: SingleChildScrollView(
                          child: Column(
                            children: _messages?.map<Widget>((message) {
                                  return TextMessage(
                                      message: message['message'],
                                      date: message['date'],
                                      time: message['time'],
                                      senderProfile: senderProfile,
                                      isMine: message['mine']);
                                  // const SizedBox(height: 15),
                                }).toList() ??
                                []
                            /*[
                              TextMessage(
                                message: "Next it draw in draw much bred",
                                date: "16:50",
                                senderProfile: senderProfile,
                                isReceiver: 0,
                              ),
                              const SizedBox(height: 15),
                            ]*/
                            ,
                          ),
                        ),
                      ));
                }
              });
        }));
  }
}
