package com.example.ft_hangouts

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.Manifest
import android.content.pm.PackageManager
import android.app.AlertDialog

import android.telephony.SmsManager

class MainActivity: FlutterActivity() {
	private val _permission_id = 10;
	private val _channel = "ft_hangouts.com"

	override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, _channel).setMethodCallHandler {
			call, result ->
			when(call.method) {
				"requestPermissionForSms" -> {
					result.success(hasPermission())
				}
				"sendDirectSms" -> {
					if(hasPermission()) {
						val smsManager=SmsManager.getDefault();
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
						if(!activity.shouldShowRequestPermissionRationale(Manifest.permission.RECEIVE_SMS)) {
							ActivityCompat.requestPermissions(this,arrayOf(Manifest.permission.RECEIVE_SMS,Manifest.permission.SEND_SMS, Manifest.permission.BROADCAST_SMS), _permission_id)
            	if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECEIVE_SMS) == PackageManager.PERMISSION_GRANTED)
              	return true
						} else {
							val alertDialogBuilder = AlertDialog.Builder(this)
							alertDialogBuilder.setTitle("Permission Needed")
              alertDialogBuilder.setMessage("Permission is needed to access files from your device...")
						}
        }
        return false
    }
}

