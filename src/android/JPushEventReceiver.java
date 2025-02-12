package cn.jiguang.cordova.push;

import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;

import cn.jpush.android.api.CustomMessage;
import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.api.JPushMessage;
import cn.jpush.android.api.NotificationMessage;
import cn.jpush.android.helper.Logger;
import cn.jpush.android.local.JPushConstants;
import cn.jpush.android.service.JPushMessageReceiver;

public class JPushEventReceiver extends JPushMessageReceiver {

    private static final String TAG = JPushEventReceiver.class.getSimpleName();

    @Override
    public void onTagOperatorResult(Context context, JPushMessage jPushMessage) {
        super.onTagOperatorResult(context, jPushMessage);
        cn.jiguang.cordova.push.JLogger.d(TAG,"onTagOperatorResult:"+jPushMessage);

        tryCallback(jPushMessage, new SuccessCallback() {
            @Override
            public void onSuccessCallback(JSONObject resultJson) throws JSONException {
                Set<String> tags = jPushMessage.getTags();
                JSONArray tagsJsonArr = new JSONArray();
                for (String tag : tags) {
                    tagsJsonArr.put(tag);
                }
                if (tagsJsonArr.length() != 0) {
                    resultJson.put("tags", tagsJsonArr);
                }

            }
        });
    }

    @Override
    public void onCheckTagOperatorResult(Context context, JPushMessage jPushMessage) {
        super.onCheckTagOperatorResult(context, jPushMessage);

        cn.jiguang.cordova.push.JLogger.d(TAG,"onCheckTagOperatorResult:"+jPushMessage);

        tryCallback(jPushMessage, new SuccessCallback() {
            @Override
            public void onSuccessCallback(JSONObject resultJson) throws JSONException {
                resultJson.put("tag", jPushMessage.getCheckTag());
                resultJson.put("isBind", jPushMessage.getTagCheckStateResult());
            }
        });
    }

    @Override
    public void onAliasOperatorResult(Context context, JPushMessage jPushMessage) {
        super.onAliasOperatorResult(context, jPushMessage);

        cn.jiguang.cordova.push.JLogger.d(TAG,"onAliasOperatorResult:"+jPushMessage);

        tryCallback(jPushMessage, new SuccessCallback() {
            @Override
            public void onSuccessCallback(JSONObject resultJson) throws JSONException {
                if (!TextUtils.isEmpty(jPushMessage.getAlias())) {
                    resultJson.put("alias", jPushMessage.getAlias());
                }
            }
        });
    }

    @Override
    public void onRegister(Context context, String regId) {
        cn.jiguang.cordova.push.JLogger.d(TAG,"onRegister:"+regId);
        cn.jiguang.cordova.push.JPushPlugin.transmitReceiveRegistrationId(regId);
    }

    @Override
    public void onMessage(Context context, CustomMessage customMessage) {
//        super.onMessage(context,customMessage);
        cn.jiguang.cordova.push.JLogger.d(TAG,"onMessage:"+customMessage);
        try {
            JSONObject jsonObject=new JSONObject();
            jsonObject.put("message", customMessage.message);
            jsonObject.put("alert", customMessage.title);
            jsonObject.put(JPushInterface.EXTRA_EXTRA, stringToMap(customMessage.extra));
            jsonObject.put(JPushInterface.EXTRA_MSG_ID, customMessage.messageId);
            jsonObject.put(JPushInterface.EXTRA_CONTENT_TYPE, customMessage.contentType);
            if (JPushConstants.SDK_VERSION_CODE >= 387) {
                jsonObject.put(JPushInterface.EXTRA_TYPE_PLATFORM, customMessage.platform);
            }
            cn.jiguang.cordova.push.JPushPlugin.transmitNotificationReceive(jsonObject);
        }catch (Throwable throwable){
            cn.jiguang.cordova.push.JLogger.d(TAG,"onMessage throwable:"+throwable);

        }
    }

