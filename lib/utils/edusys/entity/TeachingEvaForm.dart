import 'dart:convert';
/// number : ""
/// schoolYear : ""
/// evalClass : ""
/// evalBatch : ""
/// evalStartTime : ""
/// evalEndTime : ""
/// evalUrl : ""

TeachingEvaForm teachingEvaFormFromJson(String str) => TeachingEvaForm.fromJson(json.decode(str));
String teachingEvaFormToJson(TeachingEvaForm data) => json.encode(data.toJson());
class TeachingEvaForm {
  TeachingEvaForm({
      String? number, 
      String? schoolYear, 
      String? evalClass, 
      String? evalBatch, 
      String? evalStartTime, 
      String? evalEndTime, 
      String? evalUrl,}){
    _number = number;
    _schoolYear = schoolYear;
    _evalClass = evalClass;
    _evalBatch = evalBatch;
    _evalStartTime = evalStartTime;
    _evalEndTime = evalEndTime;
    _evalUrl = evalUrl;
}

  TeachingEvaForm.fromJson(dynamic json) {
    _number = json['number'];
    _schoolYear = json['schoolYear'];
    _evalClass = json['evalClass'];
    _evalBatch = json['evalBatch'];
    _evalStartTime = json['evalStartTime'];
    _evalEndTime = json['evalEndTime'];
    _evalUrl = json['evalUrl'];
  }
  String? _number;
  String? _schoolYear;
  String? _evalClass;
  String? _evalBatch;
  String? _evalStartTime;
  String? _evalEndTime;
  String? _evalUrl;
TeachingEvaForm copyWith({  String? number,
  String? schoolYear,
  String? evalClass,
  String? evalBatch,
  String? evalStartTime,
  String? evalEndTime,
  String? evalUrl,
}) => TeachingEvaForm(  number: number ?? _number,
  schoolYear: schoolYear ?? _schoolYear,
  evalClass: evalClass ?? _evalClass,
  evalBatch: evalBatch ?? _evalBatch,
  evalStartTime: evalStartTime ?? _evalStartTime,
  evalEndTime: evalEndTime ?? _evalEndTime,
  evalUrl: evalUrl ?? _evalUrl,
);
  String? get number => _number;
  String? get schoolYear => _schoolYear;
  String? get evalClass => _evalClass;
  String? get evalBatch => _evalBatch;
  String? get evalStartTime => _evalStartTime;
  String? get evalEndTime => _evalEndTime;
  String? get evalUrl => _evalUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['number'] = _number;
    map['schoolYear'] = _schoolYear;
    map['evalClass'] = _evalClass;
    map['evalBatch'] = _evalBatch;
    map['evalStartTime'] = _evalStartTime;
    map['evalEndTime'] = _evalEndTime;
    map['evalUrl'] = _evalUrl;
    return map;
  }

}