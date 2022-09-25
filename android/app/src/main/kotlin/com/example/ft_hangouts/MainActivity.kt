package com.example.ft_hangouts

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import io.flutter.embedding.android.FlutterActivity
import android.telephony.SmsManager

class MainActivity: FlutterActivity() {
	private val _channel = "ft_hangouts.com"

	override fun configureFlutterEngine(@NonNull flutterEngine: flutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, _channel).setMethodCallHandler {
			call, result ->
			when(call.method) {
				"requestPermissionForSms" -> {
					result.sucess(hasPermission())
				}
				"sendDirectSms" -> {
					if(hasPermission()) {
						SmsManager smsManager=SmsManager.getDefault();
						smsManager.sendTextMessage(call.argument<String>("phone"),null,call.argument<String>("text"), null, null)
					}
				}
				"smsReceived" -> {
					if(hasPermission()) {
						
					}
				}
				else -> result.notImplemented()
			}
		}
	}

	private fun  hasPermission(): Boolean {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECEIVE_SMS)
                == PackageManager.PERMISSION_GRANTED)
                    return true
        else
        {
						if(!activity.shouldShowRequestPermissionRationale(arrayOf(Manifest.permission.RECEIVE_SMS, Manifest.permission.SEND_SMS, Manifest.permission.BROADCAST_SMS))) {
							ActivityCompat.requestPermissions(this,arrayOf(Manifest.permission.RECEIVE_SMS,Manifest.permission.SEND_SMS, Manifest.permission.BROADCAST_SMS), PERMISSION_ID)
            	if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECEIVE_SMS) == PackageManager.PERMISSION_GRANTED)
              	return true
						}

        }
        return false
    }
}
