package com.reactnativeintegration;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.appcompat.app.AppCompatActivity;

import com.clevertap.ct_templates.nd.coachmark.CoachMarkHelper;
import com.clevertap.ct_templates.nd.tooltips.TooltipHelper;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import org.json.JSONObject;

public class CoachMarkModule extends ReactContextBaseJavaModule {

    public CoachMarkModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "CoachMarkModule";
    }

    @ReactMethod
    public void showCoachMarks(String jsonString, Callback onComplete) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                // Perform your UI updates here
                AppCompatActivity activity = (AppCompatActivity) getCurrentActivity();
                if (activity == null) {
                    Log.e("CoachMarkModule", "Current activity is null");
                    onComplete.invoke("Activity is null"); // Pass error back to JavaScript
                    return;
                }

                try {
                    JSONObject jsonObject = new JSONObject(jsonString);
                    CoachMarkHelper coachMarkHelper = new CoachMarkHelper();
                    coachMarkHelper.renderCoachMark(activity, jsonObject, new kotlin.jvm.functions.Function0<kotlin.Unit>() {
                        @Override
                        public kotlin.Unit invoke() {
                            if (onComplete != null) {
                                onComplete.invoke(); // Notify JavaScript callback
                            }
                            return kotlin.Unit.INSTANCE;
                        }
                    });
                } catch (Exception e) {
                    Log.e("CoachMarkModule", "Error rendering coach marks: " + e.getMessage());
                    onComplete.invoke("Error rendering coach marks: " + e.getMessage()); // Pass error back
                }
            }
        });
    }

    @ReactMethod
    public void showTooltips(String jsonString, Callback onComplete) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                // Perform your UI updates here
                AppCompatActivity activity = (AppCompatActivity) getCurrentActivity();
                if (activity == null) {
                    Log.e("CoachMarkModule", "Current activity is null");
                    onComplete.invoke("Activity is null"); // Pass error back to JavaScript
                    return;
                }

                try {
                    JSONObject jsonObject = new JSONObject(jsonString);
                    TooltipHelper tooltipHelper = new TooltipHelper();
                    tooltipHelper.showTooltips(activity, jsonObject, new kotlin.jvm.functions.Function0<kotlin.Unit>() {
                        @Override
                        public kotlin.Unit invoke() {
                            if (onComplete != null) {
                                onComplete.invoke(); // Notify JavaScript callback
                            }
                            return kotlin.Unit.INSTANCE;
                        }
                    });
                } catch (Exception e) {
                    Log.e("CoachMarkModule", "Error rendering coach marks: " + e.getMessage());
                    onComplete.invoke("Error rendering coach marks: " + e.getMessage()); // Pass error back
                }
            }
        });
    }
}
