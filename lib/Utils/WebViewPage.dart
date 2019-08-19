import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app01/Utils/Record_Text.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({Key key, this.url, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return Widget_WebView_State();
  }

}

class Widget_WebView_State extends State<WebViewPage>
    with SingleTickerProviderStateMixin {
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();
  var title = " 加载中 ";
  bool _isLoading = true;
  //获取h5页面标题
  Future<String> getWebTitle() async {
    String script = 'window.document.title';
    var title = await
    flutterWebviewPlugin.evalJavascript(script);
    setState(() {
      this.title = title;
      print('####################   $title');
    });
  }

  //获取h5页面标题
  Future<String> getWebTitle2({String url}) async {
    var client = http.Client();
    client
        .get(url)
        .then(
            (response) {
          String title = RegExp(
              r"<[t|T]{1}[i|I]{1}[t|T]{1}[l|L]{1}[e|E]{1}(\s.*)?>([^<]*)</[t|T]{1}[i|I]{1}[t|T]{1}[l|L]{1}[e|E]{1}>")
              .stringMatch(response.body);
          if (title != null) {
            title =
                title.substring(title.indexOf('>') + 1, title.lastIndexOf("<"));
          } else {
            title = "";
          }
          print("####################  " + title);
        })
        .catchError(
            (error) {
          print(error);
        })
        .whenComplete(client.close,);
  }


  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onStateChanged.listen((
        WebViewStateChanged webViewState) async {
      switch (webViewState.type) {
        case WebViewState.finishLoad:
          handleJs();

          getWebTitle();

          break;
        case WebViewState.shouldStart:
          break;
        case WebViewState.startLoad:

          break;
        case WebViewState.abortLoad:
          break;
      }
    });
  }

  _loading () {
    return _isLoading == true ? Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ) : Text('');
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      //默认加载地址
      appBar: new AppBar(
        title: new Text('${title.substring(1,title.toString().length-1)!=''?title.substring(1,title.toString().length-1):widget.title}                                       ',
          textAlign:TextAlign.left,style: TextStyle(color: Color(int.parse(color2)),fontWeight: FontWeight.w800,fontSize: 17),),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(int.parse(color2))),
        backgroundColor: Color(int.parse(color1)),
        centerTitle: true,
        actions: <Widget>[
          new Container()
        ],
      ),
      withJavascript:true,
      withZoom:true,
      withLocalStorage:true,
    );
  }

  @override
  void dispose() {
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  void handleJs() {
    flutterWebviewPlugin.evalJavascript(
        "abc(${title}')")
        .then((result) {
    });
  }
}