    @Override
    public void onNotifyMessageArrived(Context context, NotificationMessage notificationMessage) {
//        super.onNotifyMessageArrived(context, notificationMessage);
        cn.jiguang.cordova.push.JLogger.d(TAG,"onNotifyMessageArrived:"+notificationMessage);
        try {
            JSONObject jsonObject=new JSONObject();
            jsonObject.put("title", notificationMessage.notificationTitle);
            jsonObject.put("alert", notificationMessage.notificationContent);
            getExtras(jsonObject,notificationMessage);
            JPushPlugin.notificationJson = jsonObject;
            cn.jiguang.cordova.push.JPushPlugin.transmitNotificationReceive(jsonObject);
        }catch (Throwable throwable){
            cn.jiguang.cordova.push.JLogger.d(TAG,"onNotifyMessageArrived throwable:"+throwable);

        }
    }

    @Override
    public void onNotifyMessageOpened(Context context, NotificationMessage notificationMessage) {
//        super.onNotifyMessageOpened(context, notificationMessage);
        cn.jiguang.cordova.push.JLogger.d(TAG,"onNotifyMessageOpened:"+notificationMessage);

        try {
            JSONObject jsonObject=new JSONObject();
            jsonObject.put("title", notificationMessage.notificationTitle);
            jsonObject.put("alert", notificationMessage.notificationContent);
            getExtras(jsonObject,notificationMessage);
            JPushPlugin.openNotificationJson = jsonObject;
            cn.jiguang.cordova.push.JPushPlugin.transmitNotificationOpen(jsonObject);
        }catch (Throwable throwable){
            cn.jiguang.cordova.push.JLogger.d(TAG,"onNotifyMessageOpened throwable:"+throwable);

        }
        Intent launch = context.getPackageManager().getLaunchIntentForPackage(context.getPackageName());
        if (launch != null) {
            launch.addCategory(Intent.CATEGORY_LAUNCHER);
            launch.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
            context.startActivity(launch);
        }
    }
    private void getExtras(JSONObject extras,NotificationMessage notificationMessage) {
        try {
            extras.put(JPushInterface.EXTRA_MSG_ID, notificationMessage.msgId);
            extras.put(JPushInterface.EXTRA_NOTIFICATION_ID, notificationMessage.notificationId);
            extras.put(JPushInterface.EXTRA_ALERT_TYPE, notificationMessage.notificationAlertType + "");
            extras.put(JPushInterface.EXTRA_EXTRA, stringToMap(notificationMessage.notificationExtras));
            if (notificationMessage.notificationStyle == 1 && !TextUtils.isEmpty(notificationMessage.notificationBigText)) {
                extras.put(JPushInterface.EXTRA_BIG_TEXT, notificationMessage.notificationBigText);
            } else if (notificationMessage.notificationStyle == 2 && !TextUtils.isEmpty(notificationMessage.notificationInbox)) {
                extras.put(JPushInterface.EXTRA_INBOX, notificationMessage.notificationInbox);
            } else if ((notificationMessage.notificationStyle == 3) && !TextUtils.isEmpty(notificationMessage.notificationBigPicPath)) {
                extras.put(JPushInterface.EXTRA_BIG_PIC_PATH, notificationMessage.notificationBigPicPath);
            }
            if (!(notificationMessage.notificationPriority == 0)) {
                extras.put(JPushInterface.EXTRA_NOTI_PRIORITY, notificationMessage.notificationPriority + "");
            }
            if (!TextUtils.isEmpty(notificationMessage.notificationCategory)) {
                extras.put(JPushInterface.EXTRA_NOTI_CATEGORY, notificationMessage.notificationCategory);
            }
            if (!TextUtils.isEmpty(notificationMessage.notificationSmallIcon)) {
                extras.put(JPushInterface.EXTRA_NOTIFICATION_SMALL_ICON, notificationMessage.notificationSmallIcon);
            }
            if (!TextUtils.isEmpty(notificationMessage.notificationLargeIcon)) {
                extras.put(JPushInterface.EXTRA_NOTIFICATION_LARGET_ICON, notificationMessage.notificationLargeIcon);
            }
        } catch (Throwable e) {
            Log.e(TAG, "[onNotifyMessageUnShow] e:" + e.getMessage());
        }
    }
    @Override
    public void onMobileNumberOperatorResult(Context context, JPushMessage jPushMessage) {
        super.onMobileNumberOperatorResult(context, jPushMessage);
        cn.jiguang.cordova.push.JLogger.d(TAG,"onMobileNumberOperatorResult:"+jPushMessage);

        tryCallback(jPushMessage, new SuccessCallback() {
            @Override
            public void onSuccessCallback(JSONObject resultJson) throws JSONException {
                if (!TextUtils.isEmpty(jPushMessage.getMobileNumber())) {
                    resultJson.put("mobileNumber", jPushMessage.getMobileNumber());
                }
            }
        });
    }

