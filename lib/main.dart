import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_app01/index/index.dart';
import 'package:data_plugin/bmob/table/bmob_user.dart';
import 'package:data_plugin/bmob/bmob.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'SplashPage.dart';

void main() => {
    runApp(MyApp())
};

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Bmob.initMasterKey("931aa07205e9cddf2cd85458d029af79",
        "9e1c0370c480f4c47053d155b6d3b251", "349f886cee56a52891715a8a8b1960e0");

    return new MaterialApp(
      title: '九职小猫手',
      debugShowCheckedModeBanner: false,
      home: new SplashPage(),     // 指定去加载 Index页面。
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        //此处
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      locale: Locale('zh'),
    );
  }
}