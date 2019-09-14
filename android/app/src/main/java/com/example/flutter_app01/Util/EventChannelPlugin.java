package com.example.flutter_app01.Util;

import android.app.Activity;
import android.widget.Toast;

import io.flutter.plugin.common.EventChannel;
import io.flutter.view.FlutterView;

public class EventChannelPlugin implements EventChannel.StreamHandler {
    private EventChannel.EventSink eventSink;
    private Activity activity;
    public static EventChannelPlugin registerWith(FlutterView flutterView) {
        EventChannelPlugin plugin = new EventChannelPlugin(flutterView);
        new EventChannel(flutterView, "EventChannelPlugin").setStreamHandler(plugin);
        return plugin;
    }
    private EventChannelPlugin(FlutterView flutterView) {
        this.activity = (Activity) flutterView.getContext();
    }
    public void send(Object params) {
        System.out.println("send eventSink:"+eventSink);
        if (eventSink != null) {
            eventSink.success(params);
        }
    }
    public void sendError(String str1, String str2, Object params) {
        if (eventSink != null) {
            eventSink.error(str1, str2, params);
        }
    }
    public void cancel() {
        if (eventSink != null) {
            eventSink.endOfStream();
        }
    }
    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
        System.out.println("eventSink：" + eventSink);
        System.out.println("Object：" + o.toString());
        Toast.makeText(activity, "onListen——obj：" + o, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onCancel(Object o) {
        System.out.println("onCancel：" + o.toString());
        Toast.makeText(activity, "onCancel——obj：" + o, Toast.LENGTH_SHORT).show();
        this.eventSink = null;
    }
}
