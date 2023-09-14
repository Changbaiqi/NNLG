package com.cbq.nnlg;

import android.os.Handler;
import android.os.Message;
import android.util.Log;

import androidx.annotation.NonNull;

import com.eclipsesource.v8.V8;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {


    


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor(),"Login");
        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                //Log.d("call",call.method);
                if(call.method!=null){
                    String usr = call.method.split("--!--")[0];
                    String pas = call.method.split("--!--")[1];
                    //Log.i("TAG","测试成功");

                    result.success(encodeNumber(usr,pas));
                }
            }
        });


        MethodChannel methodChannel_Course = new MethodChannel(flutterEngine.getDartExecutor(),"CoursePOLO");
        methodChannel_Course.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                //Log.d("call",call.method);
                if(call.method!=null){
//                    Course course = new Course(call.method);
                    CourseNew courseNew = new CourseNew(call.method);
                    result.success(courseNew.getAllJSON());

                }
            }



        });


        MethodChannel methodChannel_Account = new MethodChannel(flutterEngine.getDartExecutor(),"AccountPOLO");
        methodChannel_Account.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if(call.method!=null){
                    Account account = new Account(call.method);
                    result.success(account.getAllJSON());

                }
            }
        });




        MethodChannel methodChannel_SemesterCourseList = new MethodChannel(flutterEngine.getDartExecutor(),"SemesterCourseListPOLO");
        methodChannel_SemesterCourseList.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if(call.method!=null){
                    SemesterCourseList semesterCourseList = new SemesterCourseList(call.method);
                    result.success(semesterCourseList.getAllList());

                }
            }
        });




    }



    public String encodeNumber(String account,String password)
    {
        String result="没有";
        InputStream is= null;   //获取用户名与密码加密的js代码
        try {
            //Log.i("TAG","标记1");
            is = getAssets().open("conwork.js");
        } catch (IOException e) {
            e.printStackTrace();
            Log.i("ERRER","获取js文件错误");
        }
        //Log.i("TAG","标记2");
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        StringBuilder sb = new StringBuilder();
        String line = null;
        try {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
            V8 runtime = V8.createV8Runtime();      //使用J2V8运行js代码并将编码结果返回
            final String encodename = runtime.executeStringScript(sb.toString()
                    + "encodeInp('"+account+"');\n");
            final String encodepwd=runtime.executeStringScript(sb.toString()+"encodeInp('"+password+"');\n");
            runtime.release();
            result=encodename+"%%%"+encodepwd;
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return result;
    }
}
