package com.cbq.nnlg.homewidget;

import android.annotation.SuppressLint;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

@SuppressLint("NewApi")
public class HomeWidgetExampleProvider extends AppWidgetProvider {


    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        if (AppWidgetManager.ACTION_APPWIDGET_ENABLED.equals(action)) {
            this.onEnabled(context);
        }
        else if (AppWidgetManager.ACTION_APPWIDGET_DISABLED.equals(action)) {
            this.onDisabled(context);
        }
        if (intent.hasCategory(Intent.CATEGORY_ALTERNATIVE)) {
//            Uri data = intent.getData();
//            int buttonId = Integer.parseInt(data.getSchemeSpecificPart());
//            switch (buttonId) {
//                case R.id.widget_layout:
//                    Intent intent = new Intent(context, RemotePlayerActivity.class);
//                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//                    context.startActivity(goIntent);
//                    RemoteViews remoteView = new RemoteViews(context.getPackageName(),R.layout.app_widget_layout);
//                    //将按钮与点击事件绑定
//                    remoteView.setOnClickPendingIntent(R.id.widget_layout,getPendingIntent(context, R.id.widget_layout));
//                    break;
//            }
        }
        super.onReceive(context, intent);
    }

    @Override
    public void onEnabled(Context context) {
//        super.onEnabled(context);
//        Toast.makeText(context,"添加成功",Toast.LENGTH_SHORT).show();
        Log.d("NNLGAppWidget", "onEnabled: 添加小组件成功");
    }

    /**
     *
     * @param context   The {@link android.content.Context Context} in which this receiver is
     *                  running.
     * @param appWidgetManager A {@link AppWidgetManager} object you can call {@link
     *                  AppWidgetManager#updateAppWidget} on.
     * @param appWidgetIds The appWidgetIds for which an update is needed.  Note that this
     *                  may be all of the AppWidget instances for this provider, or just
     *                  a subset of them.
     *
     */
    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
//        super.onUpdate(context, appWidgetManager, appWidgetIds);
        Log.d("NNLGAppWidget", "onUpdate: 触发组件更新");
    }

    /**
     * 删除组件触发
     * @param context   The {@link android.content.Context Context} in which this receiver is
     *                  running.
     * @param appWidgetIds The appWidgetIds that have been deleted from their host.
     *
     */
    @Override
    public void onDeleted(Context context, int[] appWidgetIds) {
//        super.onDeleted(context, appWidgetIds);
        Log.d("NNLGAppWidget", "onDeleted: 触发组件删除");
    }
}
