package com.cbq.nnlg;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class CourseNew {
    private String courseHTML;
    private List<List<List<CourseForm>>> courFormList;

    public CourseNew(String courseHTML) {
        this.courseHTML = courseHTML;
        courFormList = new ArrayList<>();
        //截取课表部分
        Pattern pattern = Pattern.compile("<table[^>]*?>([\\s\\S]*?)(</table>)");
        Matcher matcher = pattern.matcher(courseHTML);
        String tableString = null;
        while (matcher.find()) {
            String group = matcher.group(1);
            tableString = matcher.group(1);
        }

        //截取tr，一般一共有8份，第一份为星期几的表格，最后一份为备注项，中间的部分全部为第几大节的项
        Pattern trPattern = Pattern.compile("<tr>([\\s\\S]*?)(</tr>)");
        Matcher trMatcher = trPattern.matcher(tableString);
        List<String> trList = new ArrayList<>();
        while (trMatcher.find()) {
            String group = trMatcher.group(1);
            trList.add(group);
        }

        //主截取课程第几大节那一横着的所有部分部分
        Pattern tdPattern = Pattern.compile("class=\"kbcontent\"[^>]*>([\\s\\S]*?)(</div>)");

        List<List<String>> tdCourseList = new ArrayList<>();
        for (int i = 1; i < trList.size() - 1; i++) {
            Matcher tdMatcher = tdPattern.matcher(trList.get(i));
            List<String> tdCourse = new ArrayList<>();
            while (tdMatcher.find()) {
                String group = tdMatcher.group(1);
                tdCourse.add(group);
            }
            tdCourseList.add(tdCourse);
        }
//        System.out.println();

        for (int i = 0; i < tdCourseList.size(); i++) {
            List<List<CourseForm>> formList = new ArrayList<>();
            for (int y = 0; y < tdCourseList.get(i).size(); y++) {
                String tdListStr = tdCourseList.get(i).get(y);
                String[] split = tdListStr.split("------------");
                List<CourseForm> courses = new ArrayList<>();
                for (String s : split) {
                    courses.add(toCourseForm(s));
//                    System.out.println(s);
                }
                formList.add(courses);
            }
            courFormList.add(formList);
        }

    }


    private CourseForm toCourseForm(String courseStr) {
        //如果为空课表
        if (courseStr.length() < 13 && courseStr.contains("&nbsp"))
            return null;
        CourseForm courseForm = new CourseForm();

        //截取课程名称
        //首先去除杂符号
        Pattern pattern = Pattern.compile("-{3,20}<[^b]*br[^>]*>([\\s\\S]*)");
        Matcher matcher = pattern.matcher(courseStr);
        if (matcher.find()) {
            courseStr = matcher.group(1);
        }

        Pattern pat = Pattern.compile("([\\s\\S]*?)<br/>[^>]*?>([\\s\\S]*?)<[\\s\\S]*?'>([\\s\\S]*?)<[\\s\\S]*?'>\\(([0-9]*?)\\)[\\s\\S]*?>([\\s\\S]*?)<[\\s\\S]*?'>([\\s\\S]*?)<");
        Matcher mat = pat.matcher(courseStr);
        if(mat.find()){
//            courseForm.setCourseName(mat.group(1));
//            System.out.println("课程名:"+mat.group(1));
//            System.out.println("老师:"+mat.group(2));
//            System.out.println("班级:"+mat.group(3));
//            System.out.println("人数:"+mat.group(4));
//            System.out.println("课程所在周节:"+mat.group(5));
//            System.out.println("上课地点:"+mat.group(6));
            courseForm.setCourseName(mat.group(1));
            courseForm.setCourseTeacher(mat.group(2));
            courseForm.setCourseWeek(mat.group(5));
            courseForm.setCourseClassRoom(mat.group(6));
        }else{
            Pattern patCourseName = Pattern.compile("([\\s\\S]*?)<br/>");
            Matcher matCourseName = patCourseName.matcher(courseStr);
            if(matCourseName.find()){
                courseForm.setCourseName(matCourseName.group(1));
            }else{
                courseForm.setCourseName("无");
            }

            Pattern patCourseTeacher = Pattern.compile("[\\s\\S]*?'老师'[^>]*?>([\\s\\S]*?)<[\\s\\S]*?");
            Matcher matCourseTeacher = patCourseTeacher.matcher(courseStr);
            if(matCourseTeacher.find()){
                courseForm.setCourseTeacher(matCourseTeacher.group(1));
            }else{
                courseForm.setCourseTeacher("无");
            }
            Pattern patCourseWeek = Pattern.compile("[\\s\\S]*?>\\(([0-9]*?)\\)[\\s\\S]*?>([\\s\\S]*?)<[\\s\\S]*?");
            Matcher matCourseWeek = patCourseWeek.matcher(courseStr);
            if(matCourseWeek.find()){
                courseForm.setCourseWeek(matCourseWeek.group(2));
            }else{
                courseForm.setCourseWeek("无");
            }

            Pattern patCourseClassRoom = Pattern.compile("[\\s\\S]*?'上课地点'[^>]*?>([\\s\\S]*?)<[\\s\\S]*?");
            Matcher matCourseClassRoom = patCourseClassRoom.matcher(courseStr);
            if(matCourseClassRoom.find()){
                courseForm.setCourseClassRoom(matCourseClassRoom.group(1));
            }else{
                courseForm.setCourseClassRoom("无");
            }
        }
//        System.out.println(courseStr);
        return courseForm;
    }

    public String getAllJSON(){
        StringBuffer stringBuffer = new StringBuffer();
        stringBuffer.append('[');
        for (int i = 0; i < courFormList.size(); i++) {
            stringBuffer.append('[');
            for (int y = 0; y < courFormList.get(i).size(); y++) {
                stringBuffer.append('[');
                for (int x = 0; x < courFormList.get(i).get(y).size(); x++) {
                    //添加到缓存字符串中
                    CourseForm courseForm = courFormList.get(i).get(y).get(x);
                    if(courseForm==null)
                        continue;
                    stringBuffer.append(courseForm.toJson());
                    if(x+1!=courFormList.get(i).get(y).size())
                        stringBuffer.append(',');
                }
                stringBuffer.append(']');
                if(y+1!=courFormList.get(i).size())
                    stringBuffer.append(',');
            }
            stringBuffer.append("]");
            if(i+1!=courFormList.size())
                stringBuffer.append(',');
        }
        stringBuffer.append("]");
        return stringBuffer.toString();
    }


}
