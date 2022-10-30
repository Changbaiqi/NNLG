package com.cbq.nnlg;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SemesterCourseList {

    private String semesterCourseListHTML;

    private ArrayList<String> courseList = new ArrayList<>();

    private StringBuffer allJSON = new StringBuffer();



    public SemesterCourseList(String semesterCourseListHTML){

        this.semesterCourseListHTML = semesterCourseListHTML;

        getCourseList();
    }


    private void getCourseList(){

        Pattern pattern = Pattern.compile("学年学期：([\\w\\W]+)</select>");
        Matcher matcher = pattern.matcher(semesterCourseListHTML);

        if(matcher.find()){
            //System.out.println(matcher.group(1));

            Pattern pattern1 = Pattern.compile(">([\\s]*)([^<]{9,15})([\\s]*)</option>");
            Matcher matcher1 = pattern1.matcher(matcher.group(1));
            while(matcher1.find()){
                //System.out.println(matcher1.group(2));
                courseList.add(matcher1.group(2));
                //courseList.add()
            }

        }


    }



    public String getAllList(){

        allJSON.append("[");
        for(int i = 0 ; i < courseList.size() ; ++i ){




            allJSON.append("\""+ courseList.get(i) +"\"" );

            if(i!=courseList.size()-1)
                allJSON.append(",");

        }
        allJSON.append("]");

        return allJSON.toString();
    }



}
