import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:ft_hangouts/utils/database_controller.dart';
import '../models/contact.dart';
import 'text_message.dart';
import '../main.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

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
  String senderProfile = 'assets/images/avatar/profile-placeholder.jpg';
  String receiverProfile = 'assets/images/avatar/profile-placeholder.jpg';

  Future<void> getConversationWithContact() async {
    List<Map<String, dynamic>> msgList = await databaseController.instance.getConversationWithContact(widget.contactId);
    _messages = await getMessagesWithDate(msgList);
    _contactInfos = await getContactInfos();
    await databaseController.instance.updateUnreadMessages(widget.contactId, true);
  }

  Future<List<Map<String, dynamic>>> getMessagesWithDate(List<Map<String, dynamic>> msgList) async {
    // need to make a copy because saflite return are readonly
    List<Map<String, dynamic>> tmp = [];
    for (final message in msgList) {
      tmp.add(Map.of(message));
    }
    for (final message in tmp) {
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
    tmp.add({
      'message': 'localtest',
      'date': tmp[0]['date'],
      'time': tmp[0]['time'],
      'mine': 1
    });
    return tmp;
  }

  Future<Contact> getContactInfos() async {
     Contact contact;
     List<Map<String, dynamic>> contactMap = await databaseController.instance
        .getContactFromId(widget.contactId.toString());
      contact = new Contact(
          id: contactMap[0]['id'],
          firstName: contactMap[0]['firstName'],
          lastName: contactMap[0]['lastName'],
          phoneNumber: contactMap[0]['phoneNumber']);
        return contact;
    }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.smsUpdater,
        builder: ((context, value, child) {
          return FutureBuilder(
              future: getConversationWithContact(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done ||
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
                            ,
                          ),
                        ),
                      ));
                }
              });
        }));
  }
}
