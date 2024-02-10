import 'dart:convert';
/// data : {"shareAccountList":[{"college":"信息工程学院","major":"网络工程","studentName":"谢林宏","userAccount":"22300242","shareAccount":"21060231","studentClass":"2203网络"},{"college":"信息工程学院","major":"通信工程","studentName":"肖金元","userAccount":"23090402","shareAccount":"21060231","studentClass":"2304通信"},{"college":"信息工程学院","major":"计算机科学与技术","studentName":"周培旭","userAccount":"23060323","shareAccount":"21060231","studentClass":"2303计算机"}]}
/// message : "获取成功"
/// code : 200

ShareCourseAccountModel shareCourseAccountModelFromJson(String str) => ShareCourseAccountModel.fromJson(json.decode(str));
String shareCourseAccountModelToJson(ShareCourseAccountModel data) => json.encode(data.toJson());
class ShareCourseAccountModel {
  ShareCourseAccountModel({
      this.data, 
      this.message, 
      this.code,});

  ShareCourseAccountModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
    code = json['code'];
  }
  Data? data;
  String? message;
  num? code;
ShareCourseAccountModel copyWith({  Data? data,
  String? message,
  num? code,
}) => ShareCourseAccountModel(  data: data ?? this.data,
  message: message ?? this.message,
  code: code ?? this.code,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['message'] = message;
    map['code'] = code;
    return map;
  }

}

/// shareAccountList : [{"college":"信息工程学院","major":"网络工程","studentName":"谢林宏","userAccount":"22300242","shareAccount":"21060231","studentClass":"2203网络"},{"college":"信息工程学院","major":"通信工程","studentName":"肖金元","userAccount":"23090402","shareAccount":"21060231","studentClass":"2304通信"},{"college":"信息工程学院","major":"计算机科学与技术","studentName":"周培旭","userAccount":"23060323","shareAccount":"21060231","studentClass":"2303计算机"}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.shareAccountList,});

  Data.fromJson(dynamic json) {
    if (json['shareAccountList'] != null) {
      shareAccountList = [];
      json['shareAccountList'].forEach((v) {
        shareAccountList?.add(ShareAccountList.fromJson(v));
      });
    }
  }
  List<ShareAccountList>? shareAccountList;
Data copyWith({  List<ShareAccountList>? shareAccountList,
}) => Data(  shareAccountList: shareAccountList ?? this.shareAccountList,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (shareAccountList != null) {
      map['shareAccountList'] = shareAccountList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// college : "信息工程学院"
/// major : "网络工程"
/// studentName : "谢林宏"
/// userAccount : "22300242"
/// shareAccount : "21060231"
/// studentClass : "2203网络"

ShareAccountList shareAccountListFromJson(String str) => ShareAccountList.fromJson(json.decode(str));
String shareAccountListToJson(ShareAccountList data) => json.encode(data.toJson());
class ShareAccountList {
  ShareAccountList({
      this.college, 
      this.major, 
      this.studentName, 
      this.userAccount, 
      this.shareAccount, 
      this.studentClass,});

  ShareAccountList.fromJson(dynamic json) {
    college = json['college'];
    major = json['major'];
    studentName = json['studentName'];
    userAccount = json['userAccount'];
    shareAccount = json['shareAccount'];
    studentClass = json['studentClass'];
  }
  String? college;
  String? major;
  String? studentName;
  String? userAccount;
  String? shareAccount;
  String? studentClass;
ShareAccountList copyWith({  String? college,
  String? major,
  String? studentName,
  String? userAccount,
  String? shareAccount,
  String? studentClass,
}) => ShareAccountList(  college: college ?? this.college,
  major: major ?? this.major,
  studentName: studentName ?? this.studentName,
  userAccount: userAccount ?? this.userAccount,
  shareAccount: shareAccount ?? this.shareAccount,
  studentClass: studentClass ?? this.studentClass,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['college'] = college;
    map['major'] = major;
    map['studentName'] = studentName;
    map['userAccount'] = userAccount;
    map['shareAccount'] = shareAccount;
    map['studentClass'] = studentClass;
    return map;
  }

}