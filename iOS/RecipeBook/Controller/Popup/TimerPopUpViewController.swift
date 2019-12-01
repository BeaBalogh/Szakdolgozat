//
//  TimerPopUpViewController.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 24..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import UIKit
import UserNotifications

class TimerPopUpViewController: UIViewController {
    
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var remainingTimeView: UIStackView!

    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    //MARK: Actions
    @IBAction func CloseTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func leftButtonTapped(_ sender: Any) {
        if (CountdownTimer.timer.isFinished) {
            dismiss(animated: true, completion: nil)
        }
        else {
            stop()
        }
    }
    @IBAction func rightButtonTapped(_ sender: Any) {
        if (CountdownTimer.timer.isPaused) {
            if(CountdownTimer.timer.isFinished){
                let time = Int(timePicker.countDownDuration)
                updateLabels()
                CountdownTimer.timer.setTime(sec: time )
            }
            start()
        }
        else {
            pause()
        }
    }
    
    //MARK: ViewController overrides
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationHelper.notiHelper.sendNotification(request: runningRequest())
        NotificationHelper.notiHelper.sendNotification(request: expiredRequest())
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationHelper.notiHelper.removeAllDeliveredNotifications()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationHelper.notiHelper.requestNotificationAuthorization()
        CountdownTimer.timer.updateUI = updateLabels
        updateButtons()
        if(CountdownTimer.timer.isFinished){
            timePicker.isHidden = false
            remainingTimeView.isHidden = true
        }
        else{
            timePicker.isHidden = true
            remainingTimeView.isHidden = false
        }
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK: Timer functions
    func stop(){
        CountdownTimer.timer.stop()
        timePicker.isHidden = false
        remainingTimeView.isHidden = true
        updateButtons()
    }
    func pause(){
        CountdownTimer.timer.pause()
        updateButtons()
    }
    func start(){
        timePicker.isHidden = true
        remainingTimeView.isHidden = false
        CountdownTimer.timer.start()
        updateButtons()
        updateLabels()
    }
    func updateButtons(){
        if (!CountdownTimer.timer.isFinished) {
            leftButton.setTitle("Restart", for: .normal)
            rightButton.setTitle("Start", for: .normal)
        }
        if(CountdownTimer.timer.isFinished){
            leftButton.setTitle("Close", for: .normal)
            rightButton.setTitle("Start", for: .normal)
        }
        if(!CountdownTimer.timer.isFinished && !CountdownTimer.timer.isPaused){
            leftButton.setTitle("Restart", for: .normal)
            rightButton.setTitle("Pause", for: .normal)
        }
    }
    func updateLabels() {
        var remainingTime = CountdownTimer.timer.RemainingTime
        if(remainingTime == 0){
            stop()
        }
        let hrs = remainingTime/3600
        if(hrs>0){
            remainingTime -= hrs*3600
        }
        let min = remainingTime/60
        if(min>0){
            remainingTime -= min*60
        }
        hourLabel.text = String(format: "%02d", hrs)
        minLabel.text = String(format: "%02d", min)
        secLabel.text = String(format: "%02d", remainingTime)
    }
    
    //MARK: Dates
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }

    private func getExpDate()-> DateComponents {
        let expDate = Date.init(timeIntervalSince1970: Date().timeIntervalSince1970 + Double(CountdownTimer.timer.RemainingTime))
        return Calendar.current.dateComponents([.hour, .minute, .second] , from: expDate)
    }
   
   
    //MARK: Notifications
    @objc func pauseWhenBackground(noti: Notification) {
        let shared = UserDefaults.standard
        shared.set(Date(), forKey: "savedTime")
        shared.set(CountdownTimer.timer.RemainingTime, forKey: "savedRemainigTime")
        NotificationHelper.notiHelper.sendNotification(request: runningRequest())
        NotificationHelper.notiHelper.sendNotification(request: expiredRequest())
        CountdownTimer.timer.stop()
    }
    
    @objc func willEnterForeground(noti: Notification) {
        var diffHrs = 0
        var diffMins = 0
        var diffSecs = 0
        
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            if let savedTime = UserDefaults.standard.object(forKey: "savedRemainigTime") as? Int {
                CountdownTimer.timer.RemainingTime = savedTime
                (diffHrs, diffMins, diffSecs) = TimerPopUpViewController.getTimeDifference(startDate: savedDate)
                let timeinsec = diffHrs*3600+diffMins*60+diffSecs
                CountdownTimer.timer.RemainingTime = CountdownTimer.timer.RemainingTime - timeinsec
                CountdownTimer.timer.setTime(sec: CountdownTimer.timer.RemainingTime)
                CountdownTimer.timer.start()
            }
        }
    }
    
    private func runningRequest()-> UNNotificationRequest{
        let components = getExpDate()
        let runningNotificationContent = UNMutableNotificationContent()
        runningNotificationContent.title = "Timer is running"
        runningNotificationContent.body = "Timer will expire at \(components.hour ?? 0):\(components.minute ?? 0)"
//        runningNotificationContent.badge = NSNumber(value: 1)
        
        let runningTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        return UNNotificationRequest(identifier: "timerRunning", content: runningNotificationContent, trigger: runningTrigger)
    }
    private func expiredRequest()-> UNNotificationRequest{
        let components = getExpDate()
        let expiredNotificationContent = UNMutableNotificationContent()
        expiredNotificationContent.title = "Timer is running"
        expiredNotificationContent.body = "Timer will expire at \(components.hour ?? 0):\(components.minute ?? 0)"
        expiredNotificationContent.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "alarm_clock.mp3"))
//        expiredNotificationContent.
//        expiredNotificationContent.badge = NSNumber(value: 1)
        
        let expiredTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        return UNNotificationRequest(identifier: "timerExpired", content: expiredNotificationContent, trigger: expiredTrigger)
    }
}
