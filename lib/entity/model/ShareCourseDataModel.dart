
///Request
class ShareCourseDataModel {
  int code;
  Data data;
  String message;

  ShareCourseDataModel({
    required this.code,
    required this.data,
    required this.message,
  });

  ShareCourseDataModel copyWith({
    int? code,
    Data? data,
    String? message,
  }) =>
      ShareCourseDataModel(
        code: code ?? this.code,
        data: data ?? this.data,
        message: message ?? this.message,
      );
}

class Data {
  List<List<List<List<String>>>> courseList;

  Data({
    required this.courseList,
  });

  Data copyWith({
    List<List<List<List<String>>>>? courseList,
  }) =>
      Data(
        courseList: courseList ?? this.courseList,
      );
}