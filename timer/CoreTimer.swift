//
//  CircularProgressBarView.swift
//  IF project
//
//  Created by Misha on 26.12.2022.
//

import UIKit

// ядро таймера 
class FastingTimer: UIView {
    
    private let beforeStartDateTimer = BeforeStartDateTimer()
    var delegate: FeastingProgressBarViewDelegate?
    
    let timeLeftShapeLayer = CAShapeLayer()
    let bgShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 0
    var startDate: Date?
    var endTime: Date?
    var timeLabel = UILabel()
    weak var feastTimer: Timer?
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    var currentStrokeFill: Double?
    var infoLabel = UILabel()
    
    var isIntervalFirst: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isIntervalFirst")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isIntervalFirst")
        }
    }
    // рисуем бэкграунд слой круга таймера
    func drawBgShape(view: UIView) {
        let path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX / 1.605, y: view.frame.midY / 1.58), radius: 110, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        bgShapeLayer.path = path.resized(to: view.frame)
        bgShapeLayer.strokeColor = Colors().timerEmptyStrokeColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.shadowPath = UIBezierPath(roundedRect: bgShapeLayer.bounds, cornerRadius: 0).cgPath
        bgShapeLayer.shadowColor = Colors().timerCircleShadowColor
        bgShapeLayer.shadowOffset = CGSize(width: 0, height: 4)
        bgShapeLayer.shadowRadius = 1
        bgShapeLayer.shadowOpacity = 1
        bgShapeLayer.lineWidth = 17
        view.layer.addSublayer(bgShapeLayer)
    }
    
    // рисуем линию для отображения прошедшего времени
    func drawTimeLeftShape(view: UIView, strokeColor: CGColor) {
        let path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX / 1.605, y: view.frame.midY / 1.58), radius: 110, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.path = path.resized(to: view.frame)
        timeLeftShapeLayer.strokeColor = strokeColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        timeLeftShapeLayer.lineWidth = 17
        view.layer.addSublayer(timeLeftShapeLayer)
    }
    // добавляем лейблы
    func addTimeLabel(view: UIView, tView: UIView, iView: UIView, textForInfo: String) {
        timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tView.viewWidth, height: tView.viewHeight))
        timeLabel.textAlignment = .center
        timeLabel.text = timeLeft.time
        timeLabel.font = Fonts().systemFont(ofSize: 36, weight: .regular)
        timeLabel.textColor = Colors().labelBlackColor
        timeLabel.numberOfLines = 1
        timeLabel.minimumScaleFactor = 0.5
        timeLabel.adjustsFontSizeToFitWidth = true
        timeLabel.backgroundColor = .clear
        tView.addSubview(timeLabel)
        infoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: iView.viewWidth, height: iView.viewHeight))
        infoLabel.backgroundColor = .clear
        infoLabel.text = textForInfo
        infoLabel.font = Fonts().systemFont(ofSize: 16, weight: .regular)
        infoLabel.textColor = Colors().grayBody
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 1
        infoLabel.minimumScaleFactor = 0.5
        infoLabel.adjustsFontSizeToFitWidth = true
        iView.addSubview(infoLabel)
    }
    
    // при отсутствии таймера выводим в лейбл информацию
    func configureInfoLabelForNoTimer(hView: UIView, pView: UIView) {
        infoLabel = UILabel(frame: CGRect(x: 0, y: 0, width: hView.viewWidth, height: hView.viewHeight))
        infoLabel.backgroundColor = .clear
        infoLabel.text = "No Timer"
        infoLabel.font = Fonts().systemFont(ofSize: 16, weight: .regular)
        infoLabel.textColor = Colors().grayBody
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 1
        infoLabel.minimumScaleFactor = 0.5
        infoLabel.adjustsFontSizeToFitWidth = true
        hView.addSubview(infoLabel)
        let paragraphLabel = UILabel(frame: CGRect(x: 0, y: 0, width: pView.viewWidth, height: pView.viewHeight))
        paragraphLabel.text = "Set it up"
        paragraphLabel.textAlignment = .center
        paragraphLabel.font = Fonts().systemFont(ofSize: 24, weight: .regular)
        paragraphLabel.textColor = Colors().labelBlackColor
        paragraphLabel.numberOfLines = 1
        paragraphLabel.minimumScaleFactor = 0.5
        paragraphLabel.adjustsFontSizeToFitWidth = true
        pView.addSubview(paragraphLabel)
    }
    
    func noTimer(view: UIView, hView: UIView, pView: UIView) {
        killTimer()
        view.backgroundColor = .clear
        DispatchQueue.main.async { [self] in
            drawBgShape(view: view)
            configureInfoLabelForNoTimer(hView: hView, pView: pView)
        }
    }
    
    func killTimer() {
        feastTimer?.invalidate()
        feastTimer = nil
        timeLeftShapeLayer.removeAllAnimations()
        timeLeftShapeLayer.removeFromSuperlayer()
        bgShapeLayer.removeFromSuperlayer()
        timeLeft = 0
        timeLabel.text = ""
        infoLabel.text = ""
    }
    
   // старт таймера
    func startFeastingTimer(view: UIView, fastStatusView: UIView, fastTimeView: UIView, interval: TimeInterval, textForInfo: String, strokeColor: CGColor) {
        killTimer()
        view.backgroundColor = .clear
        // рисуем UI через GCD
        DispatchQueue.main.async { [self] in
            drawBgShape(view: view)
            drawTimeLeftShape(view: view, strokeColor: strokeColor)
            addTimeLabel(view: view, tView: fastTimeView, iView: fastStatusView, textForInfo: textForInfo)
        }
        
        // достаем стабильное значение интервалов для дальнейшего подсчета 
        let stableToFirstFastInterval = UserDefaults.standard.double(forKey: "stableToFirstFastInterval")
        let stableToLastFastInterval = UserDefaults.standard.double(forKey: "stableToLastFastInterval")
        timeLeft = interval
        
        // считаем интервалы и заполняем цветом линию прогресса
        if isIntervalFirst == true {
            currentStrokeFill = abs(1 - (timeLeft / stableToFirstFastInterval)) 
        } else if isIntervalFirst == false {
            currentStrokeFill = abs(1 - (timeLeft / stableToLastFastInterval))
        }
        
        strokeIt.fromValue = currentStrokeFill
        strokeIt.toValue = 1
        strokeIt.duration = timeLeft
        strokeIt.isRemovedOnCompletion = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            timeLeftShapeLayer.add(strokeIt, forKey: nil)
        }
        
        endTime = Date().addingTimeInterval(timeLeft)
        feastTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateFeastingTime), userInfo: nil, repeats: true)
    }
    
    // функция обновляет часы/минуты/секунды или останавливает таймер и передает инфу делегатам когда timeLeft < 0
    @objc func updateFeastingTime() {
        if timeLeft > 0 {
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = [ .pad ]
            
            let i = timeLeft / 60
            let j = i.truncatingRemainder(dividingBy: 60)
            if Int(j) == 0 {
                formatter.allowedUnits = [.hour, .minute, .second]
            } else {
                formatter.allowedUnits = [.hour, .minute]
            }

            let formattedDuration = formatter.string(from: timeLeft)
            timeLabel.text = formattedDuration
        } else {
            if isIntervalFirst == true {
                killTimer()
                delegate?.addDayToDate()
                delegate?.timerEnded()
            } else {
                killTimer()
                delegate?.timerEnded()
            }
        }
    }
}

    //MARK: - Protocols

protocol FeastingProgressBarViewDelegate: AnyObject {
    func timerEnded()
    func addDayToDate()
}
