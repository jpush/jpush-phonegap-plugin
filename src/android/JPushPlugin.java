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
import android.util.Log;
import cn.jpush.android.api.BasicPushNotificationBuilder;
import cn.jpush.android.api.CustomPushNotificationBuilder;
import cn.jpush.android.api.JPushInterface;

public class JPushPlugin extends CordovaPlugin {
	private final static List<String> methodList = 
			Arrays.asList(
					"setTags",
					"setTagAlias", 
					"setAlias", 
					"getIncoming",
					"setBasicPushNotificationBuilder",
					"setCustomPushNotificationBuilder");
	private ExecutorService executorService = Executors.newFixedThreadPool(1);
	private static JPushPlugin instance;

	public static String incomingAlert;
	public static Map<String, String> incomingExtras;

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

	static void raisePush(String message, Map<String, String> extras) {
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
		executorService.execute(new Runnable() {
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
		Log.e("lincoln", "set alias start");
		try {
			String alias = data.getString(0);
			JPushInterface.setAlias(this.cordova.getActivity()
					.getApplicationContext(), alias, null);
			Log.e("lincoln", "set alias:" + alias);
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

	void getIncoming(JSONArray data, CallbackContext callBackContext) {
		String alert = JPushPlugin.incomingAlert;
		Map<String, String> extras = JPushPlugin.incomingExtras;

		JSONObject jsonData = new JSONObject();
		try {
			jsonData.put("message", alert);
			jsonData.put("extras", new JSONObject(extras));
		} catch (JSONException e) {
			e.printStackTrace();
		}

		callBackContext.success(jsonData);

		JPushPlugin.incomingAlert = "";
		JPushPlugin.incomingExtras = new HashMap<String, String>();
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
				this.cordova.getActivity(), R.layout.test_notitfication_layout,
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
}
