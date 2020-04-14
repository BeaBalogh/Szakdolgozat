package hu.bme.aut.android.ui.activity

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.DialogInterface
import android.content.Intent
import android.content.IntentFilter
import android.os.Bundle
import android.os.CountDownTimer
import android.view.Menu
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.widget.Toolbar
import androidx.drawerlayout.widget.DrawerLayout
import androidx.navigation.findNavController
import androidx.navigation.ui.AppBarConfiguration
import androidx.navigation.ui.navigateUp
import androidx.navigation.ui.setupActionBarWithNavController
import androidx.navigation.ui.setupWithNavController
import com.bumptech.glide.Glide
import com.google.android.material.navigation.NavigationView
import com.google.firebase.firestore.FirebaseFirestore
import hu.bme.aut.android.R
import hu.bme.aut.android.ui.fragment.SetTimerFragment
import hu.bme.aut.android.reciver.TimerExpiredReceiver
import hu.bme.aut.android.util.NotificationUtil
import hu.bme.aut.android.util.PrefUtil
import kotlinx.android.synthetic.main.app_bar_main.*
import java.util.*
import android.net.ConnectivityManager
import android.view.MenuItem
import androidx.lifecycle.ViewModelProviders
import androidx.room.Room
import hu.bme.aut.android.dataManager.DataManager
import hu.bme.aut.android.dataManager.database.RecipeDatabase
import hu.bme.aut.android.ui.fragment.SharedRecipeViewModel
import hu.bme.aut.android.entities.User
import hu.bme.aut.android.dataManager.network.RecipeService
import hu.bme.aut.android.reciver.ConnectivityReceiver


