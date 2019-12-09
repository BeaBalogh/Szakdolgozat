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
        if (CountdownTimer.shared.isFinished) {
            dismiss(animated: true, completion: nil)
        }
        else {
            stop()
        }
    }
    @IBAction func rightButtonTapped(_ sender: Any) {
        if (CountdownTimer.shared.isPaused) {
            if(CountdownTimer.shared.isFinished){
                let time = Int(timePicker.countDownDuration)
                updateLabels()
                CountdownTimer.shared.setTime(sec: time )
            }
            start()
        }
        else {
            pause()
        }
    }
    
    //MARK: ViewController overrides
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationService.shared.sendNotification(request: runningRequest())
        NotificationService.shared.sendNotification(request: expiredRequest())
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationService.shared.removeAllDeliveredNotifications()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationService.shared.requestNotificationAuthorization()
        CountdownTimer.shared.updateUI = updateLabels
        updateButtons()
        if(CountdownTimer.shared.isFinished){
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
        CountdownTimer.shared.stop()
        timePicker.isHidden = false
        remainingTimeView.isHidden = true
        updateButtons()
    }
    func pause(){
        CountdownTimer.shared.pause()
        updateButtons()
    }
    func start(){
        timePicker.isHidden = true
        remainingTimeView.isHidden = false
        CountdownTimer.shared.start()
        updateButtons()
        updateLabels()
    }
    func updateButtons(){
        if (!CountdownTimer.shared.isFinished) {
            leftButton.setTitle("Restart", for: .normal)
            rightButton.setTitle("Start", for: .normal)
        }
        if(CountdownTimer.shared.isFinished){
            leftButton.setTitle("Close", for: .normal)
            rightButton.setTitle("Start", for: .normal)
        }
        if(!CountdownTimer.shared.isFinished && !CountdownTimer.shared.isPaused){
            leftButton.setTitle("Restart", for: .normal)
            rightButton.setTitle("Pause", for: .normal)
        }
    }
    func updateLabels() {
        var remainingTime = CountdownTimer.shared.RemainingTime
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
        let expDate = Date.init(timeIntervalSince1970: Date().timeIntervalSince1970 + Double(CountdownTimer.shared.RemainingTime))
        return Calendar.current.dateComponents([.hour, .minute, .second] , from: expDate)
    }
   
   
    //MARK: Notifications
    @objc func pauseWhenBackground(noti: Notification) {
        let shared = UserDefaults.standard
        shared.set(Date(), forKey: "savedTime")
        shared.set(CountdownTimer.shared.RemainingTime, forKey: "savedRemainigTime")
        NotificationService.shared.sendNotification(request: runningRequest())
        NotificationService.shared.sendNotification(request: expiredRequest())
        CountdownTimer.shared.stop()
    }
    
    @objc func willEnterForeground(noti: Notification) {
        var diffHrs = 0
        var diffMins = 0
        var diffSecs = 0
        
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            if let savedTime = UserDefaults.standard.object(forKey: "savedRemainigTime") as? Int {
                CountdownTimer.shared.RemainingTime = savedTime
                (diffHrs, diffMins, diffSecs) = TimerPopUpViewController.getTimeDifference(startDate: savedDate)
                let timeinsec = diffHrs*3600+diffMins*60+diffSecs
                CountdownTimer.shared.RemainingTime = CountdownTimer.shared.RemainingTime - timeinsec
                CountdownTimer.shared.setTime(sec: CountdownTimer.shared.RemainingTime)
                CountdownTimer.shared.start()
            }
        }
    }
    
    private func runningRequest()-> UNNotificationRequest{
        let components = getExpDate()
        let runningNotificationContent = UNMutableNotificationContent()
        runningNotificationContent.title = "Timer is running"
        let time = String(format: "%02d:%02d", arguments: [components.hour ?? 0, components.minute ?? 0])
        runningNotificationContent.body = "Timer will expire at \(time)"
//        runningNotificationContent.badge = NSNumber(value: 1)
        
        let runningTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        return UNNotificationRequest(identifier: "timerRunning", content: runningNotificationContent, trigger: runningTrigger)
    }
    private func expiredRequest()-> UNNotificationRequest{
        let components = getExpDate()
        let expiredNotificationContent = UNMutableNotificationContent()
        expiredNotificationContent.title = "Timer expired!"
        expiredNotificationContent.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "alarm_clock.mp3"))
        let expiredTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        return UNNotificationRequest(identifier: "timerExpired", content: expiredNotificationContent, trigger: expiredTrigger)
    }
}
