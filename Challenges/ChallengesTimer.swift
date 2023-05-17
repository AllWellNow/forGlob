//
//  ChalengesTimer.swift
//  IF project
//
//  Created by Misha on 26.01.2023.
//

import UIKit
import JDFlipNumberView
import TinyConstraints

// логика таймера активного испытания, использована obj-c библиотека JDFlipNumberView
struct ChallengesTimer {
    var timer: JDDateCountdownFlipView?
    
    mutating func startTimer(view: UIView, numberOfDays: Int, targetDate: Date) {
        view.backgroundColor = .clear
        
        timer = JDDateCountdownFlipView(dayDigitCount: numberOfDays, imageBundle: JDFlipNumberViewImageBundle(named: "JDFlipNumberView", in: Bundle.main))
        if let timer = timer {
            
            timer.targetDate = targetDate
            timer.animationsEnabled = true
            timer.backgroundColor = .clear
            timer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            timer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.addSubview(timer)
            view.autoresizesSubviews = true
        }
    }
    
    mutating func killTimer() {
        if let timer = timer {
            timer.targetDate = .now
            timer.removeFromSuperview()
        }
    }
    
}
