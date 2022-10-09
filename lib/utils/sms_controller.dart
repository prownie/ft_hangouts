import 'dart:async';
import 'package:flutter/services.dart';

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
