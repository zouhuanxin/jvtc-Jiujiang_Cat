package com.example.flutter_app01.Receiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;


public class MyPushReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
//        System.out.println("开始执行push监听");
//        if(intent.getAction().equals(PushConstants.ACTION_MESSAGE)){
//            String str=intent.getStringExtra(PushConstants.EXTRA_PUSH_MESSAGE_STRING);
//            JSONObject json=null;
//            try {
//                json=new JSONObject(str);
//                System.out.println("str:"+json.getString("title"));
//                System.out.println("str:"+json.getString("content"));
//                Toast.makeText(context,intent.getStringExtra(PushConstants.EXTRA_PUSH_MESSAGE_STRING),Toast.LENGTH_SHORT).show();
//                //{"content":"这是测试内容","title":"标题测试"}
//                Utils.tz(context,json.getString("title"),json.getString("content"),json.getString("url"));
//            } catch (JSONException e) {
//                e.printStackTrace();
//            }
//        }
    }

}