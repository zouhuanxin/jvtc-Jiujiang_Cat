import 'learn_assistant03.dart';
class learn_assistant02{
   String sum;
   List<learn_assistant03> learn03_list;
   learn_assistant02({this.sum,this.learn03_list});

   learn_assistant02.fromJson(Map<String, dynamic> json)
       : sum = json['sum'],
         learn03_list = json['learn03_list'];

   Map<String, dynamic> toJson() =>
       {
         'sum': sum,
         'learn03_list': learn03_list,
       };
}