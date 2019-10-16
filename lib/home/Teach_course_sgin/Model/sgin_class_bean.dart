
class sgin_class_bean{
  String classname;
  String classperson;
  String classteachname;
  String classteachphone;
  String classteachaccount;

  sgin_class_bean(this.classname, this.classperson, this.classteachname,
      this.classteachphone, this.classteachaccount);

  sgin_class_bean.fromJson(Map<String, dynamic> json)
      : classname = json['classname'],
        classperson = json['classperson'],
        classteachname = json['classteachname'],
        classteachphone = json['classteachphone'],
        classteachaccount = json['classteachaccount'];

  Map<String, dynamic> toJson() =>
      {
        'classname': classname,
        'classperson': classperson,
        'classteachname': classteachname,
        'classteachphone': classteachphone,
        'classteachaccount': classteachaccount
      };
}