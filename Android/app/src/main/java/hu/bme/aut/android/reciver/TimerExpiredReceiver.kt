package hu.bme.aut.android.reciver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import hu.bme.aut.android.ui.activity.MainActivity
import hu.bme.aut.android.util.AudioWorker
import hu.bme.aut.android.util.NotificationUtil
import hu.bme.aut.android.util.PrefUtil


class TimerExpiredReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {

        NotificationUtil.showTimerExpired(context)
        val request = OneTimeWorkRequest.Builder(AudioWorker::class.java)
            .build()
        WorkManager.getInstance(context).enqueue(request)
        PrefUtil.setRequestID(request.id.toString(), context)
        PrefUtil.setTimerState(MainActivity.TimerState.Finished, context)
        PrefUtil.setAlarmSetTime(0, context)
    }
}