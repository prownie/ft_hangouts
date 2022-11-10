import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../utils/utils.dart';
import '../pages/pages.dart';
import '../main.dart';

class contactsPage extends StatefulWidget {
  final ValueNotifier<bool> updater;

  contactsPage(this.updater);

  @override
  State<contactsPage> createState() => _contactsPageState();
}

class _contactsPageState extends State<contactsPage> {
  List<Map>? _contactList;

  Future<void> getContact() async {
    _contactList = await databaseController.instance.getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.updater,
        builder: ((context, value, child) {
          return FutureBuilder(
              future: getContact(),
              builder: (BuildContext context, toto) {
                if (toto.connectionState != ConnectionState.done) {
                  return SizedBox.shrink();
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: _contactList?.map<Widget>((contact) {
                            return InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => contactPage(
                                        contact['id'].toString(),
                                        widget.updater),
                                  ),
                                );
                              },
                              splashColor: globalColor.value.shade300,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 15),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                        radius: 31,
                                        backgroundColor:
                                            globalColor.value.shade900,
                                        child: CircleAvatar(
                                            radius: 28,
                                            backgroundImage: imageHelper
                                                .imageFromBase64String(
                                                    contact['profilePicture'])
                                                .image)),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                  child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 25),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      contact['firstName'] +
                                                          ' ' +
                                                          contact['lastName'],
                                                      overflow:
                                                          TextOverflow.fade,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                        color: globalColor
                                                            .value.shade500,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Wrap(children: [
                                                      Text(
                                                        contact['phoneNumber'],
                                                        style: TextStyle(
                                                          color: Colors
                                                              .grey.shade300,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                              )),
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
                          }).toList() ??
                          [],
                    ),
                  );
                }
              });
        }));
  }
}
//{id: 1, firstName: Robin, lastName: Pichon, phoneNumber: 0123456789}
