package cn.jiguang.cordova.push;

import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Set;

import cn.jpush.android.api.CustomMessage;
import cn.jpush.android.api.JPushMessage;
import cn.jpush.android.api.NotificationMessage;
import cn.jpush.android.helper.Logger;
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
        super.onMessage(context,customMessage);
        //Log.e(TAG,"onMessage:"+customMessage);
//        String msg = customMessage.message;//intent.getStringExtra(JPushInterface.EXTRA_MESSAGE);
//        Map<String, Object> extras = getNotificationExtras(intent);
//        JPushPlugin.transmitMessageReceive(msg, extras);
    }

    @Override
    public void onNotifyMessageArrived(Context context, NotificationMessage notificationMessage) {
        super.onNotifyMessageArrived(context, notificationMessage);

        cn.jiguang.cordova.push.JLogger.d(TAG,"onNotifyMessageArrived:"+notificationMessage);
    }

    @Override
    public void onNotifyMessageOpened(Context context, NotificationMessage notificationMessage) {
        super.onNotifyMessageOpened(context, notificationMessage);
        cn.jiguang.cordova.push.JLogger.d(TAG,"onNotifyMessageOpened:"+notificationMessage);
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
}
