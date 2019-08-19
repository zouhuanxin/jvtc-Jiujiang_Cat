# 九职小猫手

介绍：此程序集成了九江职业技术学院，学工平台，教务系统，图书馆系统等常用功能用户从此可以在移动端在进行日常操作不必繁琐进入网站。并增加了一些常用有趣功能 ，事件倒计时，义务维修，成绩分析，学习周期等等这会让学生在学习时间安排上自我认知上有充分的进步。

### 并为技术交流的同学提供部分教务系统以及图书馆接口 (接口如有设计不合理之处望多指教) 不可用于不正当用途

### apk文件下载连接 http://47.94.255.154:8080/test/downloadfile 你也可以在build\app\outputs\apk\release目录中提取  （文件大小在16M左右,下载可能较慢请耐心等待）

#### 目前程序全部功能仅支持九江技术学院学生使用非本校学生支持处学工平台，教务系统，图书馆系统外的功能使用。

本程序不得用于任何非法用途
如有侵权请联系开发者处理 qq：634448817

以下接口无特别说明均为post请求

* 教务系统接口
  ##### [获取课表接口]http://47.94.255.154:8080/test/kcinfo
  {"rq":"2018-05-02","cookie":"登陆接口获取到的cookie"}
  ##### [教务系统登陆接口] http://47.94.255.154:8080/test/jwlogin
  {"jwusername": "账号","jwpassword":"密码"}
  ##### [成绩查询接口] http://47.94.255.154:8080/test/cjinfo
  {"kksj": "开课时间","kcxz": "课程性质","kcmc": "","xsfs": "显示方式","cookie": "cookie"}
  开课时间:2018-2019-1
  课程性质:(全部)'',(公共课)01,(专业基础课)03,(专业课)04,(公共选修课)06,(其他)07
  显示方式:(显示全部成绩)all,(显示最好成绩)max
* 图书馆接口
   ##### [获取图书馆验证码以及身份接口]http://47.94.255.154:8080/test/tsyzinfo
   调用其他图书馆接口前必须调用此接口获取相应的验证码以及身份，验证码返回格式是base64请自行转码。
   ##### [图书馆登陆接口]http://47.94.255.154:8080/test/tslogininfo
    {"number": "学号","passwd": "密码","captcha": "验证码","cookie": ""}
    此处建议保存验证码后面有相应接口需要用到验证码验证，到时只需要把这里保存的验证码提取出来发送过去即可。
   ##### [图书馆个人信息接口]http://47.94.255.154:8080/test/tsmyinfo
      {"cookie": ""}
   ##### [图书馆借阅历史接口]http://47.94.255.154:8080/test/tshistorylbinfo
   {"para_string":"all","cookie": ""}
   ##### [图书馆当前借阅接口]http://47.94.255.154:8080/test/tsdqjyinfo
     {"cookie": ""}
   ##### [图书馆续借图书接口]http://47.94.255.154:8080/test/tsxjinfo
   {"bar_code": "从相应接口传回来的信息获取","check": "从相应接口传回来的信息获取","captcha": "登陆时保存的验证码","cookie": ""}
   ##### [图书馆取消预约接口]http://47.94.255.154:8080/test/tsqxydinfo
   {"call_no": "从相应接口传回来的信息获取","marc_no": "从相应接口传回来的信息获取","loca": "从相应接口传回来的信息获取","time": "","cookie": ""}
   ##### [图书馆获取账单信息接口]http://47.94.255.154:8080/test/tszmqdinfo
   {"cookie": ""}
   ##### [图书馆获取账单信息接口]http://47.94.255.154:8080/test/tsqxydlbinfo
   {"cookie": ""}
   ##### [图书馆获取账单信息接口]http://47.94.255.154:8080/test/tsjylbinfo
   {"id":"从相应接口传回来的信息获取","cookie": ""}
   
   ps:这里说的相应接口指的是你获取图书信息的接口，里面会有相应参数返回，请自行查看。

![九江小猫手](http://47.94.255.154:8080/zhximage/jzxms1.png "九江小猫手")  
