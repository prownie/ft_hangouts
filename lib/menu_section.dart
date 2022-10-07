import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MenuSection extends StatelessWidget {
  final List menuItems = ["Message", "Contacts", "Call"];

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Constants.Black,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: Row(
                  children: menuItems.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(right: 50),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 29,
                        ),
                      ),
                    );
                  }).toList(),
                ))));
  }
}
