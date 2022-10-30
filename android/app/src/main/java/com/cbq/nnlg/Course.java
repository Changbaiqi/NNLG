package com.cbq.nnlg;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Course {
    private String courseHTML;
    private String courseTable;

    private StringBuffer courseAllJSON = new StringBuffer();

    private ArrayList<String> tr_data = new ArrayList<>();

    //第一大节
    private ArrayList<String> tr_1 = new ArrayList<>();
    private ArrayList<String> tr_1_json = new ArrayList<>();

    //第二大节
    private ArrayList<String> tr_2 = new ArrayList<>();
    private ArrayList<String> tr_2_json = new ArrayList<>();

    //第三大节
    private ArrayList<String> tr_3 = new ArrayList<>();
    private ArrayList<String> tr_3_json = new ArrayList<>();

    //第四大节
    private ArrayList<String> tr_4 = new ArrayList<>();
    private ArrayList<String> tr_4_json = new ArrayList<>();

    //第五大节
    private ArrayList<String> tr_5 = new ArrayList<>();
    private ArrayList<String> tr_5_json = new ArrayList<>();

    //第六大节
    private ArrayList<String> tr_6 = new ArrayList<>();
    private ArrayList<String> tr_6_json = new ArrayList<>();


    public Course(String courseHTML){
        this.courseHTML = courseHTML;

        Pattern pattern = Pattern.compile("<table id=\"kbtable\"([\\s\\S]+)</table>");
        Matcher matcher = pattern.matcher(courseHTML);

        //System.out.println(matcher.find());

        if(matcher.find()){
            courseTable = matcher.group(1);
        }
        //System.out.println(courseTable);

        toTR();

        toTD();



        toTDJSON();

        toAllJSON();




    }




    private void toTR(){
        int start  = 3; boolean stratLock = false; //是否锁住计数
        int end = 8; boolean endLock = true;//是否锁住计数·
        char res[] = courseTable.toCharArray();
        //<tr>   </tr>
        while (start<courseTable.length() && end < courseTable.length()){

            if(res[start-3]=='<'&&res[start-2]=='t'&&res[start-1]=='r'&&res[start]=='>'&& !stratLock){
                //System.out.println("获取到<tr>");
                stratLock = true;
                endLock = false;

                ++start;
            }
            if(res[end-4]=='<'&&res[end-3]=='/'&&res[end-2]=='t'&&res[end-1]=='r'&&res[end]=='>'&& !endLock){
                //System.out.println("获取到</tr>");
                stratLock = false;
                endLock = true;
                if(start < end) {
                    //System.out.println(courseTable.substring(start - 4, end + 1));
                    tr_data.add(courseTable.substring(start-4,end+1));
                    //System.out.println("\n\n\n\n\n\n");
                }

                ++end;
            }

            if(!stratLock)
                ++start;
            if(!endLock)
                ++end;
        }


    }

    private void toTD(){


        for(int i = 1 ; i < tr_data.size() ; ++i){



            int start  = 3; boolean stratLock = false; //是否锁住计数
            int end = 8; boolean endLock = true;//是否锁住计数·
            char res[] = tr_data.get(i).toCharArray();
            //<tr>   </tr>
            while (start<tr_data.get(i).length() && end < tr_data.get(i).length()){

                if(res[start-3]=='<'&&res[start-2]=='t'&&res[start-1]=='d'&& !stratLock){
                    //System.out.println("获取到<tr>");
                    stratLock = true;
                    endLock = false;

                    ++start;
                }
                if(res[end-4]=='<'&&res[end-3]=='/'&&res[end-2]=='t'&&res[end-1]=='d'&&res[end]=='>'&& !endLock){
                    //System.out.println("获取到</tr>");
                    stratLock = false;
                    endLock = true;
                    if(start < end) {
                        //System.out.println(courseTable.substring(start - 4, end + 1));
                        if(i==1)
                            tr_1.add(tr_data.get(i).substring(start-4,end+1));
                        if(i==2)
                            tr_2.add(tr_data.get(i).substring(start-4,end+1));
                        if(i==3)
                            tr_3.add(tr_data.get(i).substring(start-4,end+1));
                        if(i==4)
                            tr_4.add(tr_data.get(i).substring(start-4,end+1));
                        if(i==5)
                            tr_5.add(tr_data.get(i).substring(start-4,end+1));
                        if(i==6)
                            tr_6.add(tr_data.get(i).substring(start-4,end+1));

                        //System.out.println("\n\n\n\n\n\n");
                    }

                    ++end;
                }

                if(!stratLock)
                    ++start;
                if(!endLock)
                    ++end;
            }



















        }


    }



    private void toTDJSON(){

        //System.out.println("------第一大节");
        for(String course : tr_1) {


            Pattern courseNamePattern = Pattern.compile("\"kbcontent\"[\\s]*>([^<]+)");
            Matcher courseNameMatcher = courseNamePattern.matcher(course);

            Pattern courseClassRoomPattern = Pattern.compile("'上课地点'[\\s]*>([^<]+)");
            Matcher courseClassRoomMatcher = courseClassRoomPattern.matcher(course);

            Pattern courseTeacherPattern = Pattern.compile("'老师'[\\s]*>([^<]+)");
            Matcher courseTeacherMatcher = courseTeacherPattern.matcher(course);

            Pattern courseWeekPattern = Pattern.compile("'周次\\(节次\\)'[\\s]*>([^<]+)");
            Matcher courseWeekMatcher = courseWeekPattern.matcher(course);

            CourseForm courseForm = new CourseForm();
            if (courseNameMatcher.find()) {
                if (!courseNameMatcher.group(1).equals("&nbsp;")) {
                    //System.out.println("课程名称："+courseNameMatcher.group(1));
                    courseForm = new CourseForm();

                    courseForm.setCourseName(courseNameMatcher.group(1));

                    if (courseClassRoomMatcher.find()) {
                        //System.out.println("上课教室："+courseClassRoomMatcher.group(1));
                        courseForm.setCourseClassRoom(courseClassRoomMatcher.group(1));
                    } else {
                        //System.out.println("上课教室："+"未知");
                        courseForm.setCourseClassRoom("未知");
                    }

                    if (courseTeacherMatcher.find()) {
                        //System.out.println("授课老师："+courseTeacherMatcher.group(1));
                        courseForm.setCourseTeacher(courseTeacherMatcher.group(1));
                    } else {
                        //System.out.println("授课老师："+"未知");
                        courseForm.setCourseTeacher("未知");
                    }

                    if (courseWeekMatcher.find()) {
                        //System.out.println("授课周次："+courseWeekMatcher.group(1));
                        courseForm.setCourseWeek(courseWeekMatcher.group(1));
                    } else {
                        //System.out.println("授课周次："+"未知");
                        courseForm.setCourseWeek("未知");
                    }

                    tr_1_json.add(courseForm.toJson());

                } else {
                    //System.out.println("此周无课");
                    tr_1_json.add(courseForm.toJson());
                    //System.out.println("\n\n\n");
                }
            }else {
                //System.out.println("此周无课");
                tr_1_json.add(courseForm.toJson());
                //System.out.println("\n\n\n");
            }

            //System.out.println("\n");
        }


        //System.out.println("\n\n\n");
        //System.out.println("------第二大节");

        for(String course : tr_2) {


            Pattern courseNamePattern = Pattern.compile("\"kbcontent\"[\\s]*>([^<]+)");
            Matcher courseNameMatcher = courseNamePattern.matcher(course);

            Pattern courseClassRoomPattern = Pattern.compile("'上课地点'[\\s]*>([^<]+)");
            Matcher courseClassRoomMatcher = courseClassRoomPattern.matcher(course);

            Pattern courseTeacherPattern = Pattern.compile("'老师'[\\s]*>([^<]+)");
            Matcher courseTeacherMatcher = courseTeacherPattern.matcher(course);

            Pattern courseWeekPattern = Pattern.compile("'周次\\(节次\\)'[\\s]*>([^<]+)");
            Matcher courseWeekMatcher = courseWeekPattern.matcher(course);

            CourseForm courseForm = new CourseForm();
            if (courseNameMatcher.find()) {
                if (!courseNameMatcher.group(1).equals("&nbsp;")) {
                    //System.out.println("课程名称："+courseNameMatcher.group(1));
                    courseForm = new CourseForm();

                    courseForm.setCourseName(courseNameMatcher.group(1));

                    if (courseClassRoomMatcher.find()) {
                        //System.out.println("上课教室："+courseClassRoomMatcher.group(1));
                        courseForm.setCourseClassRoom(courseClassRoomMatcher.group(1));
                    } else {
                        //System.out.println("上课教室："+"未知");
                        courseForm.setCourseClassRoom("未知");
                    }

                    if (courseTeacherMatcher.find()) {
                        //System.out.println("授课老师："+courseTeacherMatcher.group(1));
                        courseForm.setCourseTeacher(courseTeacherMatcher.group(1));
                    } else {
                        //System.out.println("授课老师："+"未知");
                        courseForm.setCourseTeacher("未知");
                    }

                    if (courseWeekMatcher.find()) {
                        //System.out.println("授课周次："+courseWeekMatcher.group(1));
                        courseForm.setCourseWeek(courseWeekMatcher.group(1));
                    } else {
                        //System.out.println("授课周次："+"未知");
                        courseForm.setCourseWeek("未知");
                    }

                    tr_2_json.add(courseForm.toJson());

                } else {
                    //System.out.println("此周无课");
                    tr_2_json.add(courseForm.toJson());
                    //System.out.println("\n\n\n");
                }
            }else {
                //System.out.println("此周无课");
                tr_2_json.add(courseForm.toJson());
                //System.out.println("\n\n\n");
            }

            //System.out.println("\n");
        }

        //System.out.println("\n\n\n");
        //System.out.println("------第三大节");
        for(String course : tr_3) {


            Pattern courseNamePattern = Pattern.compile("\"kbcontent\"[\\s]*>([^<]+)");
            Matcher courseNameMatcher = courseNamePattern.matcher(course);

            Pattern courseClassRoomPattern = Pattern.compile("'上课地点'[\\s]*>([^<]+)");
            Matcher courseClassRoomMatcher = courseClassRoomPattern.matcher(course);

            Pattern courseTeacherPattern = Pattern.compile("'老师'[\\s]*>([^<]+)");
            Matcher courseTeacherMatcher = courseTeacherPattern.matcher(course);

            Pattern courseWeekPattern = Pattern.compile("'周次\\(节次\\)'[\\s]*>([^<]+)");
            Matcher courseWeekMatcher = courseWeekPattern.matcher(course);

            CourseForm courseForm = new CourseForm();
            if (courseNameMatcher.find()) {
                if (!courseNameMatcher.group(1).equals("&nbsp;")) {
                    //System.out.println("课程名称："+courseNameMatcher.group(1));
                    courseForm = new CourseForm();

                    courseForm.setCourseName(courseNameMatcher.group(1));

                    if (courseClassRoomMatcher.find()) {
                        //System.out.println("上课教室："+courseClassRoomMatcher.group(1));
                        courseForm.setCourseClassRoom(courseClassRoomMatcher.group(1));
                    } else {
                        //System.out.println("上课教室："+"未知");
                        courseForm.setCourseClassRoom("未知");
                    }

                    if (courseTeacherMatcher.find()) {
                        //System.out.println("授课老师："+courseTeacherMatcher.group(1));
                        courseForm.setCourseTeacher(courseTeacherMatcher.group(1));
                    } else {
                        //System.out.println("授课老师："+"未知");
                        courseForm.setCourseTeacher("未知");
                    }

                    if (courseWeekMatcher.find()) {
                        //System.out.println("授课周次："+courseWeekMatcher.group(1));
                        courseForm.setCourseWeek(courseWeekMatcher.group(1));
                    } else {
                        //System.out.println("授课周次："+"未知");
                        courseForm.setCourseWeek("未知");
                    }

                    tr_3_json.add(courseForm.toJson());

                } else {
                    //System.out.println("此周无课");
                    tr_3_json.add(courseForm.toJson());
                    //System.out.println("\n\n\n");
                }
            }else {
                //System.out.println("此周无课");
                tr_3_json.add(courseForm.toJson());
                //System.out.println("\n\n\n");
            }

            //System.out.println("\n");
        }

        //System.out.println("\n\n\n");
        //System.out.println("------第四大节");
        for(String course : tr_4) {


            Pattern courseNamePattern = Pattern.compile("\"kbcontent\"[\\s]*>([^<]+)");
            Matcher courseNameMatcher = courseNamePattern.matcher(course);

            Pattern courseClassRoomPattern = Pattern.compile("'上课地点'[\\s]*>([^<]+)");
            Matcher courseClassRoomMatcher = courseClassRoomPattern.matcher(course);

            Pattern courseTeacherPattern = Pattern.compile("'老师'[\\s]*>([^<]+)");
            Matcher courseTeacherMatcher = courseTeacherPattern.matcher(course);

            Pattern courseWeekPattern = Pattern.compile("'周次\\(节次\\)'[\\s]*>([^<]+)");
            Matcher courseWeekMatcher = courseWeekPattern.matcher(course);

            CourseForm courseForm = new CourseForm();
            if (courseNameMatcher.find()) {
                if (!courseNameMatcher.group(1).equals("&nbsp;")) {
                    //System.out.println("课程名称："+courseNameMatcher.group(1));
                    courseForm = new CourseForm();

                    courseForm.setCourseName(courseNameMatcher.group(1));

                    if (courseClassRoomMatcher.find()) {
                        //System.out.println("上课教室："+courseClassRoomMatcher.group(1));
                        courseForm.setCourseClassRoom(courseClassRoomMatcher.group(1));
                    } else {
                        //System.out.println("上课教室："+"未知");
                        courseForm.setCourseClassRoom("未知");
                    }

                    if (courseTeacherMatcher.find()) {
                        //System.out.println("授课老师："+courseTeacherMatcher.group(1));
                        courseForm.setCourseTeacher(courseTeacherMatcher.group(1));
                    } else {
                        //System.out.println("授课老师："+"未知");
                        courseForm.setCourseTeacher("未知");
                    }

                    if (courseWeekMatcher.find()) {
                        //System.out.println("授课周次："+courseWeekMatcher.group(1));
                        courseForm.setCourseWeek(courseWeekMatcher.group(1));
                    } else {
                        //System.out.println("授课周次："+"未知");
                        courseForm.setCourseWeek("未知");
                    }

                    tr_4_json.add(courseForm.toJson());

                } else {
                    //System.out.println("此周无课");
                    tr_4_json.add(courseForm.toJson());
                    //System.out.println("\n\n\n");
                }
            }else {
                //System.out.println("此周无课");
                tr_4_json.add(courseForm.toJson());
                //System.out.println("\n\n\n");
            }

            //System.out.println("\n");
        }

        //System.out.println("\n\n\n");
        //System.out.println("------第五大节");
        for(String course : tr_5) {


            Pattern courseNamePattern = Pattern.compile("\"kbcontent\"[\\s]*>([^<]+)");
            Matcher courseNameMatcher = courseNamePattern.matcher(course);

            Pattern courseClassRoomPattern = Pattern.compile("'上课地点'[\\s]*>([^<]+)");
            Matcher courseClassRoomMatcher = courseClassRoomPattern.matcher(course);

            Pattern courseTeacherPattern = Pattern.compile("'老师'[\\s]*>([^<]+)");
            Matcher courseTeacherMatcher = courseTeacherPattern.matcher(course);

            Pattern courseWeekPattern = Pattern.compile("'周次\\(节次\\)'[\\s]*>([^<]+)");
            Matcher courseWeekMatcher = courseWeekPattern.matcher(course);

            CourseForm courseForm = new CourseForm();
            if (courseNameMatcher.find()) {
                if (!courseNameMatcher.group(1).equals("&nbsp;")) {
                    //System.out.println("课程名称："+courseNameMatcher.group(1));
                    courseForm = new CourseForm();

                    courseForm.setCourseName(courseNameMatcher.group(1));

                    if (courseClassRoomMatcher.find()) {
                        //System.out.println("上课教室："+courseClassRoomMatcher.group(1));
                        courseForm.setCourseClassRoom(courseClassRoomMatcher.group(1));
                    } else {
                        //System.out.println("上课教室："+"未知");
                        courseForm.setCourseClassRoom("未知");
                    }

                    if (courseTeacherMatcher.find()) {
                        //System.out.println("授课老师："+courseTeacherMatcher.group(1));
                        courseForm.setCourseTeacher(courseTeacherMatcher.group(1));
                    } else {
                        //System.out.println("授课老师："+"未知");
                        courseForm.setCourseTeacher("未知");
                    }

                    if (courseWeekMatcher.find()) {
                        //System.out.println("授课周次："+courseWeekMatcher.group(1));
                        courseForm.setCourseWeek(courseWeekMatcher.group(1));
                    } else {
                        //System.out.println("授课周次："+"未知");
                        courseForm.setCourseWeek("未知");
                    }

                    tr_5_json.add(courseForm.toJson());

                } else {
                    //System.out.println("此周无课");
                    tr_5_json.add(courseForm.toJson());
                    //System.out.println("\n\n\n");
                }
            }else {
                //System.out.println("此周无课");
                tr_5_json.add(courseForm.toJson());
                //System.out.println("\n\n\n");
            }

            //System.out.println("\n");
        }

        //System.out.println("\n\n\n");
        //System.out.println("------第六大节");
        for(String course : tr_6) {

            Pattern courseNamePattern = Pattern.compile("\"kbcontent\"[\\s]*>([^<]+)");
            Matcher courseNameMatcher = courseNamePattern.matcher(course);

            Pattern courseClassRoomPattern = Pattern.compile("'上课地点'[\\s]*>([^<]+)");
            Matcher courseClassRoomMatcher = courseClassRoomPattern.matcher(course);

            Pattern courseTeacherPattern = Pattern.compile("'老师'[\\s]*>([^<]+)");
            Matcher courseTeacherMatcher = courseTeacherPattern.matcher(course);

            Pattern courseWeekPattern = Pattern.compile("'周次\\(节次\\)'[\\s]*>([^<]+)");
            Matcher courseWeekMatcher = courseWeekPattern.matcher(course);

            CourseForm courseForm = new CourseForm();
            if (courseNameMatcher.find()) {
                if (!courseNameMatcher.group(1).equals("&nbsp;")) {
                    //System.out.println("课程名称："+courseNameMatcher.group(1));
                    courseForm = new CourseForm();

                    courseForm.setCourseName(courseNameMatcher.group(1));

                    if (courseClassRoomMatcher.find()) {
                        //System.out.println("上课教室："+courseClassRoomMatcher.group(1));
                        courseForm.setCourseClassRoom(courseClassRoomMatcher.group(1));
                    } else {
                        //System.out.println("上课教室："+"未知");
                        courseForm.setCourseClassRoom("未知");
                    }

                    if (courseTeacherMatcher.find()) {
                        //System.out.println("授课老师："+courseTeacherMatcher.group(1));
                        courseForm.setCourseTeacher(courseTeacherMatcher.group(1));
                    } else {
                        //System.out.println("授课老师："+"未知");
                        courseForm.setCourseTeacher("未知");
                    }

                    if (courseWeekMatcher.find()) {
                        //System.out.println("授课周次："+courseWeekMatcher.group(1));
                        courseForm.setCourseWeek(courseWeekMatcher.group(1));
                    } else {
                        //System.out.println("授课周次："+"未知");
                        courseForm.setCourseWeek("未知");
                    }

                    tr_6_json.add(courseForm.toJson());

                } else {
                    //System.out.println("此周无课");
                    tr_6_json.add(courseForm.toJson());
                    //System.out.println("\n\n\n");
                }
            }else {
                //System.out.println("此周无课");
                tr_6_json.add(courseForm.toJson());
                //System.out.println("\n\n\n");
            }

            //System.out.println("\n");
        }

        //System.out.println(tr_6_json);


    }


    private void toAllJSON(){
        courseAllJSON.append("[");

        //第一大节
        courseAllJSON.append("[");
        for(int i = 0 ; i < tr_1_json.size() ; ++i){
            courseAllJSON.append(tr_1_json.get(i));
            if(i!=tr_1_json.size()-1)
                courseAllJSON.append(",");
        }
        courseAllJSON.append("]");
        courseAllJSON.append(",");

        //第二大节
        courseAllJSON.append("[");
        for(int i = 0 ; i < tr_2_json.size() ; ++i){
            courseAllJSON.append(tr_2_json.get(i));
            if(i!=tr_2_json.size()-1)
                courseAllJSON.append(",");
        }
        courseAllJSON.append("]");
        courseAllJSON.append(",");

        //第三大节
        courseAllJSON.append("[");
        for(int i = 0 ; i < tr_3_json.size() ; ++i){
            courseAllJSON.append(tr_3_json.get(i));
            if(i!=tr_3_json.size()-1)
                courseAllJSON.append(",");
        }
        courseAllJSON.append("]");
        courseAllJSON.append(",");


        //第四大节
        courseAllJSON.append("[");
        for(int i = 0 ; i < tr_4_json.size() ; ++i){
            courseAllJSON.append(tr_4_json.get(i));
            if(i!=tr_4_json.size()-1)
                courseAllJSON.append(",");
        }
        courseAllJSON.append("]");
        courseAllJSON.append(",");


        //第五大节
        courseAllJSON.append("[");
        for(int i = 0 ; i < tr_5_json.size() ; ++i){
            courseAllJSON.append(tr_5_json.get(i));
            if(i!=tr_5_json.size()-1)
                courseAllJSON.append(",");
        }
        courseAllJSON.append("]");
        courseAllJSON.append(",");

        //第六大节
        courseAllJSON.append("[");
        for(int i = 0 ; i < tr_6_json.size() ; ++i){
            courseAllJSON.append(tr_6_json.get(i));
            if(i!=tr_6_json.size()-1)
                courseAllJSON.append(",");
        }
        courseAllJSON.append("]");



        courseAllJSON.append("]");

    }


    public String getAllJSON(){
        return courseAllJSON.toString();
    }


}
