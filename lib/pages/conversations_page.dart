import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/ticker_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:ft_hangouts/utils/database_controller.dart';
import 'package:flutter/material.dart';
import 'package:ft_hangouts/pages/conversation_page.dart';
import '../utils/constants.dart';
import '../main.dart';

class conversationsPage extends StatefulWidget {
  final ValueNotifier<bool> smsUpdater;

  conversationsPage(this.smsUpdater);

  @override
  State<conversationsPage> createState() => _conversationsPageState();
}

class _conversationsPageState extends State<conversationsPage> {

  Future<List<Map<String, dynamic>>> getData() async {
    return (await getConversations());
  }

  Future<List<Map<String, dynamic>>> getConversations() async {
    List<Map<String, dynamic>> convList = await databaseController.instance.getConversations();
    return (await conversationsPrevisulation(convList));
  }

  Future<List<Map<String, dynamic>>> conversationsPrevisulation(List<Map<String, dynamic>> convList) async {
    // need to make a copy because saflite return are readonly
    List<Map<String, dynamic>> tmp = [];
    for (final conv in convList) {
      tmp.add(Map.of(conv));
    }
    for (final conv in tmp) {
      final indexNewLine = conv['message'].indexOf('\n');
      if (indexNewLine != -1) {
        conv['message'] = conv['message'].substring(0, indexNewLine);
      }
    }
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.smsUpdater,
        builder: ((context, value, child) {
          return FutureBuilder(
              future: getData(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return SizedBox.shrink();
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data?.map<Widget>((conversation) {
                            return InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => conversationPage(
                                        conversation['id'], widget.smsUpdater),
                                  ),
                                ).then((value) {
                                  widget.smsUpdater.value = !widget.smsUpdater.value;
                                });
                              },
                              splashColor: globalColor.value.shade500,
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
                                              'assets/images/avatar/profile-placeholder.jpg'),
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
                                                              'lastName'],
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
                                                if (conversation[
                                                        'unreadMessages'] > 0)
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: globalColor
                                                          .value.shade900,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      conversation[
                                                              'unreadMessages']
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  )
                                                else
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12),
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
