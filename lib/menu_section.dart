import 'package:flutter/material.dart';

const Blue = Color.fromARGB(255, 68, 137, 202);
const White = Color.fromARGB(255, 216, 229, 227);
const Black = Color.fromARGB(255, 38, 37, 35);

class MenuSection extends StatelessWidget {
  final List menuItems = ["Message", "Contacts", "Call"];

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Black,
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
