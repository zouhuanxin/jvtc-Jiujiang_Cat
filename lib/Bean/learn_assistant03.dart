
class learn_assistant03{
   String sum;
   String starttime;
   String endtime;
   learn_assistant03({this.sum,this.starttime,this.endtime});

   learn_assistant03.fromJson(Map<String, dynamic> json)
       : sum = json['sum'],
         starttime = json['starttime'],
         endtime = json['endtime'];

   Map<String, dynamic> toJson() =>
       {
         'sum': sum,
         'starttime': starttime,
         'endtime': endtime,
       };
}