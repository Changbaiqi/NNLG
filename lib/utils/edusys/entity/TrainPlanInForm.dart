import 'dart:convert';
/// number : "序号"
/// semester : "学期"
/// code : "课程序号"
/// courseName : "课程名称"
/// unit : "开课单位"
/// credit : "学分"
/// creditHour : "学时"
/// evaMode : "考核模式"
/// property : "课程属性"
/// isExam : "是否考核"

TrainPlanInForm trainPlanInFormFromJson(String str) => TrainPlanInForm.fromJson(json.decode(str));
String trainPlanInFormToJson(TrainPlanInForm data) => json.encode(data.toJson());
class TrainPlanInForm {
  TrainPlanInForm({
      this.number, 
      this.semester, 
      this.code, 
      this.courseName, 
      this.unit, 
      this.credit, 
      this.creditHour, 
      this.evaMode, 
      this.property, 
      this.isExam,});

  TrainPlanInForm.fromJson(dynamic json) {
    number = json['number'];
    semester = json['semester'];
    code = json['code'];
    courseName = json['courseName'];
    unit = json['unit'];
    credit = json['credit'];
    creditHour = json['creditHour'];
    evaMode = json['evaMode'];
    property = json['property'];
    isExam = json['isExam'];
  }
  String? number;
  String? semester;
  String? code;
  String? courseName;
  String? unit;
  String? credit;
  String? creditHour;
  String? evaMode;
  String? property;
  String? isExam;
TrainPlanInForm copyWith({  String? number,
  String? semester,
  String? code,
  String? courseName,
  String? unit,
  String? credit,
  String? creditHour,
  String? evaMode,
  String? property,
  String? isExam,
}) => TrainPlanInForm(  number: number ?? this.number,
  semester: semester ?? this.semester,
  code: code ?? this.code,
  courseName: courseName ?? this.courseName,
  unit: unit ?? this.unit,
  credit: credit ?? this.credit,
  creditHour: creditHour ?? this.creditHour,
  evaMode: evaMode ?? this.evaMode,
  property: property ?? this.property,
  isExam: isExam ?? this.isExam,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['number'] = number;
    map['semester'] = semester;
    map['code'] = code;
    map['courseName'] = courseName;
    map['unit'] = unit;
    map['credit'] = credit;
    map['creditHour'] = creditHour;
    map['evaMode'] = evaMode;
    map['property'] = property;
    map['isExam'] = isExam;
    return map;
  }

}