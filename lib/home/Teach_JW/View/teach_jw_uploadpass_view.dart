import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/home/Teach_JW/Model/teach_jw_uploadpass_model.dart';
import 'package:flutter_app01/home/Teach_JW/ViewModel/teach_jw_uploadpass_viewmodel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';

class teach_jw_uploadpass_view extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return teach_jw_uploadpass_view_State();
  }
}

class teach_jw_uploadpass_view_State extends State<teach_jw_uploadpass_view> {
  var providers = Providers();

  void _loading() {
    var tjum = teach_jw_uploadpass_model();
    var tjuv = teach_jw_uploadpass_viewmodel(tjum, context);
    providers.provide(Provider<teach_jw_uploadpass_viewmodel>.value(tjuv));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  Widget oldpssword_input() {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.all(5.0),
      child: Provide<teach_jw_uploadpass_viewmodel>(
          builder: (context, child, value) {
        return TextField(
          maxLines: 1,
          obscureText: value.vis1,
          decoration: InputDecoration(
            labelText: '旧密码',
            fillColor: Colors.white,
            filled: dart_model,
            contentPadding:
                EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Color(int.parse(color4)),
                ),
                onPressed: () {
                  value.set_data('vis1', value.vis1);
                }),
          ),
          textAlign: TextAlign.start,
          onChanged: (T) {
            value.set_data('oldpassword', T);
          },
          autofocus: false,
        );
      }),
    );
  }

  Widget password1_input() {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.all(5.0),
      child: Provide<teach_jw_uploadpass_viewmodel>(
          builder: (context, child, value) {
        return TextField(
          maxLines: 1,
          obscureText: value.vis2,
          decoration: InputDecoration(
            labelText: '新密码',
            fillColor: Colors.white,
            filled: dart_model,
            contentPadding:
            EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Color(int.parse(color4)),
                ),
                onPressed: () {
                  value.set_data('vis2', value.vis2);
                }),
          ),
          textAlign: TextAlign.start,
          onChanged: (T) {
            value.set_data('password1', T);
          },
          autofocus: false,
        );
      }),
    );
  }

  Widget password2_input() {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.all(5.0),
      child: Provide<teach_jw_uploadpass_viewmodel>(
          builder: (context, child, value) {
        return TextField(
          maxLines: 1,
          obscureText: value.vis3,
          decoration: InputDecoration(
            labelText: '确认密码',
            fillColor: Colors.white,
            filled: dart_model,
            contentPadding:
            EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(40)),
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.remove_red_eye,
                  color: Color(int.parse(color4)),
                ),
                onPressed: () {
                  value.set_data('vis3', value.vis3);
                }),
          ),
          textAlign: TextAlign.start,
          onChanged: (T) {
            value.set_data('password2', T);
          },
          autofocus: false,
        );
      }),
    );
  }

  Align buildSubmitButton() {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: Provide<teach_jw_uploadpass_viewmodel>(
            builder: (context, child, value) {
          return RaisedButton(
            child: Text(
              '修改',
              style: TextStyle(color: Color(int.parse(color1))),
            ),
            color: Color(int.parse(color2)),
            onPressed: () {
              value.uploadpss();
            },
            shape: StadiumBorder(side: BorderSide()),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ProviderNode(
      providers: providers,
      child: Scaffold(
        appBar: new AppBar(
          title: new Text(
            '教师教务密码修改                                       ',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Color(int.parse(color2)),
                fontWeight: FontWeight.w800,
                fontSize: 17),
          ),
          elevation: 0.0,
          iconTheme: IconThemeData(color: Color(int.parse(color2))),
          backgroundColor: Color(int.parse(color1)),
          centerTitle: true,
          actions: <Widget>[new Container()],
        ),
        body: new Container(
            decoration: BoxDecoration(color: Color(int.parse(color1))),
            child: Provide<teach_jw_uploadpass_viewmodel>(
                builder: (context, child, value) {
              return ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setHeight(50)),
                children: [
                  Text(
                    '   旧密码',
                    style: TextStyle(
                        color: Color(int.parse(color2)),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal),
                  ),
                  oldpssword_input(),
                  Text(
                    '   新密码',
                    style: TextStyle(
                        color: Color(int.parse(color2)),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal),
                  ),
                  password1_input(),
                  Text(
                    '   确认密码',
                    style: TextStyle(
                        color: Color(int.parse(color2)),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal),
                  ),
                  password2_input(),
                  SizedBox(
                    height: 50,
                  ),
                  buildSubmitButton(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              );
            })),
      ),
    );
  }
}
