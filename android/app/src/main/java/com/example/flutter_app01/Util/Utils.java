package com.example.flutter_app01.Util;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;

import com.example.flutter_app01.Receiver.NotificationReceiver;

import androidx.core.app.NotificationCompat;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.view.FlutterView;

import static android.content.Context.NOTIFICATION_SERVICE;

public class Utils {

    public static FlutterView flutteractivity=null;
    public static EventChannel.EventSink eventSink=null;

    public static void tz(Context context,String title,String content,String url){

        //设置点击通知栏的动作为启动另外一个广播
        Intent clickIntent = new Intent("com.example.broadcasttest.MY_BROADCAST"); //点击通知之后要发送的广播
        clickIntent.putExtra("url",url);
        clickIntent.putExtra("title",title);
        int id = (int) (System.currentTimeMillis() / 1000);
        PendingIntent contentIntent = PendingIntent.getBroadcast(context.getApplicationContext(), id, clickIntent, PendingIntent.FLAG_UPDATE_CURRENT);

        NotificationManager notificationManager = (NotificationManager) context.getSystemService(NOTIFICATION_SERVICE);
        NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(context);
        //设置标题
        mBuilder.setContentTitle(title)
                //设置内容
                .setContentText(content)
                //设置大图标
                .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), context.getResources().getIdentifier("icon", "drawable", context.getPackageName())))
                //设置小图标
                .setSmallIcon(context.getResources().getIdentifier("cat1", "drawable", context.getPackageName()))
                //设置通知时间
                .setWhen(System.currentTimeMillis())
                //首次进入时显示效果
                .setTicker(content)
                //.setAutoCancel(true)//打开程序后图标消失
                .setContentIntent(contentIntent)
                //设置通知方式，声音，震动，呼吸灯等效果，这里通知方式为声音
                .setDefaults(Notification.DEFAULT_ALL);
        //发送通知请求
        notificationManager.notify(10, mBuilder.build());
    }

}
