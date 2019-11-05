package hu.bme.aut.android.reciver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import hu.bme.aut.android.ui.activity.MainActivity
import hu.bme.aut.android.util.NotificationUtil
import hu.bme.aut.android.util.PrefUtil


class TimerExpiredReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {

        NotificationUtil.showTimerExpired(context)

        PrefUtil.setTimerState(MainActivity.TimerState.Finished, context)
        PrefUtil.setAlarmSetTime(0, context)
//
//
//        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
//        val alltasks = activityManager.getRunningTasks(1)
//
//        var isTop = false
//
//        for (aTask: ActivityManager.RunningTaskInfo in alltasks) {
//
//            if (aTask.topActivity.className == context.packageName + ".activity.MainActivity"
//            ) {
//                isTop = true
//                Log.d("RECIEVER", aTask.topActivity.className)
//                Log.d("RECIEVER", context.packageName)
//            }
//        }
//
//        if (!isTop) {
//            val launch_intent = Intent(Intent.ACTION_MAIN)
//            launch_intent.action = "TIMER_EXPIRED"
//            launch_intent.component =
//                (ComponentName(context.packageName, context.packageName + ".activity.MainActivity"))
//            launch_intent.flags =
//                Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT or Intent.FLAG_ACTIVITY_NEW_TASK
//            launch_intent.addCategory(Intent.CATEGORY_LAUNCHER)
//            context.startActivity(launch_intent)
//        }
    }
}