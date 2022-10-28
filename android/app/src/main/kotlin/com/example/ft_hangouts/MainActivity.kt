package com.example.ft_hangouts

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.os.Build
import android.Manifest
import android.content.pm.PackageManager
import android.app.AlertDialog
import android.provider.Telephony
import android.telephony.SmsManager
import android.content.BroadcastReceiver
import android.util.Log
class MainActivity: FlutterActivity() {
	private val _permission_id = 10
	private var isRegistered = false

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)
        	val smsReceiver = object:EventChannel.StreamHandler,BroadcastReceiver(){
        	    var eventSink: EventChannel.EventSink? = null
        	    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        	        eventSink = events
        	    }

        	    override fun onCancel(arguments: Any?) {
        	        eventSink = null
        	    }

        	    override fun onReceive(p0: Context?, p1: Intent?) {
									hasPermission()
        	        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT){
        	            for (sms in Telephony.Sms.Intents.getMessagesFromIntent(p1)) {
        	                val data = mapOf("message" to sms.displayMessageBody, "sender" to sms.getDisplayOriginatingAddress());
													eventSink?.success(data);
        	            }
        	        }
        	    }
        	}
        	registerReceiver(smsReceiver,IntentFilter("android.provider.Telephony.SMS_RECEIVED"))
        	EventChannel(flutterEngine.dartExecutor.binaryMessenger,"com.ft_hangouts/smsReceived")
        	    .setStreamHandler(smsReceiver)

			MethodChannel(flutterEngine.dartExecutor.binaryMessenger,"com.ft_hangouts/sms").setMethodCallHandler{
				call, result ->
				when(call.method) {
					"checkPermission" -> {
						result.success(hasPermission())
					}
					"sendDirectSms" -> {
						val num = call.argument<String>("phone")
                		val msg = call.argument<String>("msg")
                		sendSMS(num, msg, result)
					}
				}
			}
	}

	private fun  hasPermission(): Boolean {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECEIVE_SMS)
                == PackageManager.PERMISSION_GRANTED)
                    return true
        else
        {
					ActivityCompat.requestPermissions(this,arrayOf(Manifest.permission.RECEIVE_SMS,Manifest.permission.SEND_SMS, Manifest.permission.BROADCAST_SMS), _permission_id)
        }
        return false
    }

	private fun sendSMS(phoneNo: String?, msg: String?, result: MethodChannel.Result) {
        try {
            val smsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNo, null, msg, null, null)
            result.success("SMS Sent")
        } catch (ex: Exception) {
            ex.printStackTrace()
            result.error("Err", "Sms Not Sent", "")
        }
    }
}