    @Override
    public void onMultiActionClicked(Context context, Intent intent) {
        super.onMultiActionClicked(context, intent);
        cn.jiguang.cordova.push.JLogger.d(TAG,"onMultiActionClicked:"+intent);
    }
    @Override
    public void onInAppMessageShow(Context context,final NotificationMessage message) {
       cn.jiguang.cordova.push.JLogger.d(TAG, "[onInAppMessageShow], " + message.toString());
        try {
            JSONObject jsonObject=new JSONObject();
            jsonObject.put("title", message.inAppMsgTitle);
            jsonObject.put("alert", message.inAppMsgContentBody);
            jsonObject.put("messageId", message.msgId);
            jsonObject.put("inAppShowTarget",  message.inAppExtras);
            jsonObject.put("inAppClickAction",  message.inAppClickAction);
            jsonObject.put("inAppExtras", message.inAppExtras);
           cn.jiguang.cordova.push.JPushPlugin.transmitInAppMessageShow(jsonObject);

        }catch (Throwable throwable){

        }
    }

    @Override
    public void onInAppMessageClick(Context context,final NotificationMessage message) {
        cn.jiguang.cordova.push.JLogger.d(TAG, "[onInAppMessageClick], " + message.toString());
        try {
            JSONObject jsonObject=new JSONObject();
            jsonObject.put("title", message.inAppMsgTitle);
            jsonObject.put("alert", message.inAppMsgContentBody);
            jsonObject.put("messageId", message.msgId);
            jsonObject.put("inAppShowTarget",  message.inAppExtras);
            jsonObject.put("inAppClickAction",  message.inAppClickAction);
            jsonObject.put("inAppExtras", message.inAppExtras);
            cn.jiguang.cordova.push.JPushPlugin.transmitInAppMessageClick(jsonObject);

        }catch (Throwable throwable){

        }

    }
    interface SuccessCallback{
        void onSuccessCallback(JSONObject resultJson) throws JSONException;
    }
    public void tryCallback(JPushMessage jPushMessage,SuccessCallback successCallback){
        JSONObject resultJson = new JSONObject();

        int sequence = jPushMessage.getSequence();
        try {
            resultJson.put("sequence", sequence);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        CallbackContext callback = cn.jiguang.cordova.push.JPushPlugin.eventCallbackMap.get(sequence);

        if (callback == null) {
            Logger.i(TAG, "Unexpected error, callback is null!");
            return;
        }

        if (jPushMessage.getErrorCode() == 0) {
            try {
                successCallback.onSuccessCallback(resultJson);
            } catch (JSONException e) {
                e.printStackTrace();
            }
            callback.success(resultJson);

        } else {
            try {
                resultJson.put("code", jPushMessage.getErrorCode());
            } catch (JSONException e) {
                e.printStackTrace();
            }
            callback.error(resultJson);
        }

        cn.jiguang.cordova.push.JPushPlugin.eventCallbackMap.remove(sequence);

    }
    public Map<String, Object> stringToMap(String extra) {
        Map<String, Object> useExtra = new HashMap<String, Object>();
        try {
            if (TextUtils.isEmpty(extra)) {
                return useExtra;
            }
            JSONObject object = new JSONObject(extra);
            Iterator<String> keys = object.keys();
            while (keys.hasNext()) {
                try {
                    String key = keys.next();
                    Object value = object.get(key);
                    if (value instanceof Integer
                            || value instanceof Long
                            || value instanceof Boolean
                            || value instanceof String) {
                        useExtra.put(key, value);
                    } else {
                        useExtra.put(key, String.valueOf(value));
                    }
                } catch (Throwable throwable) {

                }
            }
        } catch (Throwable throwable) {
        }
        return useExtra;
    }
}
