import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ft_hangouts/database_controller.dart';
import 'package:flutter/material.dart';
import 'package:ft_hangouts/utils/shared_preferences.dart';
import '../main.dart';

class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  late Color _pickedColor = globalColor.value;

  List<Color> availableColors = [
    Colors.yellow,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.orange
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 50,
            childAspectRatio: 1 / 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemCount: availableColors.length,
        itemBuilder: (context, index) {
          final itemColor = availableColors[index];
          return InkWell(
            onTap: () {
              sharedPrefHelper.setFavColor(itemColor).then((value) {
                globalColor.value = value;
                setState(() {
                  _pickedColor = itemColor;
                });
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  color: itemColor,
                  shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Colors.grey.shade300)),
              child: itemColor == _pickedColor
                  ? const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    )
                  : Container(),
            ),
          );
        },
      ),
    );
  }
}
