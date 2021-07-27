package cn.jiguang.cordova.push;

import android.util.Log;

public class JLogger {

    public static final String TAG = "[Cordova-JPush]";

    private static boolean isLoggerEnable = false;

    public static void setLoggerEnable(boolean loggerEnable) {
        Log.d(TAG, "setLoggerEnable:" + loggerEnable);
        isLoggerEnable = loggerEnable;
    }

    public static void i(String tag,String msg) {
        if (isLoggerEnable) {
            Log.i(TAG+tag, msg);
        }
    }

    public static void d(String tag,String msg) {
        if (isLoggerEnable) {
            Log.d(TAG+tag, msg);
        }
    }

    public static void v(String tag,String msg) {
        if (isLoggerEnable) {
            Log.v(TAG+tag, msg);
        }
    }

    public static void w(String tag,String msg) {
        if (isLoggerEnable) {
            Log.w(TAG+tag, msg);
        }
    }

    public static void e(String tag,String error) {
        if (isLoggerEnable) {
            Log.e(TAG+tag, error);
        }
    }

}
