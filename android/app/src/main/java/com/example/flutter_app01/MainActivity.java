package com.example.flutter_app01;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.RemoteViews;
import android.widget.Toast;

import com.example.flutter_app01.Util.Utils;

import org.json.JSONArray;
import org.json.JSONObject;

import java.io.File;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;
import java.util.logging.Logger;

import androidx.core.app.NotificationCompat;
import cn.bmob.push.BmobPush;
import cn.bmob.v3.Bmob;
import cn.bmob.push.*;
import cn.bmob.v3.BmobInstallation;
import cn.bmob.v3.BmobInstallationManager;
import cn.bmob.v3.InstallationListener;
import cn.bmob.v3.exception.BmobException;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import top.zibin.luban.Luban;
import top.zibin.luban.OnCompressListener;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "test";
    private static MethodChannel.Result res;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Utils.flutteractivity = getFlutterView();

        //单向通信
        new EventChannel(Utils.flutteractivity, "EventChannelPlugin").setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, final EventChannel.EventSink events) {
                        //System.out.println("adding listener");
                        Utils.eventSink = events;
                    }

                    @Override
                    public void onCancel(Object args) {
                        //System.out.println("cancelling listener");
                    }
                }
        );


        //由于push推送在适配高版本安卓系统上还存在问题 所以目前暂时停用bmob push推送
