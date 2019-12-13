package hu.bme.aut.android.util

import android.content.Context
import android.media.RingtoneManager
import androidx.work.Worker
import androidx.work.WorkerParameters


class AudioWorker(val context: Context, workerParams: WorkerParameters) : Worker(context, workerParams) {
        /**
         * This will be called whenever work manager run the work.
         */
        override fun doWork(): Result {
//
            val notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_ALARM)
            val r = RingtoneManager.getRingtone(context, notification)
            r.isLooping= true
            r.play()
            return Result.success()
        }
}