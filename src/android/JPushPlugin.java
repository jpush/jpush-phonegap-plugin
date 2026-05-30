package cn.jpush.phonegap;

import android.content.Context;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.api.JPushMessage;
import cn.jpush.android.api.JPushMessageReceiver;
import cn.jpush.android.api.NotificationMessage;
import cn.jpush.android.api.TagAliasCallback;

import java.util.HashSet;
import java.util.Set;

public class JPushPlugin extends CordovaPlugin {

    private static final String TAG = "JPushPlugin";

    private static Context applicationContext;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        applicationContext = cordova.getActivity().getApplicationContext();
        Log.d(TAG, "JPushPlugin initialized");
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        Log.d(TAG, "execute action: " + action);
        if ("init".equals(action)) {
            init(callbackContext);
            return true;
        } else if ("setDebugMode".equals(action)) {
            boolean enable = args.getBoolean(0);
            setDebugMode(enable, callbackContext);
            return true;
        } else if ("getRegistrationID".equals(action)) {
            getRegistrationID(callbackContext);
            return true;
        } else if ("stopPush".equals(action)) {
            stopPush(callbackContext);
            return true;
        } else if ("resumePush".equals(action)) {
            resumePush(callbackContext);
            return true;
        } else if ("isPushStopped".equals(action)) {
            isPushStopped(callbackContext);
            return true;
        } else if ("setKeepLongConnInBackground".equals(action)) {
            boolean keep = args.getBoolean(0);
            setKeepLongConnInBackground(keep, callbackContext);
            return true;
        }
        return false;
    }

    private void init(CallbackContext callbackContext) {
        JPushInterface.init(applicationContext);
        callbackContext.success();
    }

    private void setDebugMode(boolean enable, CallbackContext callbackContext) {
        JPushInterface.setDebugMode(enable);
        callbackContext.success();
    }

    private void getRegistrationID(CallbackContext callbackContext) {
        String registrationID = JPushInterface.getRegistrationID(applicationContext);
        callbackContext.success(registrationID);
    }

    private void stopPush(CallbackContext callbackContext) {
        JPushInterface.stopPush(applicationContext);
        callbackContext.success();
    }

    private void resumePush(CallbackContext callbackContext) {
        JPushInterface.resumePush(applicationContext);
        callbackContext.success();
    }

    private void isPushStopped(CallbackContext callbackContext) {
        boolean stopped = JPushInterface.isPushStopped(applicationContext);
        callbackContext.success(stopped ? 1 : 0);
    }

    // New API: setKeepLongConnInBackground - added in JPush Android SDK 6.1.0
    private void setKeepLongConnInBackground(boolean keep, CallbackContext callbackContext) {
        try {
            // Reflection to support older SDK versions gracefully
            java.lang.reflect.Method method = JPushInterface.class.getMethod("setKeepLongConnInBackground", Context.class, boolean.class);
            method.invoke(null, applicationContext, keep);
            callbackContext.success();
        } catch (Exception e) {
            Log.e(TAG, "setKeepLongConnInBackground not available in current SDK version", e);
            callbackContext.error("Method not found");
        }
    }

    // JPushMessageReceiver callback handling for onVoipMessage (added in JPush Android SDK 6.1.0)
    public static class JPushPluginReceiver extends JPushMessageReceiver {
        @Override
        public void onVoipMessage(Context context, NotificationMessage notificationMessage) {
            // Forward to JS via Cordova bridge
            // Implementation depends on how plugin wants to expose this callback
            // For now, placeholder for future enhancement
            Log.d(TAG, "onVoipMessage received: " + notificationMessage.toString());
        }
    }
}