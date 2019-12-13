package hu.bme.aut.android.reciver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.work.WorkManager
import hu.bme.aut.android.AppConstants
import hu.bme.aut.android.ui.activity.MainActivity
import hu.bme.aut.android.util.NotificationUtil
import hu.bme.aut.android.util.PrefUtil
import java.util.*

class TimerNotificationActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            AppConstants.ACTION_STOP -> {
                MainActivity.removeAlarm(context)
                if(PrefUtil.getRequestID(context) != null){
                        WorkManager.getInstance(context).cancelWorkById(UUID.fromString(PrefUtil.getRequestID(context)))
                }
                PrefUtil.setRequestID("", context)
                PrefUtil.setTimerState(MainActivity.TimerState.Finished, context)
                PrefUtil.setSecondsRemaining(0, context)
                NotificationUtil.hideTimerNotification(context)
            }
            AppConstants.ACTION_PAUSE -> {
                var secondsRemaining = PrefUtil.getSecondsRemaining(context)
                val alarmSetTime = PrefUtil.getAlarmSetTime(context)
                val nowSeconds = MainActivity.nowSeconds

                secondsRemaining -= nowSeconds - alarmSetTime
                PrefUtil.setSecondsRemaining(secondsRemaining, context)

                MainActivity.removeAlarm(context)
                PrefUtil.setTimerState(MainActivity.TimerState.Paused, context)
                NotificationUtil.showTimerPaused(context)
            }
            AppConstants.ACTION_RESUME -> {
                val secondsRemaining = PrefUtil.getSecondsRemaining(context)
                val wakeUpTime =
                    MainActivity.setAlarm(context, MainActivity.nowSeconds, secondsRemaining)
                PrefUtil.setTimerState(MainActivity.TimerState.Running, context)
                NotificationUtil.showTimerRunning(context, wakeUpTime)
            }
        }
    }
}