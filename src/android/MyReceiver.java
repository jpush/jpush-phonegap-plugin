package cn.jpush.phonegap;


import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import cn.jpush.android.api.JPushInterface;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class MyReceiver extends BroadcastReceiver {
	private static String TAG = "Client Receiver";
	@Override
	public void onReceive(Context context, Intent intent) {

        if (JPushInterface.ACTION_REGISTRATION_ID.equals(intent.getAction())) {
        	
        }else if (JPushInterface.ACTION_UNREGISTER.equals(intent.getAction())){
        	
        } else if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(intent.getAction())) {
        	handlingReceivedMessage(intent);
        } else if (JPushInterface.ACTION_NOTIFICATION_RECEIVED.equals(intent.getAction())) {
        	handlingNotificationReceive(context,intent);
        	
        } else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(intent.getAction())) {
        	handlingNotificationOpen(context,intent);
        } else if (JPushInterface.ACTION_RICHPUSH_CALLBACK.equals(intent.getAction())) {
        
        } else {
        	Log.d(TAG, "Unhandled intent - " + intent.getAction());
        }
	
	}
	private void handlingReceivedMessage(Intent intent) {
		String msg = intent.getStringExtra(JPushInterface.EXTRA_MESSAGE);
		Map<String,Object> extras = getNotificationExtras(intent);
		
		
		JPushPlugin.transmitPush(msg, extras);
	}
	 private void handlingNotificationOpen(Context context,Intent intent){
		 String alert = intent.getStringExtra(JPushInterface.EXTRA_ALERT);
		 Map<String,Object> extras = getNotificationExtras(intent);
		 
		 Intent launch = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
		 launch.addCategory(Intent.CATEGORY_LAUNCHER);
		 launch.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_ACTIVITY_SINGLE_TOP);
		 
		 JPushPlugin.openNotificationAlert = alert;
		 JPushPlugin.openNotificationExtras = extras;
		 
		 JPushPlugin.transmitOpen(alert, extras);

		 context.startActivity(launch);
	 }
	 private void handlingNotificationReceive(Context context,Intent intent){
		 String alert = intent.getStringExtra(JPushInterface.EXTRA_ALERT);
		 Map<String,Object> extras = getNotificationExtras(intent);
		 
		 Intent launch = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
		 launch.addCategory(Intent.CATEGORY_LAUNCHER);
		 launch.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK|Intent.FLAG_ACTIVITY_SINGLE_TOP);
		 
		 JPushPlugin.notificationAlert = alert;
		 JPushPlugin.notificationExtras = extras;
		 
		 JPushPlugin.transmitReceive(alert, extras);
	 }
	 private Map<String, Object> getNotificationExtras(Intent intent) {
		 Map<String, Object> extrasMap = new HashMap<String, Object>();
		 
		 for (String key : intent.getExtras().keySet()) {
			 if (!IGNORED_EXTRAS_KEYS.contains(key)) {
			    Log.e("key","key:"+key);
		     	if (key.equals(JPushInterface.EXTRA_NOTIFICATION_ID)){
		     		extrasMap.put(key, intent.getIntExtra(key,0));
		     	}else{
		     		extrasMap.put(key, intent.getStringExtra(key));
		        }
			 }
		 }
		 return extrasMap;
	 }
	 private static final List<String> IGNORED_EXTRAS_KEYS = 
			 Arrays.asList("cn.jpush.android.TITLE","cn.jpush.android.MESSAGE","cn.jpush.android.APPKEY","cn.jpush.android.NOTIFICATION_CONTENT_TITLE");
}
