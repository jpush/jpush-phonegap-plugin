package cn.jiguang.cordova.push;

import android.os.Bundle;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.lang.reflect.Array;
import java.util.List;
import java.util.Map;

/** Preserve SDK types for cmd2013 only; legacy command payloads remain unchanged. */
final class SubscriptionResultCodec {
    private SubscriptionResultCodec() {}
    static JSONObject fromBundle(Bundle bundle) throws JSONException { return (JSONObject) encode(bundle, 0); }
    private static Object encode(Object value, int depth) throws JSONException {
        if (value == null || depth > 16) return JSONObject.NULL;
        if (value instanceof Bundle) {
            JSONObject result = new JSONObject();
            for (String key : ((Bundle) value).keySet()) {
                if (!key.startsWith("intent_")) result.put(key, encode(((Bundle) value).get(key), depth + 1));
            }
            return result;
        }
        if (value instanceof Map) {
            JSONObject result = new JSONObject();
            for (Map.Entry<?, ?> entry : ((Map<?, ?>) value).entrySet()) {
                if (entry.getKey() instanceof String && !((String) entry.getKey()).startsWith("intent_"))
                    result.put((String) entry.getKey(), encode(entry.getValue(), depth + 1));
            }
            return result;
        }
        if (value instanceof List || value.getClass().isArray()) {
            JSONArray result = new JSONArray();
            int size = value instanceof List ? ((List<?>) value).size() : Array.getLength(value);
            for (int i = 0; i < size; i++) result.put(encode(value instanceof List ? ((List<?>) value).get(i) : Array.get(value, i), depth + 1));
            return result;
        }
        return value instanceof String || value instanceof Boolean || value instanceof Number ? value : JSONObject.NULL;
    }
}