//        Bmob.initialize(this, "931aa07205e9 cddf2cd85458d029af79");
//        // 使用推送服务时的初始化操作
//        BmobInstallationManager.getInstance().initialize(new InstallationListener<BmobInstallation>() {
//            @Override
//            public void done(BmobInstallation bmobInstallation, BmobException e) {
//                if (e == null) {
//                    System.out.println(bmobInstallation.getObjectId() + "-" + bmobInstallation.getInstallationId());
//                } else {
//                    System.out.println(e.getMessage());
//                }
//            }
//        });
//        // 启动推送服务
//        BmobPush.startWork(this);

        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        res = result;
                        if (methodCall.method.equals("getFile")) {
                            getFile(methodCall.argument("path"));
                        } else if (methodCall.method.equals("daysBetween")) {
                            res.success(daysBetween(methodCall.argument("str1"), methodCall.argument("str2")));
                        } else if (methodCall.method.equals("daysBetween2")) {
                            res.success(daysBetween2(methodCall.argument("str1"), methodCall.argument("str2")));
                        } else if (methodCall.method.equals("course_tzl")) {
                            androidpush(methodCall.argument("list"));
                        } else if (methodCall.method.equals("cancelNotification")) {
                            cancelNotification(methodCall.argument("id"));
                        } else if (methodCall.method.equals("androidpush2")) {
                            androidpush2(methodCall.argument("list"));
                        }
                    }
                });
    }

    public void showToast(String msg) {
        Toast.makeText(this, msg, Toast.LENGTH_LONG).show();
    }

    private void getFile(String path) {
        File file = new File(path);//创建文件
        Luban.with(this)
                .load(file)
                .setCompressListener(new OnCompressListener() { //设置回调
                    @Override
                    public void onStart() {
                        // TODO 压缩开始前调用，可以在方法内启动 loading UI
                        System.out.println("开始压缩");
                    }

                    @Override
                    public void onSuccess(File file) {
                        // TODO 压缩成功后调用，返回压缩后的图片文件
                        System.out.println("压缩成功:" + file.getPath());
                        try {
                            res.success(file.getPath());
                        } catch (Exception e) {
                            //showToast("压缩对象错误");
                        }
                    }

                    @Override
                    public void onError(Throwable e) {
                        // TODO 当压缩过程出现问题时调用
                        System.out.println("压缩失败");
                        e.printStackTrace();
                        try {
                            res.success("压缩失败");
                        } catch (Exception e2) {
                            //showToast("压缩对象错误");
                        }
                    }
                }).launch();    //启动压缩
    }


    /**
     * 计算两个日期之间相差的天数
     *
     * @return
     */
    public static int daysBetween(String str1, String str2) {
        DateFormat format1 = new SimpleDateFormat("yyyy-MM-dd");
        Date date1 = null;
        Date date2 = null;
        try {
            date1 = format1.parse(str1);
            date2 = format1.parse(str2);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        Calendar cal = Calendar.getInstance();
        cal.setTime(date1);
        long time1 = cal.getTimeInMillis();
        cal.setTime(date2);
        long time2 = cal.getTimeInMillis();
        long between_days = (time2 - time1) / (1000 * 3600 * 24);
        return Integer.parseInt(String.valueOf(between_days));
    }

    public static int daysBetween2(String str1, String str2) {
        DateFormat format1 = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        Date date1 = null;
        Date date2 = null;
        try {
            date1 = format1.parse(str1);
            date2 = format1.parse(str2);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        long nd = 1000 * 24 * 60 * 60;
        long nh = 1000 * 60 * 60;
        long nm = 1000 * 60;
        // long ns = 1000;
        // 获得两个时间的毫秒时间差异
        long diff = date2.getTime() - date1.getTime();
        // 计算差多少天
        long day = diff / nd;
        // 计算差多少小时
        long hour = diff % nd / nh;
        // 计算差多少分钟
        long min = diff % nd % nh / nm;
        // 计算差多少秒//输出结果
        // long sec = diff % nd % nh % nm / ns;
        long res = day * 24 * 60 + hour * 60 + min;
        return Integer.parseInt(String.valueOf(res));
    }

    //开启一个手机通知栏信息
    public void androidpush(List<String> list){
        String channelId = "my_channel_01";
        String channelName="我是九职小猫手课表通知";
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy年MM月dd日");// HH:mm:ss
        //获取当前时间
        Date date = new Date(System.currentTimeMillis());
        NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        //8.0 以后需要加上channelId 才能正常显示
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationChannel channel = new NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_HIGH);
            channel.enableLights(false);
            channel.enableVibration(false);
            channel.setVibrationPattern(new long[]{0});
            channel.setSound(null, null);
            manager.createNotificationChannel(channel);
        }
        NotificationCompat.InboxStyle inboxStyle = new NotificationCompat.InboxStyle();
        List <String>arrlist=new ArrayList<>();
        arrlist.add("第一大节");
        arrlist.add("第二大节");
        arrlist.add("第三大节");
        arrlist.add("第四大节");
        arrlist.add("第五大节");
        arrlist.add("第六大节");
        for(int i=0;i<7;i++){
            String str1=list.get(1+8*i)
                    .split("kcname:")[1]
                    .trim();
            String str2=list.get(2+8*i)
                    .split("kcname:")[1]
                    .trim();
            String str3=list.get(3+8*i)
                    .split("kcname:")[1]
                    .trim();
            String str4=list.get(4+8*i)
                    .split("kcname:")[1]
                    .trim();
            String str5=list.get(5+8*i)
                    .split("kcname:")[1]
                    .trim();
            String str6=list.get(6+8*i)
                    .split("kcname:")[1]
                    .trim();
            String str7=list.get(7+8*i)
                    .split("kcname:")[1]
                    .trim();
            str1=str1.equals("}")==true?str1.replace("}"," "):str1.replace("}"," ");
            str2=str2.equals("}")==true?str2.replace("}"," "):str2.replace("}"," ");
            str3=str3.equals("}")==true?str3.replace("}"," "):str3.replace("}"," ");
            str4=str4.equals("}")==true?str4.replace("}"," "):str4.replace("}"," ");
            str5=str5.equals("}")==true?str5.replace("}"," "):str5.replace("}"," ");
            str6=str6.equals("}")==true?str6.replace("}"," "):str6.replace("}"," ");
            str7=str7.equals("}")==true?str7.replace("}"," "):str7.replace("}"," ");

            str1=str1.replace("..","");
            str2=str2.replace("..","");
            str3=str3.replace("..","");
            str4=str4.replace("..","");
            str5=str5.replace("..","");
            str6=str6.replace("..","");
            str7=str7.replace("..","");
            int week=getWeek();
            //System.out.println("wekk:"+week);
            if(i==0){
                //由于限制所以这里采用 昨天 今天 明天 的显示模式
//                if(week==2){
//                    inboxStyle.setBigContentTitle(" 今天     "+" 明天     ");
//                }else if(week==1){
//                    inboxStyle.setBigContentTitle(" 昨天     "+" 今天     ");
//                }else{
//                    inboxStyle.setBigContentTitle(" 昨天     "+" 今天     "+" 明天     ");
//                }
                //改版
                inboxStyle.setBigContentTitle("                   今天    ");
            }else{
//                if(str1.length()>4) str1=str1.substring(0,4);
//                if(str2.length()>4) str2=str2.substring(0,4);
//                if(str3.length()>4) str3=str3.substring(0,4);
//                if(str4.length()>4) str4=str4.substring(0,4);
//                if(str5.length()>4) str5=str5.substring(0,4);
//                if(str6.length()>4) str6=str6.substring(0,4);
//                if(str7.length()>4) str7=str7.substring(0,4);
                //改版
                if(week==2){
                    //inboxStyle.addLine(str1+" "+str2);
                    if(str1.length()>1) inboxStyle.addLine(arrlist.get(i-1)+"   "+str1);
                }else if(week==1){
                    //inboxStyle.addLine(str6+" "+str7);
                    if(str7.length()>1) inboxStyle.addLine(arrlist.get(i-1)+"   "+str7);
                }else if(week==3){
                    //inboxStyle.addLine(str1+" "+str2+" "+str3);
                    if(str2.length()>1) inboxStyle.addLine(arrlist.get(i-1)+"   "+str2);
                }else if(week==4){
                    //inboxStyle.addLine(str2+" "+str3+" "+str4);
                    if(str3.length()>1) inboxStyle.addLine(arrlist.get(i-1)+"   "+str3);
                }else if(week==5){
                    //inboxStyle.addLine(str3+" "+str4+" "+str5);
                    if(str4.length()>1) inboxStyle.addLine(arrlist.get(i-1)+"   "+str4);
                }else if(week==6){
                    //inboxStyle.addLine(str4+" "+str5+" "+str6);
                    if(str5.length()>1) inboxStyle.addLine(arrlist.get(i-1)+"   "+str5);
                }else if(week==7){
                    //inboxStyle.addLine(str5+" "+str6+" "+str7);
                    if(str6.length()>1) inboxStyle.addLine(arrlist.get(i-1)+"   "+str6);
                }
            }
        }
        //自定义通知信息布局
        //RemoteViews views = new RemoteViews(getPackageName(),this.getResources().getIdentifier("layout_nitification", "layout",this.getPackageName()));
        Notification notification = new NotificationCompat.Builder(this, "default")
                .setChannelId(channelId)
                //.setContent(views)
                .setSmallIcon(this.getResources().getIdentifier("cat1", "drawable",this.getPackageName()))
                .setContentTitle("九职小猫手提醒你课表信息")
                .setContentText(simpleDateFormat.format(date))
                .setOngoing(true)
                .setShowWhen(false)
                //.setDefaults(Notification.DEFAULT_ALL)  //此属性在安卓高版本上无效
                .setStyle(inboxStyle)
                .setDefaults(NotificationCompat.FLAG_ONLY_ALERT_ONCE)
                .setVibrate(new long[]{0})
                .setSound(null)
                .build();
        manager.notify(1, notification);
    }

    // 取消通知
    public void cancelNotification(int id) {
        NotificationManager notificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        notificationManager.cancel(id);
    }

    /*获取星期几*/
    public static int getWeek() {
        final Calendar cal = Calendar.getInstance();
        cal.setTimeZone(TimeZone.getTimeZone("GMT+8:00"));
        int i = cal.get(Calendar.DAY_OF_WEEK);
        return i;
//        switch (i) {
//            case 1:
//                return "星期日";
//            case 2:
//                return "星期一";
//            case 3:
//                return "星期二";
//            case 4:
//                return "星期三";
//            case 5:
//                return "星期四";
//            case 6:
//                return "星期五";
//            case 7:
//                return "星期六";
//            default:
//                return "";
//        }
    }

    //开启一个时间通知
    public void androidpush2(List<String>list){
        String channelId = "my_channel_02";
        String channelName="我是九职小猫手时间通知";
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy年MM月dd日");// HH:mm:ss
        //获取当前时间
        Date date = new Date(System.currentTimeMillis());
        NotificationManager manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
        //8.0 以后需要加上channelId 才能正常显示
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationChannel channel = new NotificationChannel(channelId, channelName, NotificationManager.IMPORTANCE_HIGH);
            channel.enableLights(false);
            channel.enableVibration(false);
            channel.setVibrationPattern(new long[]{0});
            channel.setSound(null, null);
            manager.createNotificationChannel(channel);
        }
        //自定义通知信息布局
        //RemoteViews views = new RemoteViews(getPackageName(),this.getResources().getIdentifier("layout_nitification", "layout",this.getPackageName()));
        Notification notification = new NotificationCompat.Builder(this, "default")
                .setChannelId(channelId)
                //.setContent(views)
                .setSmallIcon(this.getResources().getIdentifier("cat1", "drawable",this.getPackageName()))
                .setContentTitle("九职小猫手正在为你进行学习计时")
                .setContentText(list.get(0))
                .setOngoing(true)
                .setShowWhen(false)
                .setDefaults(NotificationCompat.FLAG_ONLY_ALERT_ONCE)
                .setVibrate(new long[]{0})
                .setSound(null)
                .build();
        manager.notify(2, notification);
    }

}