class MainActivity : BaseActivity(), SetTimerFragment.OnClickListener,
    ConnectivityReceiver.ConnectivityReceiverListener {

    private val viewModel by lazy {
        ViewModelProviders.of(this).get(SharedRecipeViewModel::class.java)
    }


    private fun isNetworkConnected(): Boolean {
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        return cm.activeNetworkInfo != null && cm.activeNetworkInfo.isConnected
    }

    override fun onNetworkConnectionChanged(isConnected: Boolean) {
        isNetworkAvailable = isConnected
    }

    private var connReciver = ConnectivityReceiver()

    private lateinit var appBarConfiguration: AppBarConfiguration
    private val setTimerFragment = SetTimerFragment()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        DataManager.viewModel = viewModel
        setContentView(R.layout.activity_main)

        val recipeService = RecipeService()
        recipeService.createUser()
        recipeService.getUserData().addOnSuccessListener { document ->
            val user = document.toObject(User::class.java)
            if (user != null)
                viewModel.user = user

        }

        val toolbar: Toolbar = findViewById(R.id.toolbar)
        val drawerLayout: DrawerLayout = findViewById(R.id.drawer_layout)
        val navView: NavigationView = this.findViewById(R.id.nav_view)
        val navController = findNavController(R.id.nav_host_fragment)
        val navHead = navView.getHeaderView(0)
        val fullName: TextView = navHead.findViewById(R.id.fullName)
        val email: TextView = navHead.findViewById(R.id.email)
        val image: ImageView = navHead.findViewById(R.id.imageView)

        setSupportActionBar(toolbar)

        appBarConfiguration = AppBarConfiguration(
            setOf(
                R.id.nav_recipe_list, R.id.nav_favorites_list,
                R.id.nav_myrecipe_list, R.id.nav_cooked_list, R.id.nav_new_recipe
            ), drawerLayout
        )
        setupActionBarWithNavController(navController, appBarConfiguration)
        navView.setupWithNavController(navController)


        fullName.text = this.userName
        email.text = this.userEmail
        Glide.with(this)
            .load(this.userImage)
            .into(image)

        fab.setOnClickListener {
            setTimerFragment.show(supportFragmentManager, "TAG")
        }

        isNetworkAvailable = isNetworkConnected()
        setup()

    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.main, menu)
        return true
    }

    override fun onSupportNavigateUp(): Boolean {
        val navController = findNavController(R.id.nav_host_fragment)
        return navController.navigateUp(appBarConfiguration) || super.onSupportNavigateUp()
    }

    override fun onOptionsItemSelected(item: MenuItem?): Boolean {
        when (item?.itemId) {
            R.id.action_logout -> {
                AlertDialog.Builder(this)
                    .setTitle(getString(R.string.log_out))
                    .setMessage(getString(R.string.log_out_warning))
                    .setPositiveButton(android.R.string.yes) { _, _ -> logout() }
                    .setNegativeButton(android.R.string.no, null)
                    .show()
            }
            else -> super.onOptionsItemSelected(item)
        }
        return super.onOptionsItemSelected(item)
    }

    fun logout() {
        val intent = Intent(this, LoginActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK)
        startActivity(intent)
        this.signOut()
    }

    override fun onPause() {
        super.onPause()
        unregisterReceiver(connReciver)

        if (timerState == TimerState.Running) {
            timer.cancel()
            val wakeUpTime = setAlarm(this, nowSeconds, secondsRemaining)
            NotificationUtil.showTimerRunning(this, wakeUpTime)
        } else if (timerState == TimerState.Paused) {
            NotificationUtil.showTimerPaused(this)
        }
        PrefUtil.setSecondsRemaining(secondsRemaining, this)
        PrefUtil.setTimerState(timerState, this)
    }

    override fun onResume() {
        super.onResume()
        DataManager.viewModel = viewModel
        registerReceiver(
            connReciver,
            IntentFilter(ConnectivityManager.CONNECTIVITY_ACTION)
        )
        ConnectivityReceiver.connectivityReceiverListener = this

        setTimerFragment.listener = this

        initTimer()
        removeAlarm(this)

        NotificationUtil.hideTimerNotification(this)
    }

    private fun setup() {
        val db = FirebaseFirestore.getInstance()
//        val settings = FirebaseFirestoreSettings.Builder()
//            .setPersistenceEnabled(true)
//            .setCacheSizeBytes(FirebaseFirestoreSettings.CACHE_SIZE_UNLIMITED)
//            .build()
//        db.firestoreSettings = settings

        DataManager.db =
            Room.databaseBuilder(this, RecipeDatabase::class.java, "recipes")
                .build()


    }

    //Timer functions
    private var timerState = TimerState.Finished
    private var secondsRemaining: Long = 0
    private lateinit var timer: CountDownTimer

    enum class TimerState {
        Paused, Running, Finished
    }

    private fun initTimer() {
        timerState = PrefUtil.getTimerState(this)

        secondsRemaining = if (timerState == TimerState.Running || timerState == TimerState.Paused)
            PrefUtil.getSecondsRemaining(this)
        else
            secondsRemaining


        if (timerState == TimerState.Running || timerState == TimerState.Paused) {
            setTimerFragment.updateRemainingTime(secondsRemaining, timerState)
        }

        val alarmSetTime = PrefUtil.getAlarmSetTime(this)
        if (alarmSetTime > 0)
            secondsRemaining -= nowSeconds - alarmSetTime

        if (timerState == TimerState.Running)
            startTimer()
    }

    private fun onTimerFinished() {
        timerState = TimerState.Finished
        setTimerFragment.updateRemainingTime(secondsRemaining, timerState)
        val alertDialogBuilder = AlertDialog.Builder(this)
        alertDialogBuilder.setTitle("Timer expired!")
            .setMessage("Click stop to exit!")
            .setCancelable(false)
            .setPositiveButton("Stop") { dialog: DialogInterface, _: Int ->
                dialog.cancel()
            }
            .create()
            .show()

    }

    private fun startTimer() {
        timerState = TimerState.Running

        timer = object : CountDownTimer(secondsRemaining * 1000, 1000) {
            override fun onFinish() = onTimerFinished()

            override fun onTick(millisUntilFinished: Long) {
                secondsRemaining = millisUntilFinished / 1000
                setTimerFragment.updateRemainingTime(secondsRemaining, timerState)
            }
        }.start()
    }

    override fun timerStop() {
        timer.cancel()
        timerState = TimerState.Finished

    }

    override fun timerStart(sec: Long) {
        secondsRemaining = sec
        startTimer()
    }

    override fun timerPause() {
        timer.cancel()
        timerState = TimerState.Paused
    }

    override fun timerResume() {
        startTimer()
    }

    companion object {
        fun setAlarm(context: Context, nowSeconds: Long, secondsRemaining: Long): Long {
            val wakeUpTime = (nowSeconds + secondsRemaining) * 1000
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(context, TimerExpiredReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, 0)
            alarmManager.setExact(AlarmManager.RTC_WAKEUP, wakeUpTime, pendingIntent)
            PrefUtil.setAlarmSetTime(nowSeconds, context)
            return wakeUpTime
        }

        fun removeAlarm(context: Context) {
            val intent = Intent(context, TimerExpiredReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, 0)
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            alarmManager.cancel(pendingIntent)
            PrefUtil.setAlarmSetTime(0, context)
        }

        val nowSeconds: Long
            get() = Calendar.getInstance().timeInMillis / 1000

        var isNetworkAvailable = false
    }
}




