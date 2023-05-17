//
//  ChallengesCollectionViewCell.swift
//  IF project
//
//  Created by Misha on 22.01.2023.
//

import UIKit

class ChallengesCollectionViewCellViewModel {
    var challengeLabelText: String
    var image: UIImage
    var id: Int
    var isActive: Bool
    var isDone: Bool
    
    init(challengeLabelText: String, image: UIImage, id: Int, isActive: Bool, isDone: Bool) {
        self.challengeLabelText = challengeLabelText
        self.image = image
        self.id = id
        self.isActive = isActive
        self.isDone = isDone
    }
}

class ChallengesCollectionViewCell: UICollectionViewCell {
    private var challenge1Period: Date? {
        get {
            UserDefaults.standard.object(forKey: "challenge1Period") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "challenge1Period")
        }
    }
    private var challenge2Period: Date? {
        get {
            UserDefaults.standard.object(forKey: "challenge2Period") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "challenge2Period")
        }
    }
    private var challenge3Period: Date? {
        get {
            UserDefaults.standard.object(forKey: "challenge3Period") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "challenge3Period")
        }
    }
    private var challenge4Period: Date? {
        get {
            UserDefaults.standard.object(forKey: "challenge4Period") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "challenge4Period")
        }
    }
    private var challenge5Period: Date? {
        get {
            UserDefaults.standard.object(forKey: "challenge5Period") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "challenge5Period")
        }
    }
    private var challenge6Period: Date? {
        get {
            UserDefaults.standard.object(forKey: "challenge6Period") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "challenge6Period")
        }
    }
    private var isChallenge1Active: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge1Active")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge1Active")
        }
    }
    private var isChallenge2Active: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge2Active")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge2Active")
        }
    }
    private var isChallenge3Active: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge3Active")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge3Active")
        }
    }
    private var isChallenge4Active: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge4Active")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge4Active")
        }
    }
    private var isChallenge5Active: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge5Active")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge5Active")
        }
    }
    private var isChallenge6Active: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge6Active")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge6Active")
        }
    }
    private var isChallenge1Done: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge1Done")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge1Done")
        }
    }
    private var isChallenge2Done: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge2Done")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge2Done")
        }
    }
    private var isChallenge3Done: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge3Done")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge3Done")
        }
    }
    private var isChallenge4Done: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge4Done")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge4Done")
        }
    }
    private var isChallenge5Done: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge5Done")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge5Done")
        }
    }
    private var isChallenge6Done: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallenge6Done")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallenge6Done")
        }
    }
    private var activeChallenges: [Int] {
        get {
            UserDefaults.standard.array(forKey: "activeChallenges") as? [Int] ?? []
        } set {
            UserDefaults.standard.set(newValue, forKey: "activeChallenges")
        }
    }
    
    private var challengesTimer = ChallengesTimer()
    
    static let identifier = "ChallengesCollectionViewCell"
    var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = Fonts().systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.backgroundColor = Colors().orange
        label.layer.masksToBounds = true
        label.roundCorners(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 10)
        
        return label
    }()
    var imageView: UIImageView = {
        let iView = UIImageView()
        iView.layer.masksToBounds = true
        iView.roundCorners(corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner], radius: 10)
        iView.contentMode = .scaleAspectFit
        
        return iView
    }()
    var activeLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.73).cgColor
        
        return layer
    }()
    var timerView: UIView = {
        let tView = UIView()
        
        return tView
    }()
    var doneImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.image = K().challengesDoneImage
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(label)
        contentView.addSubview(imageView)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        contentView.layer.shadowColor = (Colors().shadowColor).cgColor
        contentView.layer.shadowRadius = 4
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.label.font = Fonts().systemFont(ofSize: 14, weight: .medium)
        self.label.frame = CGRect(x: 0, y: 0, width: contentView.viewWidth, height: contentView.viewHeight / 5.28)
        self.label.layer.cornerRadius = contentView.layer.cornerRadius
        self.imageView.frame = CGRect(x: label.frame.minX, y: label.frame.maxY, width: contentView.viewWidth, height: contentView.viewHeight / 1.235)
        self.imageView.layer.cornerRadius = contentView.layer.cornerRadius
    }
    
    func configureViewsForActiveChallenge(challengePeriod: Date) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            removeAllSubviewsAndLayers()
            activeLayer.frame = CGRect(x: 0, y: 0, width: imageView.viewWidth, height: imageView.viewHeight)
            activeLayer.backgroundColor = Colors().activeChallengeLayerColor
            timerView.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.midY / 1.9, width: imageView.viewWidth, height: 30)
            
            imageView.addSubview(timerView)
            imageView.layer.addSublayer(activeLayer)
            imageView.bringSubviewToFront(timerView)
        }
        challengesTimer.startTimer(view: timerView, numberOfDays: 2, targetDate: challengePeriod)
    }
    
    func configureViewsForCompletedChallenge() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
            removeAllSubviewsAndLayers()
            activeLayer.frame = CGRect(x: 0, y: 0, width: imageView.viewWidth, height: imageView.viewHeight)
            doneImageView.frame = CGRect(x: imageView.frame.midX / 1.95, y: imageView.frame.midY / 2.9, width: imageView.viewWidth / 2, height:  imageView.viewWidth / 2)
            activeLayer.backgroundColor = Colors().violetLightAsCgColor
            imageView.layer.addSublayer(activeLayer)
            imageView.addSubview(doneImageView)
            imageView.bringSubviewToFront(doneImageView)
        }
    }
    
    func configure(with viewModel: ChallengesCollectionViewCellViewModel) {
        self.label.text = viewModel.challengeLabelText
        self.imageView.image = viewModel.image
        let currentDate = Date.now
        if viewModel.isActive == true {
            if viewModel.id == 1 {
                if let p1 = challenge1Period {
                    if p1 > currentDate {
                        configureViewsForActiveChallenge(challengePeriod: p1)
                    } else {
                        removeAllSubviewsAndLayers()
                        isChallenge1Done = true
                        isChallenge1Active = false
                        viewModel.isDone = true
                        viewModel.isActive = false
                        activeChallenges.removeAll { $0 == viewModel.id }
                        configureViewsForCompletedChallenge()
                    }
                } else {
                    removeAllSubviewsAndLayers()
                    isChallenge1Active = false
                }
            } else if viewModel.id == 2 {
                if let p2 = challenge2Period {
                    if p2 > currentDate {
                        configureViewsForActiveChallenge(challengePeriod: p2)
                    } else {
                        removeAllSubviewsAndLayers()
                        isChallenge2Done = true
                        isChallenge2Active = false
                        viewModel.isDone = true
                        viewModel.isActive = false
                        activeChallenges.removeAll { $0 == viewModel.id }
                        configureViewsForCompletedChallenge()
                    }
                } else {
                    removeAllSubviewsAndLayers()
                    isChallenge2Active = false
                }
            } else if viewModel.id == 3 {
                if let p3 = challenge3Period {
                    if p3 > currentDate {
                        configureViewsForActiveChallenge(challengePeriod: p3)
                    } else {
                        removeAllSubviewsAndLayers()
                        isChallenge3Done = true
                        isChallenge3Active = false
                        viewModel.isDone = true
                        viewModel.isActive = false
                        activeChallenges.removeAll { $0 == viewModel.id }
                        configureViewsForCompletedChallenge()
                    }
                } else {
                    removeAllSubviewsAndLayers()
                    isChallenge3Active = false
                }
            } else if viewModel.id == 4 {
                if let p4 = challenge4Period {
                    if p4 > currentDate {
                        configureViewsForActiveChallenge(challengePeriod: p4)
                    } else {
                        removeAllSubviewsAndLayers()
                        isChallenge4Done = true
                        isChallenge4Active = false
                        viewModel.isDone = true
                        viewModel.isActive = false
                        activeChallenges.removeAll { $0 == viewModel.id }
                        configureViewsForCompletedChallenge()
                    }
                } else {
                    removeAllSubviewsAndLayers()
                    isChallenge4Active = false
                }
            } else if viewModel.id == 5 {
                if let p5 = challenge5Period {
                    if p5 > currentDate {
                        configureViewsForActiveChallenge(challengePeriod: p5)
                    } else {
                        removeAllSubviewsAndLayers()
                        isChallenge5Done = true
                        isChallenge5Active = false
                        viewModel.isDone = true
                        viewModel.isActive = false
                        activeChallenges.removeAll { $0 == viewModel.id }
                        configureViewsForCompletedChallenge()
                    }
                } else {
                    removeAllSubviewsAndLayers()
                    isChallenge5Active = false
                }
            } else if viewModel.id == 6 {
                if let p6 = challenge6Period {
                    if p6 > currentDate {
                        configureViewsForActiveChallenge(challengePeriod: p6)
                    } else {
                        removeAllSubviewsAndLayers()
                        isChallenge6Done = true
                        isChallenge6Active = false
                        viewModel.isDone = true
                        viewModel.isActive = false
                        activeChallenges.removeAll { $0 == viewModel.id }
                        configureViewsForCompletedChallenge()
                    }
                } else {
                    removeAllSubviewsAndLayers()
                    isChallenge6Active = false
                }
            }
        } else if !viewModel.isActive && !viewModel.isDone {
            removeAllSubviewsAndLayers()
        }
        if viewModel.isDone == true {
            if viewModel.id == 1 {
                configureViewsForCompletedChallenge()
            } else if viewModel.id == 2 {
                configureViewsForCompletedChallenge()
            } else if viewModel.id == 3 {
                configureViewsForCompletedChallenge()
            } else if viewModel.id == 4 {
                configureViewsForCompletedChallenge()
            } else if viewModel.id == 5 {
                configureViewsForCompletedChallenge()
            } else if viewModel.id == 6 {
                configureViewsForCompletedChallenge()
            }
        }
    }
    
    func removeAllSubviewsAndLayers() {
        if let sublayers = imageView.layer.sublayers {
            for (subview, layer) in zip(imageView.subviews, sublayers) {
                subview.removeFromSuperview()
                layer.removeFromSuperlayer()
            }
        }
    }
}
