package cn.jpush.phonegap;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import cn.jpush.android.api.BasicPushNotificationBuilder;
import cn.jpush.android.api.CustomPushNotificationBuilder;
import cn.jpush.android.api.JPushInterface;

public class JPushPlugin extends CordovaPlugin {
	private final static List<String> methodList = 
			Arrays.asList(
					"setTags",
					"setTagAlias", 
					"setAlias", 
					"getNotification",
					"setBasicPushNotificationBuilder",
					"setCustomPushNotificationBuilder",
					"setPushTime",
					"init",
					"setDebugable",
					"stopPush",
					"resumePush",
					"isPushStopped",
					"setLatestNotificationNum",
					"setPushTime");
	private ExecutorService threadPool = Executors.newFixedThreadPool(1);
	private static JPushPlugin instance;

	public static String notificationAlert;
	public static Map<String, String> notificationExtras;

	public JPushPlugin() {
		instance = this;
	}

	@Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		super.initialize(cordova, webView);
		JPushInterface.setDebugMode(true);
		JPushInterface.init(cordova.getActivity().getApplicationContext());
	}

	private static JSONObject notificationObject(String message,
			Map<String, String> extras) {
		JSONObject data = new JSONObject();
		try {
			data.put("message", message);
			data.put("extras", new JSONObject(extras));
		} catch (JSONException e) {

		}
		return data;
	}

	static void transmitPush(String message, Map<String, String> extras) {
		if (instance == null) {
			return;
		}
		JSONObject data = notificationObject(message, extras);
		String js = String
				.format("window.plugins.jPushPlugin.pushCallback(%s);",
						data.toString());
		try {
			instance.webView.sendJavascript(js);
		} catch (NullPointerException e) {

		} catch (Exception e) {

		}
	}

	@Override
	public boolean execute(final String action, final JSONArray data,
			final CallbackContext callbackContext) throws JSONException {
		if (!methodList.contains(action)) {
			return false;
		}
		threadPool.execute(new Runnable() {
			@Override
			public void run() {
				try {
					Method method = JPushPlugin.class.getDeclaredMethod(action,
							JSONArray.class, CallbackContext.class);
					method.invoke(JPushPlugin.this, data, callbackContext);
				} catch (Exception e) {
				}
			}
		});
		return true;
	}
	
	void init(JSONArray data,
			CallbackContext callbackContext){
		JPushInterface.init(this.cordova.getActivity().getApplicationContext());
		callbackContext.success();
	}
	
	void setDebugable(JSONArray data, CallbackContext callbackContext) {
		String mode;
		try {
			mode = data.getString(0);
			if (mode.equals("true")) {
				JPushInterface.setDebugMode(true);
			} else if (mode.equals("false")) {
				JPushInterface.setDebugMode(false);
			} else {
				callbackContext.error("error mode");
			}
			callbackContext.success();
		} catch (JSONException e) {
		}
	}
	
	void stopPush(JSONArray data,
			CallbackContext callbackContext){
		JPushInterface.stopPush(this.cordova.getActivity().getApplicationContext());
		callbackContext.success();
	}
	
	void resumePush(JSONArray data,
			CallbackContext callbackContext){
		JPushInterface.resumePush(this.cordova.getActivity().getApplicationContext());
		callbackContext.success();
	}
	
	void isPushStopped(JSONArray data,
			CallbackContext callbackContext){
		JPushInterface.isPushStopped(this.cordova.getActivity().getApplicationContext());
		callbackContext.success();
	}
	
	void setLatestNotificationNum(JSONArray data,
			CallbackContext callbackContext){
		int num = -1;
		try {
			num = data.getInt(0);
		} catch (JSONException e) {
			e.printStackTrace();
			callbackContext.error("error reading num json");
		}
		if(num != -1){
			JPushInterface.setLatestNotifactionNumber(this.cordova.getActivity().getApplicationContext(), num);
		}else{
			callbackContext.error("error num");
		}
	}
	
	void setPushTime(JSONArray data,
			CallbackContext callbackContext){
		Set<Integer> days = new HashSet<Integer>();
		JSONArray dayArr;
		int startHour = -1;
		int endHour = -1;
		try {
			dayArr = data.getJSONArray(0);
			for (int i = 0; i < dayArr.length(); i++) {
				days.add(dayArr.getInt(i));
			}
		} catch (JSONException e) {
			e.printStackTrace();
			callbackContext.error("error reading days json");
		}
		try{
			startHour = data.getInt(1);
			endHour = data.getInt(2);
		}catch(JSONException e){
			callbackContext.error("error reading hour json");
		}
		JPushInterface.setPushTime(this.cordova.getActivity().getApplicationContext(), days, startHour, endHour);
		callbackContext.success();
	}
	
	void setTags(JSONArray data, CallbackContext callbackContext) {
		HashSet<String> tags = new HashSet<String>();
		try {
			String tagStr = data.getString(0);
			String[] tagArr = tagStr.split(",");
			for (String tag : tagArr) {
				tags.add(tag);
			}
			Set<String> validTags = JPushInterface.filterValidTags(tags);
			JPushInterface.setTags(this.cordova.getActivity()
					.getApplicationContext(), validTags, null);
			callbackContext.success();
		} catch (JSONException e) {
			e.printStackTrace();
			callbackContext.error("Error reading tags JSON");
		}
	}

	void setAlias(JSONArray data, CallbackContext callbackContext) {
		try {
			String alias = data.getString(0);
			JPushInterface.setAlias(this.cordova.getActivity()
					.getApplicationContext(), alias, null);
			callbackContext.success();
		} catch (JSONException e) {
			e.printStackTrace();
			callbackContext.error("Error reading alias JSON");
		}
	}

	void setTagAlias(JSONArray data, CallbackContext callbackContext) {
		HashSet<String> tags = new HashSet<String>();
		String alias;
		try {
			alias = data.getString(0);
			JSONArray tagsArr = data.getJSONArray(1);
			for (int i = 0; i < tagsArr.length(); i++) {
				tags.add(tagsArr.getString(i));
			}

			JPushInterface.setAliasAndTags(this.cordova.getActivity()
					.getApplicationContext(), alias, tags);
			callbackContext.success();
		} catch (JSONException e) {
			e.printStackTrace();
			callbackContext.error("Error reading tagAlias JSON");
		}
	}

	void getNotification(JSONArray data, CallbackContext callBackContext) {
		String alert = JPushPlugin.notificationAlert;
		Map<String, String> extras = JPushPlugin.notificationExtras;

		JSONObject jsonData = new JSONObject();
		try {
			jsonData.put("message", alert);
			jsonData.put("extras", new JSONObject(extras));
		} catch (JSONException e) {
			e.printStackTrace();
		}

		callBackContext.success(jsonData);

		JPushPlugin.notificationAlert = "";
		JPushPlugin.notificationExtras = new HashMap<String, String>();
	}

	void setBasicPushNotificationBuilder(JSONArray data,
			CallbackContext callbackContext) {
		BasicPushNotificationBuilder builder = new BasicPushNotificationBuilder(
				this.cordova.getActivity());
		builder.developerArg0 = "Basic builder 1";
		JPushInterface.setPushNotificationBuilder(1, builder);
		JSONObject obj = new JSONObject();
		try {
			obj.put("id", 1);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		callbackContext.success(obj);
	}

	void setCustomPushNotificationBuilder(JSONArray data,
			CallbackContext callbackContext) {
		CustomPushNotificationBuilder builder = new CustomPushNotificationBuilder(
				this.cordova.getActivity(), R.layout.test_notification_layout,
				R.id.icon, R.id.title, R.id.text);
		builder.developerArg0 = "Custom Builder 1";
		builder.layoutIconDrawable = R.drawable.jpush_notification_icon;
		JPushInterface.setPushNotificationBuilder(2, builder);
		JSONObject obj = new JSONObject();
		try {
			obj.put("id", 2);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		callbackContext.success(obj);
	}
	void clearAllNotification(JSONArray data,
			CallbackContext callbackContext){
		JPushInterface.clearAllNotifications(this.cordova.getActivity());
		callbackContext.success();
	}
	void clearNotificationById(JSONArray data,
			CallbackContext callbackContext){
		int notificationId=-1;
		try {
			notificationId = data.getInt(0);
		} catch (JSONException e) {
			e.printStackTrace();
			callbackContext.error("error reading id json");
		}
		if(notificationId != -1){
		JPushInterface.clearNotificationById(this.cordova.getActivity(), notificationId);
		}else{
			callbackContext.error("error id");
		}
	}
}
