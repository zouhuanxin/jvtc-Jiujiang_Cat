package com.example.flutter_app01.Receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.example.flutter_app01.Util.Utils;
import com.example.flutter_app01.WebView.MyWebView;

public class NotificationReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println("NotificationReceiver");
        Intent launchIntent = context.getPackageManager().getLaunchIntentForPackage("com.example.flutter_app01");
        context.startActivity(launchIntent);
        Intent intent2 = new Intent(context,MyWebView.class);
        intent2.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        //intent2.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent2.putExtra("url",intent.getStringExtra("url"));
        intent2.putExtra("title",intent.getStringExtra("title"));
        context.startActivity(intent2);
//        if (Utils.flutteractivity!=null){
//            System.out.println(Utils.flutteractivity);
//            System.out.println(Utils.eventSink);
//            //EventChannelPlugin.registerWith(Utils.flutteractivity).send("测试内容");
//            Utils.eventSink.success(intent.getStringExtra("url"));
//            //Utils.eventSink.endOfStream();
//        } else {
//            System.out.println("Utils.flutteractivity不能为空");
//        }
    }
}
