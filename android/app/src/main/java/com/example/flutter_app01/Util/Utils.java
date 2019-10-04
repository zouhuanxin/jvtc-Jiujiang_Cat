package com.example.flutter_app01.Util;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Build;

import com.example.flutter_app01.Receiver.NotificationReceiver;

import java.util.Random;

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

        NotificationManager manager = (NotificationManager) context.getSystemService(NOTIFICATION_SERVICE);
        //8.0 以后需要加上channelId 才能正常显示
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            String channelId = title;
            String channelName = content;
            manager.createNotificationChannel(new NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_HIGH));
        }
//        NotificationCompat.InboxStyle inboxStyle = new NotificationCompat.InboxStyle();
//        String[] events = new String[6];
//        events[0] = "Hello my one world";
//        events[1] = "Hello my two world";
//        events[2] = "Hello my three world";
//        events[3] = "Hello my four world";
//        events[4] = "Hello my five world";
//        events[5] = "Hello my six world";
//        inboxStyle.setBigContentTitle("Inbox tracker details:");
//        for (int i = 0; i < events.length; i++) {
//            inboxStyle.addLine(events[i]);
//        }
//        inboxStyle.setBigContentTitle("Thers are six messages");
//        inboxStyle.setSummaryText("It‘s so easy,right?");
        Notification notification = new NotificationCompat.Builder(context, "default")
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
                .setDefaults(Notification.DEFAULT_ALL)
                .build();
        manager.notify(new Random().nextInt(100), notification);
    }

}
