# 九职小猫手

（已上架小米应用商店）
本程序分为学生端与教师端。
学生与教师端分别都已集成了九江职业技术学院学工平台 图书系统 以及教务系统的常用功能，后续会逐步增加。
并为教师端专门定制了九江职业技术学院签到功能。
其他一些功能下载app看吧

### 并为技术交流的同学提供部分教务系统以及图书馆接口 (接口如有设计不合理之处望多指教)

### apk文件下载连接 http://dyzuis.cn:8080/test/downloadfile 你也可以在build\app\outputs\apk\release目录中提取  （文件大小在20M左右,下载可能较慢请耐心等待）

#### 目前程序全部功能仅支持九江技术学院学生使用非本校学生支持处学工平台，教务系统，图书馆系统外的功能使用。

本程序不得用于任何非法用途
如有侵权请联系开发者处理 qq：634448817

以下接口无特别说明均为post请求

* 教务系统接口
  ##### [获取课表接口]http://dyzuis.cn:8080/test/kcinfo
  {"rq":"2018-05-02","cookie":"登陆接口获取到的cookie"}
  ##### [教务系统登陆接口] http://dyzuis.cn:8080/test/jwlogin
  {"jwusername": "账号","jwpassword":"密码"}
  ##### [成绩查询接口] http://dyzuis.cn:8080/test/cjinfo
  {"kksj": "开课时间","kcxz": "课程性质","kcmc": "","xsfs": "显示方式","cookie": "cookie"}
  开课时间:2018-2019-1
  课程性质:(全部)'',(公共课)01,(专业基础课)03,(专业课)04,(公共选修课)06,(其他)07
  显示方式:(显示全部成绩)all,(显示最好成绩)max
* 图书馆接口
   ##### [获取图书馆验证码以及身份接口]http://dyzuis.cn:8080/test/tsyzinfo
   调用其他图书馆接口前必须调用此接口获取相应的验证码以及身份，验证码返回格式是base64请自行转码。
   ##### [图书馆登陆接口]http://dyzuis.cn:8080/test/tslogininfo
    {"number": "学号","passwd": "密码","captcha": "验证码","cookie": ""}
    此处建议保存验证码后面有相应接口需要用到验证码验证，到时只需要把这里保存的验证码提取出来发送过去即可。
   ##### [图书馆个人信息接口]http://dyzuis.cn:8080/test/tsmyinfo
      {"cookie": ""}
   ##### [图书馆借阅历史接口]http://dyzuis.cn:8080/test/tshistorylbinfo
   {"para_string":"all","cookie": ""}
   ##### [图书馆当前借阅接口]http://dyzuis.cn:8080/test/tsdqjyinfo
     {"cookie": ""}
   ##### [图书馆续借图书接口]http://dyzuis.cn:8080/test/tsxjinfo
   {"bar_code": "从相应接口传回来的信息获取","check": "从相应接口传回来的信息获取","captcha": "登陆时保存的验证码","cookie": ""}
   ##### [图书馆取消预约接口]http://dyzuis.cn:8080/test/tsqxydinfo
   {"call_no": "从相应接口传回来的信息获取","marc_no": "从相应接口传回来的信息获取","loca": "从相应接口传回来的信息获取","time": "","cookie": ""}
   ##### [图书馆获取账单信息接口]http://dyzuis.cn:8080/test/tszmqdinfo
   {"cookie": ""}
   ##### [图书馆获取账单信息接口]http://dyzuis.cn:8080/test/tsqxydlbinfo
   {"cookie": ""}
   ##### [图书馆获取账单信息接口]http://dyzuis.cn:8080/test/tsjylbinfo
   {"id":"从相应接口传回来的信息获取","cookie": ""}
   
   ps:这里说的相应接口指的是你获取图书信息的接口，里面会有相应参数返回，请自行查看。
   
   ###程序更新历史版本号一览
  
   * 1.0.0 
   * 1.0.1
   * 1.0.2
   * 1.0.3
   * 1.0.4
   * 1.0.5
   * 1.0.6
   ##### 在1.0.x的版本中我们原来采用的uniapp框架 后来由于uniapp选材不适合本系统 本系统希望与原生安卓能有所交互 所以弃用了第一套uniapp框架代码采用了第二套
   （在2.0.x版本中我们针对ui进行了重新设计）
   * 2.0.0
   * 2.0.1
   * 2.0.2
   * 2.0.3
   * 2.0.4
   * 2.0.5
   * 2.0.6
   * 2.0.7
   * 2.0.8
   * 2.0.9
   * 2.1.0
   * 2.1.1
   * 2.1.2
   * 2.1.3
   * 2.1.4
   * 2.1.5
   * 2.1.6
   * 2.1.7
   * 目前最新版本 2.3.4
   ##### 在2.0.x版本中我们采用了flutter框架以便于与原生安卓技术进行交互，程序写到现在还是有很多问题，希望后面能慢慢解决。
   ##### 为什么我们不采用原生安卓技术，原因有如下几点
   * 第一 我们希望我们能学习到更多新技术
   * 第二 我们希望能快速构建漂亮的ui界面 
   * 第三 我们希望能一套代码能尽量的适配ios端
   
