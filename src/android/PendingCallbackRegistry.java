package cn.jiguang.cordova.push;

import android.os.Handler;
import android.os.Looper;
import org.apache.cordova.CallbackContext;
import org.json.JSONObject;
import java.util.HashMap;
import java.util.Map;

/** Per-instance, per-request replies. Reset releases WebView callbacks before late SDK results. */
final class PendingCallbackRegistry {
    private final Map<Long, CallbackContext> replies = new HashMap<>();
    private long sequence;
    synchronized long add(CallbackContext callback) { long id = ++sequence; replies.put(id, callback); return id; }
    synchronized boolean contains(long id) { return replies.containsKey(id); }
    synchronized void clear() { replies.clear(); }
    void success(long id, JSONObject result) { finish(id, result, null); }
    void error(long id, String error) { finish(id, null, error); }
    private void finish(long id, JSONObject result, String error) {
        new Handler(Looper.getMainLooper()).post(() -> {
            CallbackContext callback;
            synchronized (this) { callback = replies.remove(id); }
            if (callback == null) return;
            if (error != null) callback.error(error);
            else if (result == null) callback.success();
            else callback.success(result);
        });
    }
}
