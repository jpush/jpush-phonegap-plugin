package cn.jpush.phonegap;

import android.app.Activity;
import android.app.Notification;
import android.content.ComponentName;
import android.content.Intent;
import android.content.Context;
import android.util.Log;

import __PACKAGE_NAME__.R;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import cn.jpush.android.api.BasicPushNotificationBuilder;
import cn.jpush.android.api.CustomPushNotificationBuilder;
import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.api.TagAliasCallback;
import cn.jpush.android.data.JPushLocalNotification;

public class JPushPlugin extends CordovaPlugin {
    private final static List<String> methodList =
            Arrays.asList(
                    "getRegistrationID",
                    "setTags",
                    "setTagsWithAlias",
                    "setAlias",
                    "getNotification",
                    "setBasicPushNotificationBuilder",
                    "setCustomPushNotificationBuilder",
                    "setPushTime",
                    "init",
                    "setDebugMode",
                    "stopPush",
                    "resumePush",
                    "isPushStopped",
                    "setLatestNotificationNum",
                    "setPushTime",
                    "clearAllNotification",
                    "clearNotificationById",
                    "addLocalNotification",
                    "removeLocalNotification",
                    "clearLocalNotifications",
                    "onResume",
                    "onPause",
                    "reportNotificationOpened",
                    "setStatisticsOpen");

    private ExecutorService threadPool = Executors.newFixedThreadPool(1);
    private static JPushPlugin instance;
    private static Activity cordovaActivity;
    private static String TAG = "JPushPlugin";

    private static boolean shouldCacheMsg = false;
    private static boolean isStatisticsOpened = true;    // 是否开启统计分析功能

    public static String notificationAlert;
    public static Map<String, Object> notificationExtras = new HashMap<String, Object>();
    public static String openNotificationAlert;
    public static Map<String, Object> openNotificationExtras = new HashMap<String, Object>();

    public JPushPlugin() {
        instance = this;
    }

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        Log.i(TAG, "---------------- initialize" + "-"
            + JPushPlugin.openNotificationAlert + "-"
            + JPushPlugin.notificationAlert);

        cordovaActivity = this.cordova.getActivity();

