package cn.jiguang.cordova.push;

import android.app.Activity;
import android.app.AppOpsManager;
import android.app.NotificationManager;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.os.Build;
import android.text.TextUtils;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import cn.jpush.android.api.BasicPushNotificationBuilder;
import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.api.TagAliasCallback;
import cn.jpush.android.data.JPushLocalNotification;

public class JPushPlugin extends CordovaPlugin {

    private static final String TAG = JPushPlugin.class.getSimpleName();

    private Context mContext;

    private static JPushPlugin instance;
    private static Activity cordovaActivity;

    static String notificationTitle;
    static String notificationAlert;
    static Map<String, Object> notificationExtras = new HashMap<String, Object>();

    static String openNotificationTitle;
    static String openNotificationAlert;
    static Map<String, Object> openNotificationExtras = new HashMap<String, Object>();

    static Map<Integer, CallbackContext> eventCallbackMap = new HashMap<Integer, CallbackContext>();

    public JPushPlugin() {
        instance = this;
    }

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        mContext = cordova.getActivity().getApplicationContext();

        JPushInterface.init(mContext);

        cordovaActivity = cordova.getActivity();

        // 如果同时缓存了打开事件 openNotificationAlert 和 消息事件 notificationAlert，只向 UI 发打开事件。
        // 这样做是为了和 iOS 统一。
        if (openNotificationAlert != null) {
            notificationAlert = null;
            transmitNotificationOpen(openNotificationTitle, openNotificationAlert, openNotificationExtras);
        }
        if (notificationAlert != null) {
            transmitNotificationReceive(notificationTitle, notificationAlert, notificationExtras);
        }
    }

    public void onResume(boolean multitasking) {
        if (openNotificationAlert != null) {
            notificationAlert = null;
            transmitNotificationOpen(openNotificationTitle, openNotificationAlert, openNotificationExtras);
        }
        if (notificationAlert != null) {
            transmitNotificationReceive(notificationTitle, notificationAlert, notificationExtras);
        }
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        cordovaActivity = null;
        instance = null;
    }

    private static JSONObject getMessageObject(String message, Map<String, Object> extras) {
        JSONObject data = new JSONObject();
        try {
            data.put("message", message);
            JSONObject jExtras = new JSONObject();
            for (Entry<String, Object> entry : extras.entrySet()) {
                if (entry.getKey().equals("cn.jpush.android.EXTRA")) {
                    JSONObject jo;
                    if (TextUtils.isEmpty((String) entry.getValue())) {
                        jo = new JSONObject();
                    } else {
                        jo = new JSONObject((String) entry.getValue());
                        String key;
                        Iterator keys = jo.keys();
                        while (keys.hasNext()) {
                            key = keys.next().toString();
                            jExtras.put(key, jo.getString(key));
                        }
                    }
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

    private static JSONObject getNotificationObject(String title, String alert, Map<String, Object> extras) {
        JSONObject data = new JSONObject();
        try {
            data.put("title", title);
            data.put("alert", alert);
            JSONObject jExtras = new JSONObject();
            for (Entry<String, Object> entry : extras.entrySet()) {
                if (entry.getKey().equals("cn.jpush.android.EXTRA")) {
                    JSONObject jo;
                    if (TextUtils.isEmpty((String) entry.getValue())) {
                        jo = new JSONObject();
                    } else {
                        jo = new JSONObject((String) entry.getValue());
                        String key;
                        Iterator keys = jo.keys();
                        while (keys.hasNext()) {
                            key = keys.next().toString();
                            jExtras.put(key, jo.getString(key));
                        }
                    }
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

    static void transmitMessageReceive(String message, Map<String, Object> extras) {
        if (instance == null) {
            return;
        }
        JSONObject data = getMessageObject(message, extras);
        String format = "window.plugins.jPushPlugin.receiveMessageInAndroidCallback(%s);";
        final String js = String.format(format, data.toString());
        cordovaActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                instance.webView.loadUrl("javascript:" + js);
            }
        });
    }

    static void transmitNotificationOpen(String title, String alert, Map<String, Object> extras) {
        if (instance == null) {
            return;
        }
        JSONObject data = getNotificationObject(title, alert, extras);
        String format = "window.plugins.jPushPlugin.openNotificationInAndroidCallback(%s);";
        final String js = String.format(format, data.toString());
        cordovaActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                instance.webView.loadUrl("javascript:" + js);
            }
        });
        JPushPlugin.openNotificationTitle = null;
        JPushPlugin.openNotificationAlert = null;
    }

    static void transmitNotificationReceive(String title, String alert, Map<String, Object> extras) {
        if (instance == null) {
            return;
        }
        JSONObject data = getNotificationObject(title, alert, extras);
        String format = "window.plugins.jPushPlugin.receiveNotificationInAndroidCallback(%s);";
        final String js = String.format(format, data.toString());
        cordovaActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                instance.webView.loadUrl("javascript:" + js);
            }
        });
        JPushPlugin.notificationTitle = null;
        JPushPlugin.notificationAlert = null;
    }

    static void transmitReceiveRegistrationId(String rId) {
        if (instance == null) {
            return;
        }
        JSONObject data = new JSONObject();
        try {
            data.put("registrationId", rId);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        String format = "window.plugins.jPushPlugin.receiveRegistrationIdInAndroidCallback(%s);";
        final String js = String.format(format, data.toString());
        cordovaActivity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                instance.webView.loadUrl("javascript:" + js);
            }
        });
    }

    @Override
    public boolean execute(final String action, final JSONArray data, final CallbackContext callbackContext)
            throws JSONException {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                try {
                    Method method = JPushPlugin.class.getDeclaredMethod(action, JSONArray.class, CallbackContext.class);
                    method.invoke(JPushPlugin.this, data, callbackContext);
                } catch (Exception e) {
                    Log.e(TAG, e.toString());
                }
            }
        });
        return true;
    }

    void init(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.init(mContext);
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
        JPushInterface.stopPush(mContext);
        callbackContext.success();
    }

    void resumePush(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.resumePush(mContext);
        callbackContext.success();
    }

    void isPushStopped(JSONArray data, CallbackContext callbackContext) {
        boolean isStopped = JPushInterface.isPushStopped(mContext);
        if (isStopped) {
            callbackContext.success(1);
        } else {
            callbackContext.success(0);
        }
    }

    void areNotificationEnabled(JSONArray data, final CallbackContext callback) {
        int isEnabled;
        if (hasPermission("OP_POST_NOTIFICATION")) {
            isEnabled = 1;
        } else {
            isEnabled = 0;
        }
        callback.success(isEnabled);
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
            JPushInterface.setLatestNotificationNumber(mContext, num);
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
        Context context = mContext;
        JPushInterface.setPushTime(context, days, startHour, endHour);
        callbackContext.success();
    }

    void getRegistrationID(JSONArray data, CallbackContext callbackContext) {
        Context context = mContext;
        String regID = JPushInterface.getRegistrationID(context);
        callbackContext.success(regID);
    }

    void onResume(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.onResume(this.cordova.getActivity());
    }

    void onPause(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.onPause(this.cordova.getActivity());
    }

    void reportNotificationOpened(JSONArray data, CallbackContext callbackContext) {
        try {
            String msgID;
            msgID = data.getString(0);
            JPushInterface.reportNotificationOpened(this.cordova.getActivity(), msgID);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    void setAlias(JSONArray data, CallbackContext callbackContext) {
        int sequence = -1;
        String alias = null;

        try {
            JSONObject params = data.getJSONObject(0);
            sequence = params.getInt("sequence");
            alias = params.getString("alias");
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Parameters error.");
        }

        JPushInterface.setAlias(mContext, sequence, alias);
        eventCallbackMap.put(sequence, callbackContext);
    }

    void deleteAlias(JSONArray data, CallbackContext callbackContext) {
        int sequence = -1;

        try {
            JSONObject params = data.getJSONObject(0);
            sequence = params.getInt("sequence");
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Parameters error.");
        }

        JPushInterface.deleteAlias(mContext, sequence);
        eventCallbackMap.put(sequence, callbackContext);
    }

    void getAlias(JSONArray data, CallbackContext callbackContext) {
        int sequence = -1;

        try {
            JSONObject params = data.getJSONObject(0);
            sequence = params.getInt("sequence");
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Parameters error.");
        }

        JPushInterface.getAlias(mContext, sequence);
        eventCallbackMap.put(sequence, callbackContext);
    }

    void setTags(JSONArray data, CallbackContext callbackContext) {
        int sequence = -1;
        Set<String> tags = new HashSet<String>();

        try {
            JSONObject params = data.getJSONObject(0);
            sequence = params.getInt("sequence");

            JSONArray tagsArr = params.getJSONArray("tags");
            for (int i = 0; i < tagsArr.length(); i++) {
                tags.add(tagsArr.getString(i));
            }

        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Parameters error.");
        }

        JPushInterface.setTags(mContext, sequence, tags);
        eventCallbackMap.put(sequence, callbackContext);
    }

    void addTags(JSONArray data, CallbackContext callbackContext) {
        int sequence = -1;
        Set<String> tags = new HashSet<String>();

        try {
            JSONObject params = data.getJSONObject(0);
            sequence = params.getInt("sequence");

            JSONArray tagsArr = params.getJSONArray("tags");
            for (int i = 0; i < tagsArr.length(); i++) {
                tags.add(tagsArr.getString(i));
            }

        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Parameters error.");
        }

        JPushInterface.addTags(mContext, sequence, tags);
        eventCallbackMap.put(sequence, callbackContext);
    }

    void deleteTags(JSONArray data, CallbackContext callbackContext) {
        int sequence = -1;
        Set<String> tags = new HashSet<String>();

        try {
            JSONObject params = data.getJSONObject(0);
            sequence = params.getInt("sequence");

            JSONArray tagsArr = params.getJSONArray("tags");
            for (int i = 0; i < tagsArr.length(); i++) {
                tags.add(tagsArr.getString(i));
            }

        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Parameters error.");
        }

        JPushInterface.deleteTags(mContext, sequence, tags);
        eventCallbackMap.put(sequence, callbackContext);
    }

    void cleanTags(JSONArray data, CallbackContext callbackContext) {
        int sequence = -1;

        try {
            JSONObject params = data.getJSONObject(0);
            sequence = params.getInt("sequence");

        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Parameters error.");
        }

        JPushInterface.cleanTags(mContext, sequence);
        eventCallbackMap.put(sequence, callbackContext);
    }

    void getAllTags(JSONArray data, CallbackContext callbackContext) {
        int sequence = -1;

        try {
            JSONObject params = data.getJSONObject(0);
            sequence = params.getInt("sequence");

        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Parameters error.");
        }

        JPushInterface.getAllTags(mContext, sequence);
        eventCallbackMap.put(sequence, callbackContext);
    }

    void checkTagBindState(JSONArray data, CallbackContext callbackContext) {
        int sequence = -1;
        String tag = null;

        try {
            JSONObject params = data.getJSONObject(0);
            sequence = params.getInt("sequence");
            tag = params.getString("tag");

        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("Parameters error.");
        }

        JPushInterface.checkTagBindState(mContext, sequence, tag);
        eventCallbackMap.put(sequence, callbackContext);
    }

    void getConnectionState(JSONArray data, CallbackContext callback) {
        boolean isConnected = JPushInterface.getConnectionState(cordovaActivity.getApplicationContext());
        if (isConnected) {
            callback.success(1);
        } else {
            callback.success(0);
        }
    }

    /**
     * 自定义通知行为，声音、震动、呼吸灯等。
     */
    void setBasicPushNotificationBuilder(JSONArray data, CallbackContext callbackContext) {
        BasicPushNotificationBuilder builder = new BasicPushNotificationBuilder(this.cordova.getActivity());
        builder.developerArg0 = "Basic builder 1";
        JPushInterface.setPushNotificationBuilder(1, builder);
        JSONObject obj = new JSONObject();
        try {
            obj.put("id", 1);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * 自定义推送通知栏样式，需要自己实现具体代码。 http://docs.jiguang.cn/client/android_tutorials/#_11
     */
    void setCustomPushNotificationBuilder(JSONArray data, CallbackContext callbackContext) {
        // CustomPushNotificationBuilder builder = new CustomPushNotificationBuilder(
        // this.cordova.getActivity(), R.layout.test_notification_layout,
        // R.id.icon, R.id.title, R.id.text);
        // JPushInterface.setPushNotificationBuilder(2, builder);
        // JPushInterface.setDefaultPushNotificationBuilder(builder);
    }

    void clearAllNotification(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.clearAllNotifications(this.cordova.getActivity());
    }

    void clearNotificationById(JSONArray data, CallbackContext callbackContext) {
        int notificationId = -1;
        try {
            notificationId = data.getInt(0);
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("error reading id json");
            return;
        }
        if (notificationId != -1) {
            JPushInterface.clearNotificationById(this.cordova.getActivity(), notificationId);
        } else {
            callbackContext.error("error id");
        }
    }

    void addLocalNotification(JSONArray data, CallbackContext callbackContext) throws JSONException {
        int builderId = data.getInt(0);
        String content = data.getString(1);
        String title = data.getString(2);
        int notificationID = data.getInt(3);
        int broadcastTime = data.getInt(4);
        String extrasStr = data.isNull(5) ? "" : data.getString(5);
        JSONObject extras = new JSONObject();
        if (!extrasStr.isEmpty()) {
            extras = new JSONObject(extrasStr);
        }

        JPushLocalNotification ln = new JPushLocalNotification();
        ln.setBuilderId(builderId);
        ln.setContent(content);
        ln.setTitle(title);
        ln.setNotificationId(notificationID);
        ln.setBroadcastTime(System.currentTimeMillis() + broadcastTime);
        ln.setExtras(extras.toString());

        JPushInterface.addLocalNotification(this.cordova.getActivity(), ln);
    }

    void removeLocalNotification(JSONArray data, CallbackContext callbackContext) throws JSONException {
        int notificationID = data.getInt(0);
        JPushInterface.removeLocalNotification(this.cordova.getActivity(), notificationID);
    }

    void clearLocalNotifications(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.clearLocalNotifications(this.cordova.getActivity());
    }

    /**
     * 设置通知静默时间 http://docs.jpush.io/client/android_api/#api_5
     */
    void setSilenceTime(JSONArray data, CallbackContext callbackContext) {
        try {
            int startHour = data.getInt(0);
            int startMinute = data.getInt(1);
            int endHour = data.getInt(2);
            int endMinute = data.getInt(3);
            if (!isValidHour(startHour) || !isValidMinute(startMinute)) {
                callbackContext.error("开始时间数值错误");
                return;
            }
            if (!isValidHour(endHour) || !isValidMinute(endMinute)) {
                callbackContext.error("结束时间数值错误");
                return;
            }
            JPushInterface.setSilenceTime(this.cordova.getActivity(), startHour, startMinute, endHour, endMinute);
        } catch (JSONException e) {
            e.printStackTrace();
            callbackContext.error("error: reading json data.");
        }
    }

    void setGeofenceInterval(JSONArray data, CallbackContext callbackContext) throws JSONException {
        long interval = data.getLong(0);
        JPushInterface.setGeofenceInterval(this.cordova.getActivity(), interval);
    }

    void setMaxGeofenceNumber(JSONArray data, CallbackContext callbackContext) throws JSONException {
        int maxNumber = data.getInt(0);
        JPushInterface.setMaxGeofenceNumber(mContext, maxNumber);
    }

    private boolean isValidHour(int hour) {
        return !(hour < 0 || hour > 23);
    }

    private boolean isValidMinute(int minute) {
        return !(minute < 0 || minute > 59);
    }

    /**
     * 用于 Android 6.0 以上系统申请权限，具体可参考：
     * http://docs.Push.io/client/android_api/#android-60
     */
    void requestPermission(JSONArray data, CallbackContext callbackContext) {
        JPushInterface.requestPermission(this.cordova.getActivity());
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
                final String jsEvent = String.format("cordova.fireDocumentEvent('jpush.setTagsWithAlias',%s)",
                        data.toString());
                cordova.getActivity().runOnUiThread(new Runnable() {
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

    private boolean hasPermission(String appOpsServiceId) {

        Context context = cordova.getActivity().getApplicationContext();
        if (Build.VERSION.SDK_INT >= 24) {
            NotificationManager mNotificationManager = (NotificationManager) context
                    .getSystemService(Context.NOTIFICATION_SERVICE);
            return mNotificationManager.areNotificationsEnabled();
        } else {
            AppOpsManager mAppOps = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
            ApplicationInfo appInfo = context.getApplicationInfo();

            String pkg = context.getPackageName();
            int uid = appInfo.uid;
            Class appOpsClazz;

            try {
                appOpsClazz = Class.forName(AppOpsManager.class.getName());
                Method checkOpNoThrowMethod = appOpsClazz.getMethod("checkOpNoThrow", Integer.TYPE, Integer.TYPE,
                        String.class);
                Field opValue = appOpsClazz.getDeclaredField(appOpsServiceId);
                int value = opValue.getInt(Integer.class);
                Object result = checkOpNoThrowMethod.invoke(mAppOps, value, uid, pkg);
                return Integer.parseInt(result.toString()) == AppOpsManager.MODE_ALLOWED;
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (NoSuchMethodException e) {
                e.printStackTrace();
            } catch (NoSuchFieldException e) {
                e.printStackTrace();
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        }

        return false;
    }

}
