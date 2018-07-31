package cn.jiguang.cordova.push;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import org.apache.cordova.CallbackContext;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Set;

import cn.jpush.android.api.JPushMessage;
import cn.jpush.android.service.JPushMessageReceiver;

public class JPushEventReceiver extends JPushMessageReceiver {

    private static final String TAG = JPushEventReceiver.class.getSimpleName();

    @Override
    public void onTagOperatorResult(Context context, JPushMessage jPushMessage) {
        super.onTagOperatorResult(context, jPushMessage);

        JSONObject resultJson = new JSONObject();

        int sequence = jPushMessage.getSequence();
        try {
            resultJson.put("sequence", sequence);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        CallbackContext callback = JPushPlugin.eventCallbackMap.get(sequence);

        if (callback == null) {
            Log.i(TAG, "Unexpected error, callback is null!");
            return;
        }

        if (jPushMessage.getErrorCode() == 0) { // success
            Set<String> tags = jPushMessage.getTags();
            JSONArray tagsJsonArr = new JSONArray();
            for (String tag : tags) {
                tagsJsonArr.put(tag);
            }

            try {
                if (tagsJsonArr.length() != 0) {
                    resultJson.put("tags", tagsJsonArr);
                }
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

        JPushPlugin.eventCallbackMap.remove(sequence);
    }

    @Override
    public void onCheckTagOperatorResult(Context context, JPushMessage jPushMessage) {
        super.onCheckTagOperatorResult(context, jPushMessage);

        JSONObject resultJson = new JSONObject();

        int sequence = jPushMessage.getSequence();
        try {
            resultJson.put("sequence", sequence);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        CallbackContext callback = JPushPlugin.eventCallbackMap.get(sequence);

        if (callback == null) {
            Log.i(TAG, "Unexpected error, callback is null!");
            return;
        }

        if (jPushMessage.getErrorCode() == 0) {
            try {
                resultJson.put("tag", jPushMessage.getCheckTag());
                resultJson.put("isBind", jPushMessage.getTagCheckStateResult());
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

        JPushPlugin.eventCallbackMap.remove(sequence);
    }

    @Override
    public void onAliasOperatorResult(Context context, JPushMessage jPushMessage) {
        super.onAliasOperatorResult(context, jPushMessage);

        JSONObject resultJson = new JSONObject();

        int sequence = jPushMessage.getSequence();
        try {
            resultJson.put("sequence", sequence);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        CallbackContext callback = JPushPlugin.eventCallbackMap.get(sequence);

        if (callback == null) {
            Log.i(TAG, "Unexpected error, callback is null!");
            return;
        }

        if (jPushMessage.getErrorCode() == 0) { // success
            try {
                if (!TextUtils.isEmpty(jPushMessage.getAlias())) {
                    resultJson.put("alias", jPushMessage.getAlias());
                }
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

        JPushPlugin.eventCallbackMap.remove(sequence);
    }
}
