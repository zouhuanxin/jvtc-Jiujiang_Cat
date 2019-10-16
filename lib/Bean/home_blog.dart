
import 'package:data_plugin/bmob/table/bmob_object.dart';

class home_blog extends BmobObject{
   String blog_author;
   String blog_name;
   String blog_url;
   String blog_phone;
   String blog_introduce;
   String blog_image;
   String vis;
   var createdAt;
   var objectId;
   home_blog({this.blog_author,this.blog_name,this.blog_url,this.blog_phone,this.blog_introduce,this.blog_image,this.vis,this.createdAt,this.objectId});

   home_blog.fromJson(Map<String, dynamic> json)
       : blog_author = json['blog_author'],
         blog_name = json['blog_name'],
         blog_url = json['blog_url'],
         blog_phone = json['blog_phone'],
         blog_introduce = json['blog_introduce'],
         blog_image = json['blog_image'],
         vis = json['vis'],
         createdAt = json['createdAt'],
         objectId = json['objectId'];

   Map<String, dynamic> toJson() =>
       {
         'blog_author': blog_author,
         'blog_name': blog_name,
         'blog_url': blog_url,
         'blog_phone': blog_phone,
         'blog_introduce': blog_introduce,
         'blog_image': blog_image,
         'vis': vis,
         'createdAt': createdAt,
         'objectId': objectId
       };

  @override
  Map getParams() {
    return toJson();
  }
}