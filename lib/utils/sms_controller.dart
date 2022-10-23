import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ft_hangouts/database_controller.dart';
import '../models/models.dart';

class sms_controller {
  static const _streamChannel = EventChannel("com.ft_hangouts/smsReceived");
  static const _methodChannel = MethodChannel("com.ft_hangouts/sms");

  Stream smsReceived() async* {
    yield* _streamChannel.receiveBroadcastStream();
  }

  Stream permissionChannel() async* {
    yield* _streamChannel.receiveBroadcastStream();
  }

  static Future<void> initPermission() async {
    try {
      return await _methodChannel.invokeMethod("checkPermission");
    } catch (e) {}
  }

  static Future<void> storeMessageInDb(
      String content, String sender, int mine) async {
    if (sender[0] != '0') sender = '0' + sender;
    try {
      databaseController.instance
          .getContactFromPhoneNumber(sender)
          .then((value) {
        //contact found, store message with his Id
        if (value.isNotEmpty) {
          databaseController.instance.insertMessage(
              Message(message: content, mine: mine, contactId: value[0]['id']));
        } else {
          databaseController.instance
              .insertContact(new Contact(
                  firstName: sender, lastName: '', phoneNumber: sender))
              .then((value) {
            if (value != 0) {
              databaseController.instance.insertMessage(
                  new Message(message: content, mine: mine, contactId: value));
            }
          });
        }
        //sms from someone, update unread messages
        if (mine == 0) {
          databaseController.instance
              .updateUnreadMessages(value[0]['id'], false);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}



		// Log.d("TAG", "Here");
		// MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"com.example.app/sms").setMethodCallHandler {
    // 	call, result ->
		// 	when(call.method) {
		// 		"checkPermission" -> {
		// 			Log.d("TAG", "in check permission");
		// 			result.success(hasPermission())
		// 		}
		// 		"sendDirectSms" -> {
		// 			if(hasPermission()) {
		// 			        val smsManager=SmsManager.getDefault();
		// 			        smsManager.sendTextMessage(call.argument<String>("phone"),null,call.argument<String>("text"), null, null)
		// 			}
		// 		}
		// 	}
    // }
