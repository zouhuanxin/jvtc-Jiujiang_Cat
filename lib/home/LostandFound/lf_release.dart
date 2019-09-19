import 'package:flutter/material.dart';
import 'package:flutter_app01/Utils/Record_Text.dart';
import 'package:flutter_app01/index/navigation_icon_view.dart';

import 'lf_releasea.dart';
import 'lf_releaseb.dart';

//失物招领

class lf_release extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => lf_release_State();
}

class lf_release_State extends State<lf_release> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          '失物招领-发布                                       ',
          textAlign: TextAlign.left,
          style: TextStyle(
              color: Color(int.parse(color2)),
              fontWeight: FontWeight.w800,
              fontSize: 17),
        ),
        bottom: new TabBar(
          indicatorColor:  Color(int.parse(color2)),
          labelColor: Color(int.parse(color2)),
          tabs: <Widget>[
            new Tab(
              icon: new Icon(Icons.send),
              text: '拾取物品',
            ),
            new Tab(
              icon: new Icon(Icons.search),
              text: '遗失物品',
            ),
          ],
          controller: _tabController,
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(color: Color(int.parse(color2))),
        backgroundColor: Color(int.parse(color1)),
        centerTitle: true,
        actions: <Widget>[new Container()],
      ),
      body:new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new Center(child: new lf_releaseb()),
          new Center(child: new lf_releasea()),
        ],
      ),
    );
  }
}
