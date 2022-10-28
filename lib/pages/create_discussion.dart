import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/utils.dart';
import '../main.dart';

class createDiscussion extends StatefulWidget {
  final ValueNotifier<bool> smsUpdater;

  createDiscussion(this.smsUpdater);

  @override
  State<createDiscussion> createState() => createDiscussionState();
}

class createDiscussionState extends State<createDiscussion> {
  final smsToSendController = TextEditingController();
  late List<Map> _contactList;
  final List<String> filterContactList = [];
  String? contactSelected;
  dynamic contactFound = [];

  initState() {
    getListContact();
  }

  Future<void> getListContact() async {
    _contactList = await databaseController.instance.getContacts();
    for (final contact in _contactList) {
      filterContactList.add(contact['firstName'].toLowerCase() +
          ' ' +
          contact['lastName'].toLowerCase() +
          ' ' +
          contact['phoneNumber']);
    }
  }

  Future<void> selectContact(String value) async {
    var regex = new RegExp(r'.* ');
    var tmpContact = await databaseController.instance
        .getContactFromPhoneNumber(value.replaceAll(regex, ''));
    setState(() {
      contactSelected = value;
      contactFound = tmpContact;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.smsUpdater,
      builder: ((context, value, child) {
        return Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context, true),
                ),
                title: Text(AppLocalizations.of(context)!.newMessage)),
            body: Container(
              child: Column(
                children: [
                  RawAutocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      return filterContactList.where((String option) {
                        return option
                            .contains(textEditingValue.text.toLowerCase());
                      });
                    },
                    onSelected: (String selection) {
                      selectContact(selection);
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: textEditingController,
                        decoration: InputDecoration(
                          hintText: contactFound.isEmpty
                              ? AppLocalizations.of(context)!.selectContact
                              : contactFound[0]['firstName'] +
                                  ' ' +
                                  contactFound[0]['lastName'],
                        ),
                        focusNode: focusNode,
                        onFieldSubmitted: (String value) {
                          onFieldSubmitted();
                        },
                        validator: (String? value) {
                          if (!filterContactList.contains(value)) {
                            return 'Nothing selected.';
                          }
                          return null;
                        },
                      );
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Material(
                          child: SizedBox(
                              height: 200,
                              child: SingleChildScrollView(
                                  child: Column(
                                children: options.map((opt) {
                                  return InkWell(
                                      onTap: () {
                                        onSelected(opt);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.only(right: 60),
                                          child: Card(
                                              child: Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(10),
                                            child: Text(opt),
                                          ))));
                                }).toList(),
                              ))));
                    },
                  ),
                  Expanded(child: Container()),
                  Row(children: [
                    Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              controller: smsToSendController,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              minLines: 1,
                              maxLines: 5,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 0),
                                border: OutlineInputBorder(),
                              ),
                            ))),
                    IconButton(
                      padding: const EdgeInsets.all(4.0),
                      onPressed: () async {
                        setState(() {
                          sms_controller
                              .sendSms(contactFound[0]['phoneNumber'],
                                  smsToSendController.text)
                              .then((value) {
                            sms_controller
                                .storeMessageInDb(smsToSendController.text,
                                    contactFound[0]['phoneNumber'], 1)
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
      }),
    );
  }
}
