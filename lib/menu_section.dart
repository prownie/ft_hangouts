import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const dGreen = Color.fromARGB(255, 68, 137, 202);
const dWhite = Color.fromARGB(255, 216, 229, 227);
const dBlack = Color.fromARGB(255, 38, 37, 35);

class MenuSection extends StatelessWidget {
  final List menuItems = ["Message", "Contacts", "Call"];

  @override
  Widget build(BuildContext context) {
    return Container(
        color: dBlack,
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
                        style: GoogleFonts.raleway(
                          color: Colors.white60,
                          fontSize: 29,
                        ),
                      ),
                    );
                  }).toList(),
                ))));
  }
}
