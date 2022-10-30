package com.cbq.nnlg;

public class CourseForm {

    private String courseName;
    private String courseClassRoom;
    private String courseTeacher;
    private String courseWeek;

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public String getCourseClassRoom() {
        return courseClassRoom;
    }

    public void setCourseClassRoom(String courseClassRoom) {
        this.courseClassRoom = courseClassRoom;
    }

    public String getCourseTeacher() {
        return courseTeacher;
    }

    public void setCourseTeacher(String courseTeacher) {
        this.courseTeacher = courseTeacher;
    }

    public String getCourseWeek() {
        return courseWeek;
    }

    public void setCourseWeek(String courseWeek) {
        this.courseWeek = courseWeek;
    }


    public String toJson(){

        StringBuffer stringBuffer = new StringBuffer();

        stringBuffer.append("{");
        if(courseName!=null)
            stringBuffer.append("\"courseName\":"+"\""+courseName+"\"");
        if(courseClassRoom!=null)
        stringBuffer.append(",\"courseClassRoom\":"+"\""+courseClassRoom+"\"");
        if(courseTeacher!=null)
            stringBuffer.append(",\"courseTeacher\":"+"\""+courseTeacher+"\"");
        if(courseWeek!=null)
            stringBuffer.append(",\"courseWeek\":"+"\""+courseWeek+"\"");
        stringBuffer.append("}");

        return stringBuffer.toString();
    }


}
