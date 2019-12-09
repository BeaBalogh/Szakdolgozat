//
//  Stopwatch.swift
//  RecipeBook
//
//  Created by Beatrix Balogh on 2019. 11. 28..
//  Copyright © 2019. Beatrix Balogh. All rights reserved.
//

import Foundation
import AVFoundation

class CountdownTimer {
    static let shared = CountdownTimer()

    private var remainingTime = 10
    private var audioPlayer = AVAudioPlayer()
    private var timer: Timer?

    var isPaused: Bool {
        return timer==nil
    }
    var RemainingTime: Int {
        set { remainingTime = newValue }
        get { return remainingTime }
    }
    var isFinished: Bool {
        return remainingTime==0
    }
    typealias UpdateUI = ()  -> Void
    var updateUI : UpdateUI? = nil
    //MARK: Initialization
    
    private init(){
        if remainingTime<=0{
            deinitTimer()
            NotificationService.shared.removeAllDeliveredNotifications()
        }
        do
        {
            let audioPath = Bundle.main.path(forResource: "alarm_clock", ofType: ".mp3")
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: audioPath!))
        }
        catch
        {
            //ERROR
        }
    }
    
    deinit {
        print("⏱ Stopwatch successfully deinited")
        deinitTimer()
    }
    
    func start() {
        initTimer()
    }
    func setTime(sec: Int){
        remainingTime = sec
    }
    func dismissAlarm(){
        audioPlayer.stop()
    }
    func stop() {
        deinitTimer()
        remainingTime = 0
    }
    func pause() {
        audioPlayer.stop()
        deinitTimer()
    }
    private func initTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1,
                                     repeats: true, block: counter)
    }
    
    private func deinitTimer() {
        timer?.invalidate()
        timer = nil
        remainingTime=0
    }
    
    func counter(_ :Timer){
        remainingTime -= 1
        if (remainingTime == 0)
        {
            stop()
            AlertHelper.showTimerAlert(title: "Timer expired!⏰", message: nil)
            audioPlayer.play()
        }
        if remainingTime<0{
            deinitTimer()
        }
        print(remainingTime)
        if(updateUI != nil) {
            updateUI!()
        }
    }
}
