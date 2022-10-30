package com.cbq.nnlg;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Account {

    private String accountPersionalInformationHTML;

    private StringBuffer allJson = new StringBuffer();

    public Account(String accountPersionalInformationHTML){
        this.accountPersionalInformationHTML = accountPersionalInformationHTML;
    }




    public String getAccountName(){

        Pattern pattern1 = Pattern.compile("姓名</td>([\\w\\W]+)>性别");
        Matcher matcher1 = pattern1.matcher(accountPersionalInformationHTML);


        if(matcher1.find()){

            Pattern pattern2 = Pattern.compile(">&nbsp;([^<]+)</td>");
            Matcher matcher2 = pattern2.matcher(matcher1.group(1));
            if(matcher2.find()){
                //System.out.println(matcher2.group(1));
                return matcher2.group(1);
            }

        }


        return "";
    }


    public String getAccountMajor(){


        Pattern pattern1 = Pattern.compile(">专业：([\\w\\W]+)>学制");
        Matcher matcher1 = pattern1.matcher(accountPersionalInformationHTML);


        if(matcher1.find()){

            Pattern pattern2 = Pattern.compile("([^<]+)</td>");
            Matcher matcher2 = pattern2.matcher(matcher1.group(1));
            if(matcher2.find()){
                //System.out.println(matcher2.group(1));
                return matcher2.group(1);
            }

        }

        return "";
    }


    public String getAccountID(){


        Pattern pattern1 = Pattern.compile(">学号：([\\w\\W]+)</tr>");
        Matcher matcher1 = pattern1.matcher(accountPersionalInformationHTML);


        if(matcher1.find()){

            Pattern pattern2 = Pattern.compile("([^<]+)</td>");
            Matcher matcher2 = pattern2.matcher(matcher1.group(1));
            if(matcher2.find()){
                //System.out.println(matcher2.group(1));
                return matcher2.group(1);
            }

        }

        return "";
    }

    public String getAccountClass(){


        Pattern pattern1 = Pattern.compile(">班级：([\\w\\W]+)学号：");
        Matcher matcher1 = pattern1.matcher(accountPersionalInformationHTML);


        if(matcher1.find()){

            Pattern pattern2 = Pattern.compile("([^<]+)</td>");
            Matcher matcher2 = pattern2.matcher(matcher1.group(1));
            if(matcher2.find()){
                //System.out.println(matcher2.group(1));
                return matcher2.group(1);
            }

        }

        return "";


    }


    public String getAccountCollege(){


        Pattern pattern1 = Pattern.compile(">院系：([\\w\\W]+)专业");
        Matcher matcher1 = pattern1.matcher(accountPersionalInformationHTML);


        if(matcher1.find()){

            Pattern pattern2 = Pattern.compile("([^<]+)</td>");
            Matcher matcher2 = pattern2.matcher(matcher1.group(1));
            if(matcher2.find()){
                //System.out.println(matcher2.group(1));
                return matcher2.group(1);
            }

        }

        return "";


    }



    public String getAccountLengthOfSchool(){


        Pattern pattern1 = Pattern.compile(">学制：([\\w\\W]+)班级");
        Matcher matcher1 = pattern1.matcher(accountPersionalInformationHTML);


        if(matcher1.find()){

            Pattern pattern2 = Pattern.compile("([^<]+)</td>");
            Matcher matcher2 = pattern2.matcher(matcher1.group(1));
            if(matcher2.find()){
                //System.out.println(matcher2.group(1));
                return matcher2.group(1);
            }

        }

        return "";


    }




    public String getAccountGender(){

        Pattern pattern1 = Pattern.compile("性别</td>([\\w\\W]+)>姓名拼音");
        Matcher matcher1 = pattern1.matcher(accountPersionalInformationHTML);


        if(matcher1.find()){

            Pattern pattern2 = Pattern.compile(">&nbsp;([^<]+)</td>");
            Matcher matcher2 = pattern2.matcher(matcher1.group(1));
            if(matcher2.find()){
                //System.out.println(matcher2.group(1));
                return matcher2.group(1);
            }

        }
        return "";
    }



    public String getAllJSON(){

        String name = getAccountName();
        String major = getAccountMajor();
        String id = getAccountID();
        String gender = getAccountGender();
        String studentClass = getAccountClass();
        String college = getAccountCollege();
        String lengthOfSchool = getAccountLengthOfSchool();

        allJson.append("{");


        allJson.append("\"name\":"+"\""+name+"\"");
        allJson.append(",\"major\":"+"\""+major+"\"");
        allJson.append(",\"id\":"+"\""+id+"\"");
        allJson.append(",\"gender\":"+"\""+gender+"\"");
        allJson.append(",\"studentClass\":"+"\""+studentClass+"\"");
        allJson.append(",\"college\":"+"\""+college+"\"");
        allJson.append(",\"lengthOfSchool\":"+"\""+lengthOfSchool+"\"");

        allJson.append("}");

        return allJson.toString();
    }







}
