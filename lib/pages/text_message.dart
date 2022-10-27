import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../main.dart';

class TextMessage extends StatelessWidget {
  final String message, date, senderProfile, time;
  final int isMine;

  const TextMessage({
    Key? key,
    required this.message,
    required this.date,
    required this.senderProfile,
    required this.isMine,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          isMine == 0
              ? CircleAvatar(
                radius:25,
                backgroundColor: globalColor.value.shade900,
                child: CircleAvatar(
                  radius:22,
                  backgroundImage: imageHelper.imageFromBase64String(senderProfile).image
                )
              )
              : SizedBox(
                  width: 62,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: globalColor.value.shade900,
                            size: 13.0,
                          ),
                          const SizedBox(width: 0.0),
                          Text(
                            date,
                            style: TextStyle(
                              color: globalColor.value.shade900,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: globalColor.value.shade900,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(width:5),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              margin: isMine == 0
                  ? const EdgeInsets.only(
                      right: 5,
                    )
                  : const EdgeInsets.only(
                      left: 5,
                    ),
              padding: const EdgeInsets.all(6),
              constraints: BoxConstraints(minHeight: 55),
              decoration: isMine == 1
                  ? BoxDecoration(
                      color: globalColor.value.shade500,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    )
                  : BoxDecoration(
                      color: globalColor.value.shade100,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
              child: Text(
                message,
                style: TextStyle(
                  color:
                      isMine == 0 ? Colors.black : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          isMine == 0
              ? SizedBox(
                  width: 62,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: globalColor.value.shade900,
                            size: 13.0,
                          ),
                          const SizedBox(width: 0.0),
                          Text(
                            date,
                            style: TextStyle(
                              color: globalColor.value.shade900,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: globalColor.value.shade900,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          isMine == 1
              ? Row(children: [SizedBox(width:5),CircleAvatar(
                radius:25,
                backgroundColor: globalColor.value.shade900,
                child: CircleAvatar(
                  radius:22,
                  backgroundImage: imageHelper.imageFromBase64String(senderProfile).image
                )
              )])
              : Container(),
        ],
      ),
    );
  }
}
