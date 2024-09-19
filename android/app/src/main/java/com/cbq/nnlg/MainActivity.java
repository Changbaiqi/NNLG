package com.cbq.nnlg;

import android.Manifest;
import android.content.pm.PackageManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import com.eclipsesource.v8.V8;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements LocationListener, SensorEventListener {

    static LocationManager locationManager = null;
    static SensorManager sensorManager = null;
    static double publicLongitude = 0.0;
    static double publicLatitude = 0.0;
    static double publicAltitude = 0.0;
    static double publicAccuracy = 0.0;
    static double publicSensor = 0.0;


    @Override
    public void onLocationChanged(@NonNull Location location) {
//        System.out.println("当前经度："+location.getLongitude());
//        System.out.println("当前纬度："+location.getLatitude());
//        System.out.println("当前海拔："+location.getAltitude()+"米");
//        System.out.println("精度："+location.getAccuracy());
        MainActivity.publicLongitude = location.getLongitude();
        MainActivity.publicLatitude = location.getLatitude();
        MainActivity.publicAltitude = location.getAltitude();
        MainActivity.publicAccuracy = location.getAccuracy();
    }

    @Override
    public void onLocationChanged(@NonNull List<Location> locations) {
        LocationListener.super.onLocationChanged(locations);
    }

    @Override
    public void onFlushComplete(int requestCode) {
        LocationListener.super.onFlushComplete(requestCode);
    }

    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {
        LocationListener.super.onStatusChanged(provider, status, extras);
    }

    @Override
    public void onProviderEnabled(@NonNull String provider) {
        LocationListener.super.onProviderEnabled(provider);
    }

    @Override
    public void onProviderDisabled(@NonNull String provider) {
        LocationListener.super.onProviderDisabled(provider);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

//        //获取定位服务
//        locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
//        //获取压力传感器服务
//        sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
//        Sensor mPresssure = sensorManager.getDefaultSensor(Sensor.TYPE_PRESSURE);//获取气压硬件对象

//        //申请定位权限
//        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED &&
//                ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
//            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION}, 1);
//
//        }
//        //进行定位数据监听操作
//        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 2000, 0.5f, this);
//        //用于dart和Java间的调用
//        MethodChannel methodChannel_Location = new MethodChannel(flutterEngine.getDartExecutor(), "LocationInfo");
//        methodChannel_Location.setMethodCallHandler((@NonNull MethodCall call, @NonNull MethodChannel.Result result) -> {
//            result.success("{\"longitude\":" + MainActivity.publicLongitude + ",\"latitude\":" + MainActivity.publicLatitude + ",\"altitude\":" + MainActivity.publicAltitude + ",\"accuracy\":" + MainActivity.publicAccuracy + ",\"sensor\":" + MainActivity.publicSensor + "}");
//        });


//        //气压传感器
//        if (mPresssure != null) {
//            sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
//            sensorManager.registerListener(this,mPresssure,SensorManager.SENSOR_DELAY_NORMAL);
//        }


//        MethodChannel methodChannel = new MethodChannel(flutterEngine.getDartExecutor(),"Login");
//        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
//            @Override
//            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
//                //Log.d("call",call.method);
//                if(call.method!=null){
//                    String usr = call.method.split("--!--")[0];
//                    String pas = call.method.split("--!--")[1];
//                    //Log.i("TAG","测试成功");
//
//                    result.success(encodeNumber(usr,pas));
//                }
//            }
//        });


//        MethodChannel methodChannel_Course = new MethodChannel(flutterEngine.getDartExecutor(),"CoursePOLO");
//        methodChannel_Course.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
//            @Override
//            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
//                //Log.d("call",call.method);
//                if(call.method!=null){
////                    Course course = new Course(call.method);
//                    CourseNew courseNew = new CourseNew(call.method);
//                    result.success(courseNew.getAllJSON());
//
//                }
//            }
//
//
//
//        });


//        MethodChannel methodChannel_Account = new MethodChannel(flutterEngine.getDartExecutor(),"AccountPOLO");
//        methodChannel_Account.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
//            @Override
//            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
//                if(call.method!=null){
//                    Account account = new Account(call.method);
//                    result.success(account.getAllJSON());
//
//                }
//            }
//        });


//        MethodChannel methodChannel_SemesterCourseList = new MethodChannel(flutterEngine.getDartExecutor(),"SemesterCourseListPOLO");
//        methodChannel_SemesterCourseList.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
//            @Override
//            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
//                if(call.method!=null){
//                    SemesterCourseList semesterCourseList = new SemesterCourseList(call.method);
//                    result.success(semesterCourseList.getAllList());
//
//                }
//            }
//        });


    }


    public String encodeNumber(String account, String password) {
        String result = "没有";
        InputStream is = null;   //获取用户名与密码加密的js代码
        try {
            //Log.i("TAG","标记1");
            is = getAssets().open("conwork.js");
        } catch (IOException e) {
            e.printStackTrace();
            Log.i("ERRER", "获取js文件错误");
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
                    + "encodeInp('" + account + "');\n");
            final String encodepwd = runtime.executeStringScript(sb.toString() + "encodeInp('" + password + "');\n");
            runtime.release();
            result = encodename + "%%%" + encodepwd;
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

    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        MainActivity.publicSensor = sensorEvent.values[0];
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) {

    }
}
