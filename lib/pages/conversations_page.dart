import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:ft_hangouts/database_controller.dart';
import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/conversation_page.dart';
import '../utils/constants.dart';

class conversationsPage extends StatefulWidget {
  final ValueNotifier<bool> updater;

  conversationsPage(this.updater);

  @override
  State<conversationsPage> createState() => _conversationsPageState();
}

class _conversationsPageState extends State<conversationsPage> {
  List<Map<String, dynamic>>? _conversationsList;

  Future<void> getConversations() async {
    databaseController.instance.getConversations().then((value) {
      List<Map<String, dynamic>> tmp = [];
      for (final val in value) {
        tmp.add(Map.of(val));
      }
      _conversationsList = tmp;
      for (final conv in _conversationsList!) {
        final indexNewLine = conv['message'].indexOf('\n');
        if (indexNewLine != -1) {
          conv['message'] = conv['message'].substring(0, indexNewLine);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.updater,
        builder: ((context, value, child) {
          return FutureBuilder(
              future: getConversations(),
              builder: (BuildContext context, toto) {
                if (toto.connectionState != ConnectionState.done) {
                  return SizedBox.shrink();
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: _conversationsList?.map<Widget>((conversation) {
                            return InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => conversationPage(
                                        conversation['id'].toString(),
                                        widget.updater),
                                  ),
                                );
                              },
                              splashColor: Constants.Blue,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 30, right: 10, top: 15),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 23),
                                      width: 62,
                                      height: 62,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'images/avatar/profile-placeholder.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 25),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      conversation[
                                                              'firstName'] +
                                                          ' ' +
                                                          conversation[
                                                              'lastName'] +
                                                          'iqdbbveytewvd uweqwdeqdwedewdwedwedwedewdewdduwdyew',
                                                      overflow:
                                                          TextOverflow.fade,
                                                      softWrap: false,
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      conversation['message'],
                                                      overflow:
                                                          TextOverflow.fade,
                                                      softWrap: false,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 30),
                                                  child: Text('16:10'),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Constants.Blue,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    '3',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]),
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
