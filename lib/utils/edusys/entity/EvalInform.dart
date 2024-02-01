import 'dart:convert';
/// number : ""
/// courseNumber : ""
/// courseName : ""
/// teacher : ""
/// evalType : ""
/// overallScore : ""
/// isRated : ""
/// isSubmit : ""
/// url : ""

EvalInform evalInformFromJson(String str) => EvalInform.fromJson(json.decode(str));
String evalInformToJson(EvalInform data) => json.encode(data.toJson());
class EvalInform {
  EvalInform({
      String? number, 
      String? courseNumber, 
      String? courseName, 
      String? teacher, 
      String? evalType, 
      String? overallScore, 
      String? isRated, 
      String? isSubmit, 
      String? url,}){
    _number = number;
    _courseNumber = courseNumber;
    _courseName = courseName;
    _teacher = teacher;
    _evalType = evalType;
    _overallScore = overallScore;
    _isRated = isRated;
    _isSubmit = isSubmit;
    _url = url;
}

  EvalInform.fromJson(dynamic json) {
    _number = json['number'];
    _courseNumber = json['courseNumber'];
    _courseName = json['courseName'];
    _teacher = json['teacher'];
    _evalType = json['evalType'];
    _overallScore = json['overallScore'];
    _isRated = json['isRated'];
    _isSubmit = json['isSubmit'];
    _url = json['url'];
  }
  String? _number;
  String? _courseNumber;
  String? _courseName;
  String? _teacher;
  String? _evalType;
  String? _overallScore;
  String? _isRated;
  String? _isSubmit;
  String? _url;
EvalInform copyWith({  String? number,
  String? courseNumber,
  String? courseName,
  String? teacher,
  String? evalType,
  String? overallScore,
  String? isRated,
  String? isSubmit,
  String? url,
}) => EvalInform(  number: number ?? _number,
  courseNumber: courseNumber ?? _courseNumber,
  courseName: courseName ?? _courseName,
  teacher: teacher ?? _teacher,
  evalType: evalType ?? _evalType,
  overallScore: overallScore ?? _overallScore,
  isRated: isRated ?? _isRated,
  isSubmit: isSubmit ?? _isSubmit,
  url: url ?? _url,
);
  String? get number => _number;
  String? get courseNumber => _courseNumber;
  String? get courseName => _courseName;
  String? get teacher => _teacher;
  String? get evalType => _evalType;
  String? get overallScore => _overallScore;
  String? get isRated => _isRated;
  String? get isSubmit => _isSubmit;
  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['number'] = _number;
    map['courseNumber'] = _courseNumber;
    map['courseName'] = _courseName;
    map['teacher'] = _teacher;
    map['evalType'] = _evalType;
    map['overallScore'] = _overallScore;
    map['isRated'] = _isRated;
    map['isSubmit'] = _isSubmit;
    map['url'] = _url;
    return map;
  }

}