        //如果同时缓存了打开事件openNotificationAlert 和 消息事件notificationAlert，只向UI 发 打开事件。
        //这样做是为了和iOS 统一
        if (JPushPlugin.openNotificationAlert != null) {
            JPushPlugin.notificationAlert = null;
            JPushPlugin.transmitOpen(JPushPlugin.openNotificationAlert,
                    JPushPlugin.openNotificationExtras);
        }
        if (JPushPlugin.notificationAlert != null) {
            JPushPlugin.transmitReceive(JPushPlugin.notificationAlert,
                    JPushPlugin.notificationExtras);
        }
        //JPushInterface.init(cordova.getActivity().getApplicationContext());
    }

    public void onPause(boolean multitasking) {
        Log.i(TAG, "----------------  onPause");
        shouldCacheMsg = true;
        if (isStatisticsOpened) {
            JPushInterface.onPause(cordovaActivity);
        }
    }

    public void onResume(boolean multitasking) {
        shouldCacheMsg = false;
        Log.i(TAG, "---------------- onResume" + "-"
            + JPushPlugin.openNotificationAlert + "-"
            + JPushPlugin.notificationAlert);
        if (isStatisticsOpened) {
            JPushInterface.onResume(cordovaActivity);
        }
        if (JPushPlugin.openNotificationAlert != null) {
            JPushPlugin.notificationAlert = null;
            JPushPlugin.transmitOpen(JPushPlugin.openNotificationAlert,
                    JPushPlugin.openNotificationExtras);
        }
        if (JPushPlugin.notificationAlert != null) {
            JPushPlugin.transmitReceive(JPushPlugin.notificationAlert,
                    JPushPlugin.notificationExtras);
        }
    }

    private static JSONObject notificationObject(String message,
            Map<String, Object> extras) {
        JSONObject data = new JSONObject();
        try {
            data.put("message", message);
            JSONObject jExtras = new JSONObject();
            for (Entry<String, Object> entry : extras.entrySet()) {
                if (entry.getKey().equals("cn.jpush.android.EXTRA")) {
                    JSONObject jo = new JSONObject((String) entry.getValue());
                    jExtras.put("cn.jpush.android.EXTRA", jo);
                } else {
                    jExtras.put(entry.getKey(), entry.getValue());
                }
            }
            if (jExtras.length() > 0) {
                data.put("extras", jExtras);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return data;
    }

    private static JSONObject openNotificationObject(String alert,
            Map<String, Object> extras) {
        JSONObject data = new JSONObject();
        try {
            data.put("alert", alert);
            JSONObject jExtras = new JSONObject();
            for (Entry<String, Object> entry : extras.entrySet()) {
                if (entry.getKey().equals("cn.jpush.android.EXTRA")) {
                    JSONObject jo = new JSONObject((String) entry.getValue());
                    jExtras.put("cn.jpush.android.EXTRA", jo);
                } else {
                    jExtras.put(entry.getKey(), entry.getValue());
                }
            }
            if (jExtras.length() > 0) {
                data.put("extras", jExtras);
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return data;
    }

    static void transmitPush(String message, Map<String, Object> extras) {
        if (instance == null) {
            return;
        }
        JSONObject data = notificationObject(message, extras);
        String format = "window.plugins.jPushPlugin.receiveMessageInAndroidCallback(%s);";
        final String js = String.format(format, data.toString());
        cordovaActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                instance.webView.loadUrl("javascript:" + js);
            }
        });
    }

    static void transmitOpen(String alert, Map<String, Object> extras) {
        if (instance == null) {
            return;
        }
        if (JPushPlugin.shouldCacheMsg) {
            return;
        }
        JSONObject data = openNotificationObject(alert, extras);
        String format = "window.plugins.jPushPlugin.openNotificationInAndroidCallback(%s);";
        final String js = String.format(format, data.toString());
        cordovaActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                instance.webView.loadUrl("javascript:" + js);
            }
        });
        JPushPlugin.openNotificationAlert = null;
    }

    static void transmitReceive(String alert, Map<String, Object> extras) {
        if (instance == null) {
            return;
        }
        JSONObject data = openNotificationObject(alert, extras);
        String format = "window.plugins.jPushPlugin.receiveNotificationInAndroidCallback(%s);";
        final String js = String.format(format, data.toString());
        cordovaActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                instance.webView.loadUrl("javascript:" + js);
            }
        });
        JPushPlugin.notificationAlert = null;
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
                    Log.e(TAG, e.toString());
                }
            }
        });
        return true;
    }

    void init(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.init(cordovaActivity.getApplicationContext());
        //callbackContext.success();
    }

    void setDebugMode(JSONArray data, CallbackContext callbackContext) {
        boolean mode;
        try {
            mode = data.getBoolean(0);
            JPushInterface.setDebugMode(mode);
            callbackContext.success();
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    void stopPush(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.stopPush(cordovaActivity.getApplicationContext());
        callbackContext.success();
    }

    void resumePush(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.resumePush(cordovaActivity.getApplicationContext());
        callbackContext.success();
    }

    void isPushStopped(JSONArray data, CallbackContext callbackContext) {
        boolean isStopped = JPushInterface.isPushStopped(
                cordovaActivity.getApplicationContext());
        if (isStopped) {
            callbackContext.success(1);
        } else {
            callbackContext.success(0);
        }
    }

    void setLatestNotificationNum(JSONArray data, CallbackContext callbackContext) {
        int num = -1;
        try {
            num = data.getInt(0);
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("error reading num json");
        }
        if (num != -1) {
            JPushInterface.setLatestNotificationNumber(
                    cordovaActivity.getApplicationContext(), num);
        } else {
            callbackContext.error("error num");
        }
    }

    void setPushTime(JSONArray data, CallbackContext callbackContext) {
        Set<Integer> days = new HashSet<Integer>();
        JSONArray dayArray;
        int startHour = -1;
        int endHour = -1;
        try {
            dayArray = data.getJSONArray(0);
            for (int i = 0; i < dayArray.length(); i++) {
                days.add(dayArray.getInt(i));
            }
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("error reading days json");
        }
        try {
            startHour = data.getInt(1);
            endHour = data.getInt(2);
        } catch (JSONException e) {
            callbackContext.error("error reading hour json");
        }
        Context context = cordovaActivity.getApplicationContext();
        JPushInterface.setPushTime(context, days, startHour, endHour);
        callbackContext.success();
    }

    void getRegistrationID(JSONArray data, CallbackContext callbackContext) {
        Context context = cordovaActivity.getApplicationContext();
        String regID = JPushInterface.getRegistrationID(context);
        callbackContext.success(regID);
    }

    void onResume(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.onResume(cordovaActivity);
    }

    void onPause(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.onPause(cordovaActivity);
    }

    void reportNotificationOpened(JSONArray data, CallbackContext callbackContext) {
        try {
            String msgID;
            msgID = data.getString(0);
            JPushInterface.reportNotificationOpened(cordovaActivity, msgID);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    void setTags(JSONArray data, CallbackContext callbackContext) {
        try {
            HashSet<String> tags = new HashSet<String>();
            for (int i = 0; i < data.length(); i++) {
                tags.add(data.getString(i));
            }
            JPushInterface.setTags(cordovaActivity.getApplicationContext(),
                tags, mTagWithAliasCallback);
            callbackContext.success();
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Error reading tags JSON");
        }
    }

    void setAlias(JSONArray data, CallbackContext callbackContext) {
        try {
            String alias = data.getString(0);
            JPushInterface.setAlias(cordovaActivity.getApplicationContext(),
                alias, mTagWithAliasCallback);
            callbackContext.success();
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Error reading alias JSON");
        }
    }

    void setTagsWithAlias(JSONArray data, CallbackContext callbackContext) {
        HashSet<String> tags = new HashSet<String>();
        String alias;
        try {
            alias = data.getString(0);
            JSONArray tagsArray = data.getJSONArray(1);
            for (int i = 0; i < tagsArray.length(); i++) {
                tags.add(tagsArray.getString(i));
            }
            JPushInterface.setAliasAndTags(cordovaActivity.getApplicationContext(),
                alias, tags, mTagWithAliasCallback);
            callbackContext.success();
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Error reading tagAlias JSON");
        }
    }

//	void getNotification(JSONArray data, CallbackContext callBackContext) {
//		String alert = JPushPlugin.notificationAlert;
//		Map<String, String> extras = JPushPlugin.notificationExtras;
//
//		JSONObject jsonData = new JSONObject();
//		try {
//			jsonData.put("message", alert);
//			jsonData.put("extras", new JSONObject(extras));
//		} catch (JSONException e) {
//			e.printStackTrace();
//		}
//
//		callBackContext.success(jsonData);
//
//		JPushPlugin.notificationAlert = "";
//		JPushPlugin.notificationExtras = new HashMap<String, Obl>();
//	}

    void setBasicPushNotificationBuilder(JSONArray data,
            CallbackContext callbackContext) {
        BasicPushNotificationBuilder builder = new BasicPushNotificationBuilder(
                cordovaActivity);
        builder.developerArg0 = "Basic builder 1";
        JPushInterface.setPushNotificationBuilder(1, builder);
        JSONObject obj = new JSONObject();
        try {
            obj.put("id", 1);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        //callbackContext.success(obj);
    }

    void setCustomPushNotificationBuilder(JSONArray data,
            CallbackContext callbackContext) {
        CustomPushNotificationBuilder builder = new CustomPushNotificationBuilder(
                cordovaActivity, R.layout.test_notification_layout,
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
        //callbackContext.success(obj);
    }

    void clearAllNotification(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.clearAllNotifications(cordovaActivity);
        //callbackContext.success();
    }

    void clearNotificationById(JSONArray data, CallbackContext callbackContext) {
        int notificationId = -1;
        try {
            notificationId = data.getInt(0);
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("error reading id json");
        }
        if (notificationId != -1) {
            JPushInterface.clearNotificationById(cordovaActivity, notificationId);
        } else {
            callbackContext.error("error id");
        }
    }

    void addLocalNotification(JSONArray data, CallbackContext callbackContext)
            throws JSONException {
        //builderId,content,title,notificaitonID,broadcastTime,extras
        int builderId = data.getInt(0);
        String content = data.getString(1);
        String title = data.getString(2);
        int notificationID = data.getInt(3);
        int broadcastTime = data.getInt(4);
        JSONObject extras = data.getJSONObject(5);

        JPushLocalNotification ln = new JPushLocalNotification();
        ln.setBuilderId(builderId);
        ln.setContent(content);
        ln.setTitle(title);
        ln.setNotificationId(notificationID);
        ln.setBroadcastTime(System.currentTimeMillis() + broadcastTime);

        ln.setExtras(extras.toString());
        JPushInterface.addLocalNotification(cordovaActivity, ln);
    }

    void removeLocalNotification(JSONArray data, CallbackContext callbackContext)
            throws JSONException {
        int notificationID = data.getInt(0);
        JPushInterface.removeLocalNotification(cordovaActivity, notificationID);
    }

    void clearLocalNotifications(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.clearLocalNotifications(cordovaActivity);
    }

    /**
     * 决定是否启用统计分析功能。
     * @param data
     * @param callbackContext
     */
    void setStatisticsOpen(JSONArray data, CallbackContext callbackContext) {
        try {
            isStatisticsOpened = data.getBoolean(0);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    private final TagAliasCallback mTagWithAliasCallback = new TagAliasCallback() {
        @Override
        public void gotResult(int code, String alias, Set<String> tags) {
            if (instance == null) {
                return;
            }
            JSONObject data = new JSONObject();
            try {
                data.put("resultCode", code);
                data.put("tags", tags);
                data.put("alias", alias);
                final String jsEvent = String.format(
                        "cordova.fireDocumentEvent('jpush.setTagsWithAlias',%s)",
                        data.toString());
                cordovaActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        instance.webView.loadUrl("javascript:" + jsEvent);
                    }
                });
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    };

}
