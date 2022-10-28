import 'package:flutter/material.dart';
import 'package:ft_hangouts/main.dart';
import 'package:ft_hangouts/utils/utils.dart';
import '../models/models.dart';
import 'text_message.dart';
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
  String? appUserProfilePicture;
  final smsToSendController = TextEditingController();

  Future<String> getFavPP() async {
    return await sharedPrefHelper.getFavProfilePicture();
  }

  Future<void> getConversationWithContact() async {
    List<Map<String, dynamic>> msgList = await databaseController.instance
        .getConversationWithContact(widget.contactId);
    appUserProfilePicture = await getFavPP();
    _messages = await getMessagesWithDate(msgList);
    _contactInfos = await getContactInfos();
    await databaseController.instance
        .updateUnreadMessages(widget.contactId, true);
  }

  Future<List<Map<String, dynamic>>> getMessagesWithDate(
      List<Map<String, dynamic>> msgList) async {
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Expanded(
                                child: SingleChildScrollView(
                              child: Column(
                                children: _messages?.map<Widget>((message) {
                                      return TextMessage(
                                          message: message['message'],
                                          date: message['date'],
                                          time: message['time'],
                                          senderProfile: message['mine'] == 0
                                              ? message['profilePicture']
                                              : appUserProfilePicture,
                                          isMine: message['mine']);
                                      // const SizedBox(height: 15),
                                    }).toList() ??
                                    [],
                              ),
                            )),
                            Row(children: [
                              Expanded(
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: TextFormField(
                                        controller: smsToSendController,
                                        keyboardType: TextInputType.multiline,
                                        textInputAction:
                                            TextInputAction.newline,
                                        minLines: 1,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          border: OutlineInputBorder(),
                                        ),
                                      ))),
                              IconButton(
                                padding: const EdgeInsets.all(4.0),
                                onPressed: () async {
                                  setState(() {
                                    sms_controller
                                        .sendSms(_contactInfos!.phoneNumber!,
                                            smsToSendController.text)
                                        .then((value) {
                                      sms_controller
                                          .storeMessageInDb(
                                              smsToSendController.text,
                                              _contactInfos!.phoneNumber!,
                                              1)
                                          .then((value) {
                                        widget.smsUpdater.value =
                                            !widget.smsUpdater.value;
                                        smsToSendController.clear();
                                      });
                                    });
                                    //_messages.add;
                                  });
                                },
                                color: globalColor.value.shade700,
                                icon: Icon(Icons.send_rounded),
                              )
                            ])
                          ],
                        ),
                      ));
                }
              });
        }));
  }
}
