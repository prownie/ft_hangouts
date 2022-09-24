import 'package:flutter/material.dart';
import 'menu_section.dart';

const dGreen = Color.fromARGB(255, 68, 137, 202);
const dWhite = Color.fromARGB(255, 216, 229, 227);
const dBlack = Color.fromARGB(255, 38, 37, 35);

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ft_hangouts'),
        elevation: 0,
        backgroundColor: dBlack,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            color: dWhite,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search_rounded,
                color: dWhite,
                size: 30,
              )),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.account_circle,
                color: dWhite,
                size: 30,
              ))
        ],
      ),
      body: Column(
        children: [
          MenuSection(),
          // FavoriteSection(),
          // Expanded(child: MessageSection())
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: dGreen,
          child: const Icon(
            Icons.edit,
            size: 20,
          )),
    );
  }
}
