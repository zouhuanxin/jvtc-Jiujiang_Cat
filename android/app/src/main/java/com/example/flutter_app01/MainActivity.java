package com.example.flutter_app01;

import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Toast;

import com.example.flutter_app01.Util.Utils;

import java.io.File;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.logging.Logger;

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
                      Utils.eventSink=events;
                  }

                  @Override
                  public void onCancel(Object args) {
                      //System.out.println("cancelling listener");
                  }
              }
      );
        Bmob.initialize(this, "931aa07205e9cddf2cd85458d029af79");
        // 使用推送服务时的初始化操作
        BmobInstallationManager.getInstance().initialize(new InstallationListener<BmobInstallation>() {
            @Override
            public void done(BmobInstallation bmobInstallation, BmobException e) {
                if (e == null) {
                    System.out.println(bmobInstallation.getObjectId() + "-" + bmobInstallation.getInstallationId());
                } else {
                    System.out.println(e.getMessage());
                }
            }
        });
        // 启动推送服务
        BmobPush.startWork(this);

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
                        res.success(file.getPath());
                    }

                    @Override
                    public void onError(Throwable e) {
                        // TODO 当压缩过程出现问题时调用
                        System.out.println("压缩失败");
                        res.success("压缩失败");
                        e.printStackTrace();
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

}
