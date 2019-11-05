package hu.bme.aut.android.ui.fragment

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import android.widget.NumberPicker
import android.widget.TextView
import androidx.core.view.isVisible
import androidx.fragment.app.DialogFragment
import hu.bme.aut.android.R
import hu.bme.aut.android.ui.activity.MainActivity
import java.text.SimpleDateFormat
import java.util.*

class SetTimerFragment : DialogFragment() {
    companion object {
        private const val TAG = "SetTimerFragment"
    }

    private lateinit var remainingHour: TextView
    private lateinit var remainingMin: TextView
    private lateinit var remainingSec: TextView
    private lateinit var hourPicker: NumberPicker
    private lateinit var minPicker: NumberPicker
    private lateinit var secPicker: NumberPicker
    private lateinit var startButton: Button
    private lateinit var cancelButton: Button
    private lateinit var resetButton: Button
    private lateinit var pauseButton: Button
    private lateinit var layoutSetTimer: LinearLayout
    private var layoutRemaining: LinearLayout? = null


    var listener: OnClickListener? = null
    private var timerState = MainActivity.TimerState.Finished
    private var secondsRemaining: Long = 0


    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val rootView = inflater.inflate(R.layout.fragment_set_timer, container, false)
        hourPicker = rootView.findViewById(R.id.hourPicker)
        minPicker = rootView.findViewById(R.id.minPicker)
        secPicker = rootView.findViewById(R.id.secPicker)
        layoutSetTimer = rootView.findViewById(R.id.layoutSetTimer)
        layoutRemaining = rootView.findViewById(R.id.layoutRemaining)
        remainingHour = rootView.findViewById(R.id.tvRemainingHours)
        remainingMin = rootView.findViewById(R.id.tvRemainingMins)
        remainingSec = rootView.findViewById(R.id.tvRemainingSec)
        startButton = rootView.findViewById(R.id.btnStartTimer)
        cancelButton = rootView.findViewById(R.id.btnCancelTimer)
        resetButton = rootView.findViewById(R.id.btnResetTimer)
        pauseButton = rootView.findViewById(R.id.btnPauseTimer)

        layoutRemaining?.isVisible = false
        hourPicker.wrapSelectorWheel = true
        minPicker.wrapSelectorWheel = true
        secPicker.wrapSelectorWheel = true
        hourPicker.setFormatter { String.format("%02d", it) }
        minPicker.setFormatter { String.format("%02d", it) }
        secPicker.setFormatter { String.format("%02d", it) }
        hourPicker.minValue = 0
        minPicker.minValue = 0
        secPicker.minValue = 0
        hourPicker.maxValue = 99
        minPicker.maxValue = 59
        secPicker.maxValue = 59

        initButtons()

        if (secondsRemaining > 0) {
            layoutRemaining?.isVisible = true
            layoutSetTimer.isVisible = false
        }
        return rootView
    }

    private fun initButtons() {
        startButton.setOnClickListener {
            val millis =
                (hourPicker.value * 3600 + minPicker.value * 60 + secPicker.value + 1).toLong()
            Log.d(TAG, " " + hourPicker.value + "h" + minPicker.value + "m" + secPicker.value)
            listener?.timerStart(millis)
            layoutRemaining?.isVisible = true
            layoutSetTimer.isVisible = false

        }
        cancelButton.setOnClickListener {
            dialog?.dismiss()
        }
        resetButton.setOnClickListener {
            listener?.timerStop()
            layoutRemaining?.isVisible = false
            layoutSetTimer.isVisible = true
        }
        pauseButton.setOnClickListener {
            when (timerState) {
                MainActivity.TimerState.Running -> {
                    listener?.timerPause()
                    pauseButton.text = "Resume"
                }
                MainActivity.TimerState.Paused -> {
                    listener?.timerResume()
                    pauseButton.text = "Pause"
                }
                else ->
                    dialog?.dismiss()
            }
        }
    }

    fun updateRemainingTime(time: Long, state: MainActivity.TimerState) {
        secondsRemaining = time
        timerState = state
        if (layoutRemaining != null)
            updateUI()
    }

    private fun updateUI() {
        Log.i(TAG, "Countdown remaining: $secondsRemaining")
        var timeInSec = secondsRemaining
        val h = timeInSec / 3600
        if (h > 0)
            timeInSec -= h * 3600

        val m = timeInSec / 60
        if (m > 0)
            timeInSec -= m * 60

        val dateFormat = SimpleDateFormat("m", Locale.getDefault())
        val dateFormat2 = SimpleDateFormat("mm", Locale.getDefault())


        remainingHour.text = (dateFormat2.format(dateFormat.parse(h.toString())))
        remainingMin.text = (dateFormat2.format(dateFormat.parse(m.toString())))
        remainingSec.text = (dateFormat2.format(dateFormat.parse(timeInSec.toString())))

        if (timerState == MainActivity.TimerState.Finished) {
            pauseButton.text = "Close"
        }
    }

    interface OnClickListener {
        fun timerStop()
        fun timerPause()
        fun timerResume()
        fun timerStart(sec: Long)
    }
}
