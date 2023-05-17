//
//  ViewController.swift
//  IF project
//
//  Created by Misha on 19.12.2022.
//

import UIKit
import DeviceKit
import TinyConstraints
import WaveProgressView
import JDFlipNumberView

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var levelProgressView: UIProgressView!
    @IBOutlet weak var goalProgressView: UIProgressView!
    @IBOutlet weak var editGoalButton: UIButton!
    @IBOutlet weak var currentUserWaterGoalLabel: UILabel!
    @IBOutlet weak var waterProgressView: WaveProgressView!
    @IBOutlet weak var startingWeightLabel: UILabel!
    @IBOutlet weak var goalWeightLabel: UILabel!
    @IBOutlet weak var currentLevelLabel: UILabel!
    @IBOutlet weak var nextLevelLabel: UILabel!
    @IBOutlet weak var timerRectangle: UIView!
    @IBOutlet weak var toReachGoalLabel: UILabel!
    @IBOutlet weak var challengesPageControl: UIPageControl!
    @IBOutlet weak var challengesTableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userInfoRectangle: UIView!
    @IBOutlet weak var challengesRect: UIView!
    @IBOutlet weak var waterTrackerRect: UIView!
    @IBOutlet weak var timerRect: UIView!
    @IBOutlet weak var weightTrackerRect: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var levelDescriptionLabel: UILabel!
    @IBOutlet weak var levelDescriptionIcon: UIImageView!
    @IBOutlet weak var levelInfoView: UIView!
    @IBOutlet weak var levelProgressStackView: UIStackView!
    @IBOutlet weak var weightGoalImageView: UIImageView!
    @IBOutlet weak var timerViewQuestionIcon: UIImageView!
    @IBOutlet weak var timerViewLabel: UILabel!
    @IBOutlet weak var timerViewButton: UIButton!
    @IBOutlet weak var waterTrackerQuestionIcon: UIImageView!
    @IBOutlet weak var waterTrackerLabel: UILabel!
    @IBOutlet weak var addWaterButton: UIButton!
    @IBOutlet weak var waterTrackerEditButton: UIButton!
    @IBOutlet weak var challengesLabel: UILabel!
    @IBOutlet weak var fastingTimeView: UIView!
    @IBOutlet weak var fastingStatusView: UIView!
    
    private var waterTracker = WaterTracker()
    private var weightTracker = WeightTracker()
    private let toPercentage = PercentageFormatter()
    private var levelingLogic = LevelingLogic()
    private let fastingTimer = FastingTimer()
    private let beforeStartDateTimer = BeforeStartDateTimer()
    private let trackerSettings = TrackerSettingsViewController()
    private let notifications = NotificationsCenter()
    private let constants = K()
    private let challengesCollectionViewCell = ChallengesCollectionViewCell()
    private let c = Components()
    
    private var currentUserWaterGoal: String? {
        UserDefaults.standard.string(forKey: "userWaterGoalAsString")
    }
    private var startingUserWeight: String? {
        UserDefaults.standard.string(forKey: "startingWeight")
    }
    private var currentUserWeight: String? {
        UserDefaults.standard.string(forKey: "currentWeight")
    }
    private var currentUserWeightGoal: String? {
        UserDefaults.standard.string(forKey: "goalWeight")
    }
    private var prettyPercent: String? {
        get {
            UserDefaults.standard.string(forKey: "prettyPecent")
        } set {
            UserDefaults.standard.set(newValue, forKey: "prettyPecent")
        }
    }
    private var currentLevel: Int {
        get {
            UserDefaults.standard.integer(forKey: "currentLevel")
        } set {
            UserDefaults.standard.set(newValue, forKey: "currentLevel")
        }
    }
    private var startingDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "startingDate") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "startingDate")
        }
    }
    private var firstFastingHour: Date? {
        get {
            UserDefaults.standard.object(forKey: "firstFastingHour") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "firstFastingHour")
        }
    }
    private var lastFastingHour: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastFastingHour") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "lastFastingHour")
        }
    }
    private var currentDateToStartDateInterval: Int? {
        get {
            UserDefaults.standard.integer(forKey: "currentDateToStartDateInterval")
        } set {
            UserDefaults.standard.set(newValue, forKey: "currentDateToStartDateInterval")
        }
    }
    private var currentDateToFirstFastHourInterval: Int? {
        get {
            UserDefaults.standard.integer(forKey: "currentDateToFirstFastHourInterval")
        } set {
            UserDefaults.standard.set(newValue, forKey: "currentDateToFirstFastHourInterval")
        }
    }
    private var currentDateToLastFastHourInterval: Int? {
        get {
            UserDefaults.standard.integer(forKey: "currentDateToLastFastHourInterval")
        } set {
            UserDefaults.standard.set(newValue, forKey: "currentDateToLastFastHourInterval")
        }
    }
    private var stableToLastFastInterval: Double {
        UserDefaults.standard.double(forKey: "stableToLastFastInterval")
    }
    private var stableToFirstFastInterval: Double {
        UserDefaults.standard.double(forKey: "stableToFirstFastInterval")
    }
    private var fastHoursPassed: Int {
        get {
            UserDefaults.standard.integer(forKey: "fastHoursPassed")
        } set {
            UserDefaults.standard.set(newValue, forKey: "fastHoursPassed")
        }
    }
    private var isIntervalFirst: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isIntervalFirst")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isIntervalFirst")
        }
    }
    private var currentFastStreak: Int {
        get {
            UserDefaults.standard.integer(forKey: "currentFastStreak")
        } set {
            UserDefaults.standard.set(newValue, forKey: "currentFastStreak")
        }
    }
    private var goalFastStreak: Int {
        UserDefaults.standard.integer(forKey: "goalFastStreak")
    }
    private var streakStartDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "streakStartDate") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "streakStartDate")
        }
    }
    private var userUpdatedWeight: String? {
        UserDefaults.standard.string(forKey: "userUpdatedWeight")
    }
    private var wasWeightUpdated: Bool? {
        get {
            UserDefaults.standard.bool(forKey: "wasWeightUpdated")
        } set {
            UserDefaults.standard.set(newValue, forKey: "wasWeightUpdated")
        }
    }
    private var wasGoalReached: Bool? {
        get {
            UserDefaults.standard.bool(forKey: "wasGoalReached")
        } set {
            UserDefaults.standard.set(newValue, forKey: "wasGoalReached")
        }
    }
    private var wasGoalStreakReached: Bool? {
        get {
            UserDefaults.standard.bool(forKey: "wasGoalStreakReached")
        } set {
            UserDefaults.standard.set(newValue, forKey: "wasGoalStreakReached")
        }
    }
    private var needToKillTimerOnHours: Bool? {
        get {
            UserDefaults.standard.bool(forKey: "needToKillTimerOnHours")
        } set {
            UserDefaults.standard.set(newValue, forKey: "needToKillTimerOnHours")
        }
    }
    private var needToKillTimerOnMain: Bool? {
        get {
            UserDefaults.standard.bool(forKey: "needToKillTimerOnMain")
        } set {
            UserDefaults.standard.set(newValue, forKey: "needToKillTimerOnMain")
        }
    }
    private var isOneHourBeforeEatingNotificationGranted: Bool {
        UserDefaults.standard.bool(forKey: "isOneHourBeforeEatingNotificationGranted")
    }
    private var isEatingTimeStartNotificationGranted: Bool {
        UserDefaults.standard.bool(forKey: "isEatingTimeStartNotificationGranted")
    }
    private var isOneHourBeforeFastingNotificationGranted: Bool {
        UserDefaults.standard.bool(forKey: "isOneHourBeforeFastingNotificationGranted")
    }
    private var isFastingTimeStartNotificationGranted: Bool {
        UserDefaults.standard.bool(forKey: "isFastingTimeStartNotificationGranted")
    }
    private var isWaterReminderNotificationGranted: Bool {
        UserDefaults.standard.bool(forKey: "isWaterReminderNotificationGranted")
    }
    private var isChallengeUpdateNotificationGranted: Bool {
        UserDefaults.standard.bool(forKey: "isChallengeUpdateNotificationGranted")
    }
    private var challengeStartDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "challengeStartDate") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "challengeStartDate")
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
    private var activeChallenges: [Int] {
        get {
            UserDefaults.standard.array(forKey: "activeChallenges") as? [Int] ?? []
        } set {
            UserDefaults.standard.set(newValue, forKey: "activeChallenges")
        }
    }
    private var challengeTimerCancelled: Bool {
        get {
            UserDefaults.standard.bool(forKey: "challengeTimerCancelled")
        } set {
            UserDefaults.standard.set(newValue, forKey: "challengeTimerCancelled")
        }
    }
    private var userName: String {
        UserDefaults.standard.string(forKey: "userName") ?? ""
    }
    private var updateWeightTrackerFromOnboarding: Bool? {
        get {
            UserDefaults.standard.bool(forKey: "updateWeightTrackerFromOnboarding")
        } set {
            UserDefaults.standard.set(newValue, forKey: "updateWeightTrackerFromOnboarding")
        }
    }
    private var isFastingTimeNow: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isFastingTimeNow")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isFastingTimeNow")
        }
    }
    private var needToUpdateLevel: Bool {
        get {
            UserDefaults.standard.bool(forKey: "needToUpdateLevel")
        } set {
            UserDefaults.standard.set(newValue, forKey: "needToUpdateLevel")
        }
    }
    private var currentWaterProgress: Float {
        get {
            UserDefaults.standard.float(forKey: "waterProgress")
        } set {
            UserDefaults.standard.set(newValue, forKey: "waterProgress")
        }
    }
    private var dateToAddLvlForChallenge1: Date? {
        get {
            UserDefaults.standard.object(forKey: "dateToAddLvlForChallenge1") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "dateToAddLvlForChallenge1")
        }
    }
    private var dateToAddLvlForChallenge2: Date? {
        get {
            UserDefaults.standard.object(forKey: "dateToAddLvlForChallenge2") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "dateToAddLvlForChallenge2")
        }
    }
    private var dateToAddLvlForChallenge3: Date? {
        get {
            UserDefaults.standard.object(forKey: "dateToAddLvlForChallenge3") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "dateToAddLvlForChallenge3")
        }
    }
    private var dateToAddLvlForChallenge4: Date? {
        get {
            UserDefaults.standard.object(forKey: "dateToAddLvlForChallenge4") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "dateToAddLvlForChallenge4")
        }
    }
    private var dateToAddLvlForChallenge5: Date? {
        get {
            UserDefaults.standard.object(forKey: "dateToAddLvlForChallenge5") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "dateToAddLvlForChallenge5")
        }
    }
    private var dateToAddLvlForChallenge6: Date? {
        get {
            UserDefaults.standard.object(forKey: "dateToAddLvlForChallenge6") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "dateToAddLvlForChallenge6")
        }
    }
    private var lastWaterTrackerResetDate: Date? {
        get {
            UserDefaults.standard.object(forKey: "lastWaterTrackerResetDate") as? Date
        } set {
            UserDefaults.standard.set(newValue, forKey: "lastWaterTrackerResetDate")
        }
    }
    
    private var isTimerRunningNowOnMain = false
    private var needToSetTimer = false
    private var viewModels: [ChallengesTableViewCellViewModel] = [
        ChallengesTableViewCellViewModel(viewModels: [
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().goVeganChallengeHeader, image: K().goVeganChallengeImage!, id: 1, isActive: false, isDone: false),
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().noSmokingChallengeHeader, image: K().noSmokingChallengeImage!, id: 2, isActive: false, isDone: false),
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().noCoffeeChallengeHeader, image: K().noCoffeeChallengeImage!, id: 3, isActive: false, isDone: false),
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().noAlcoholChallengeHeader, image: K().noAlcoholChallengeImage!, id: 4, isActive: false, isDone: false),
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().noFastFoodChallengeHeader, image: K().noFastFoodChallengeImage!, id: 5, isActive: false, isDone: false),
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().noSugarChallengeHeader, image: K().noSugarChallengeImage!, id: 6, isActive: false, isDone: false)
        ])
    ]
    private let device = Device.current
    private let bigDevices: [Device] = K().bigDevices
    private let smallDevices: [Device] = K().smallDevices
    private let hugeDevices: [Device] = K().hugeDevices
    
    var refreshControl: UIRefreshControl!
    
    var separator: UILabel = {
        let s = UILabel()
        s.backgroundColor = .white
        s.layer.borderWidth = 1
        s.layer.borderColor = Colors().separatorColor
        
        return s
    }()
    
    @available(iOS, deprecated: 15.0)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.parent?.title = "MAIN SCREEN"
        
        scrollView.delegate? = self
        challengesTableView.delegate = self
        challengesTableView.dataSource = self
        fastingTimer.delegate = self
        beforeStartDateTimer.delegate = self
        
        configureTabBar()
        
        synchronizeActiveChallengesState()
        synchronizeDoneChallengesState()
        
        // configureWaterTracker must stay in viewDidLoad (говнокод)
        checkIfNeedToResetWaterProgress()
        configureWaterTracker()
        
        challengesTableView.register(ChallengesTableViewCell.self,
                                     forCellReuseIdentifier: ChallengesTableViewCell.identifier)
        
        challengesTableView.showsVerticalScrollIndicator = false
        challengesTableView.separatorStyle = .none
        scrollView.showsVerticalScrollIndicator = false
        
        challengesPageControl.numberOfPages = 3
        challengesPageControl.currentPage = 0
        view.bringSubviewToFront(challengesPageControl)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let levelTap = UITapGestureRecognizer(target: self, action: #selector(levelQuestionIconTapped))
        levelDescriptionIcon.isUserInteractionEnabled = true
        levelDescriptionIcon.addGestureRecognizer(levelTap)
        
        let timerTap = UITapGestureRecognizer(target: self, action: #selector(timerQuestionIconTapped))
        timerViewQuestionIcon.isUserInteractionEnabled = true
        timerViewQuestionIcon.addGestureRecognizer(timerTap)
        
        let waterTap = UITapGestureRecognizer(target: self, action: #selector(waterTrackerIconTapped))
        waterTrackerQuestionIcon.isUserInteractionEnabled = true
        waterTrackerQuestionIcon.addGestureRecognizer(waterTap)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        scrollView.insertSubview(refreshControl, at: 0)
        
        notifications.checkAuthorizationStatus()
    }
    
    @available(iOS, deprecated: 15.0) // edgeInsets warning silencer
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.parent?.title = "Main Screen"
        
        synchronizeActiveChallengesState()
        synchronizeDoneChallengesState()
        checkIfWeightWasUpdated()
        checkIfNeedToUpdatelPercentageLabel()
        fillPercenageLabel()
        checkIfNeedToKillTimer()
        checkIfGoalWasReached()
        setTimer()
        updateCurrentFastingHours()
        checkIfNeedToUpdateLevelTitle()
        checkIfNeedToAddLevelForChallenge()
        checkIfNeedToUpdateGoalLabels()
        checkIfWaterGoalSet()
        checkIfNeedToUpdateWaterGoal()
        checkIfNeedToResetWaterProgress()
        
        DispatchQueue.main.async {
            self.configureWeightGoalView()
        }
        
        if challengeTimerCancelled == true {
            synchronizeActiveChallengesState()
            synchronizeDoneChallengesState()
            challengesTableView.reloadData()
            challengeTimerCancelled = false
        }
    }
    
    @objc func appWillEnterForeground() {
        synchronizeActiveChallengesState()
        synchronizeDoneChallengesState()
        challengesTableView.reloadData()
        needToKillTimerOnMain = true
        checkIfNeedToKillTimer()
        checkIfGoalWasReached()
        setTimer()
        checkIfNeedToAddLevelForChallenge()
        checkIfNeedToResetWaterProgress()
    }
    
    @objc func onRefresh() {
        refreshControl.endRefreshing()
    }
    
    @available(iOS, deprecated: 15.0) // edgeInsets warning silencer
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async { [self] in
            scrollView.backgroundColor = Colors().contentViewBackgroundColor
            contentView.backgroundColor = Colors().contentViewBackgroundColor
            configurePageControl()
            configureRectangles()
            configureUserInfoView()
            configureTimerView()
            configureChallengesView()
            fillLevelProgressView()
        }
    }
    
    private func checkIfNeedToUpdateLevelTitle() {
        if needToUpdateLevel == true {
            updateLevelTitle()
            needToUpdateLevel = false
        }
    }
    
    private func updateLevelTitle() {
        currentLevelLabel.text = "Lv. " + String(currentLevel + 1)
        nextLevelLabel.text = String(currentLevel + 2)
        
        if (0...8).contains(currentLevel) { // must use 1 lvl less than desired one
            levelDescriptionLabel.text = "Beginner"
        } else if (9...18).contains(currentLevel) {
            levelDescriptionLabel.text = "Advanced"
        } else if (19...28).contains(currentLevel) {
            levelDescriptionLabel.text = "Expert"
        } else if (29...38).contains(currentLevel) {
            levelDescriptionLabel.text = "Master"
        } else if (49...10000).contains(currentLevel) {
            levelDescriptionLabel.text = "Gigachad"
        }
    }
    
    private func fillLevelProgressView() {
        levelProgressView.setProgress(UserDefaults.standard.float(forKey: "levelProgress"), animated: true)
    }
    
    private func configureUserInfoView() {
        avatarImage.image = UIImage(named: "avatarka")
        currentLevelLabel.text = "Lv. " + String(currentLevel + 1)
        nextLevelLabel.text = String(currentLevel + 2)
        
        if userName != "" {
            userNameLabel.text = "Welcome, \(userName)"
        } else {
            userNameLabel.text = "Welcome!"
        }
        levelDescriptionLabel.minimumScaleFactor = 0.5
        levelDescriptionLabel.numberOfLines = 0
        levelDescriptionLabel.adjustsFontSizeToFitWidth = true
        levelDescriptionLabel.textColor = Colors().levelDescriptionLabelColor
        levelDescriptionLabel.font = Fonts().systemFont(ofSize: 16, weight: .light)
        levelDescriptionIcon.image = K().questionIcon
        
        updateLevelTitle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            separator.frame = CGRect(x: 0, y: levelInfoView.frame.midY / 3, width: levelInfoView.viewWidth / 1.1001, height: 1)
            levelInfoView.addSubview(separator)
        }
        c.configureLevelProgressView(levelProgressView)
        
        levelProgressView.setProgress(0, animated: false)
    }
    
    @objc func levelQuestionIconTapped() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "levelInfoController") as! LevelInfoViewController
        
        if let vcAsSheet = vc.sheetPresentationController {
            
            if #available(iOS 16.0, *) {
                let customDetentID = UISheetPresentationController.Detent.Identifier("for16")
                let detent = UISheetPresentationController.Detent.custom(identifier: customDetentID) { context in
                    
                    return self.view.bounds.height / 1.21 - self.view.safeAreaInsets.bottom
                }
                
                vcAsSheet.detents = [detent]
                vc.needToHideButton = true
            } else {
                vcAsSheet.detents = [.large()]
            }
            vcAsSheet.prefersScrollingExpandsWhenScrolledToEdge = false
            vcAsSheet.prefersGrabberVisible = true
        }
        
        self.present(vc, animated: true)
    }
    
    @available(iOS, deprecated: 15.0) // edgeInsets warning silencer
    private func configureWeightGoalView() {
        toReachGoalLabel.font = Fonts().systemFont(ofSize: 20, weight: .medium)
        toReachGoalLabel.minimumScaleFactor = 0.5
        toReachGoalLabel.numberOfLines = 1
        toReachGoalLabel.adjustsFontSizeToFitWidth = true
        toReachGoalLabel.textColor = Colors().labelBlackColor
        startingWeightLabel.font = Fonts().systemFont(ofSize: 16, weight: .regular)
        startingWeightLabel.minimumScaleFactor = 0.5
        startingWeightLabel.numberOfLines = 1
        startingWeightLabel.adjustsFontSizeToFitWidth = true
        startingWeightLabel.textColor = Colors().labelBlackColor
        goalWeightLabel.font = Fonts().systemFont(ofSize: 16, weight: .regular)
        goalWeightLabel.minimumScaleFactor = 0.5
        goalWeightLabel.numberOfLines = 1
        goalWeightLabel.adjustsFontSizeToFitWidth = true
        goalWeightLabel.textColor = Colors().labelBlackColor
        weightGoalImageView.image = K().weightGoalViewImage
        c.configureEditButton(button: editGoalButton, title: "Edit Goal")
        c.configureWeightGoalProgressView(goalProgressView)
        
        goalProgressView.setProgress(0, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            UIView.animate(withDuration: 0.5) {
                self.goalProgressView.setProgress(UserDefaults.standard.float(forKey: "goalProgress"), animated: true)
            }
        }
    }
    
    private func checkIfNeedToUpdateGoalLabels() {
        startingWeightLabel.text = (startingUserWeight ?? "NA") + " kg"
        goalWeightLabel.text = (currentUserWeightGoal ?? "NA") + " kg"
    }
    
    @available(iOS, deprecated: 15.0)
    private func configureTimerView() {
        c.configureTimerView(label: timerViewLabel, icon: timerViewQuestionIcon)
        c.configureEditButton(button: timerViewButton, title: "Update fasting parameters")
    }
    
    @objc func timerQuestionIconTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "fastingInfoController") as! FastingInfoViewController
        
        if let vcAsSheet = vc.sheetPresentationController {
            
            if #available(iOS 16.0, *) {
                let customDetentID = UISheetPresentationController.Detent.Identifier("for16")
                let detent = UISheetPresentationController.Detent.custom(identifier: customDetentID) { context in
                    
                    return self.view.bounds.height / 1.21 - self.view.safeAreaInsets.bottom
                }
                
                vcAsSheet.detents = [detent]
                vc.needToHideButton = true
            } else {
                vcAsSheet.detents = [.large()]
            }
            vcAsSheet.prefersScrollingExpandsWhenScrolledToEdge = false
            vcAsSheet.prefersGrabberVisible = true
        }
        
        self.present(vc, animated: true)
    }
    
    private func checkIfNeedToResetWaterProgress() {
        guard let lastRefreshDate = lastWaterTrackerResetDate else { return }

        let refreshComponents = Calendar.current.dateComponents([.year, .month, .day], from: lastRefreshDate)
        let currentComponents = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        
        if let refreshDate = Calendar.current.date(from: refreshComponents), let currentDate = Calendar.current.date(from: currentComponents) {
            
            if currentDate > refreshDate {
                waterTracker.resetWaterProgress(waterProgressView)
                lastWaterTrackerResetDate = .now
            } else {
                return
            }
        }
    }
    
    private func checkIfNeedToUpdateWaterGoal() {
        currentUserWaterGoalLabel.text = (currentUserWaterGoal ?? "NA") + " L."
    }
    
    @available(iOS, deprecated: 15.0)
    private func checkIfWaterGoalSet() {
        if currentUserWaterGoal == nil {
            addWaterButton.isEnabled = false
            c.configureEditButton(button: waterTrackerEditButton, title: "Set your daily water goal")
        } else {
            addWaterButton.isEnabled = true
            c.configureEditButton(button: waterTrackerEditButton, title: "Update water tracker parameters")
        }
    }
    
    @available(iOS, deprecated: 15.0)
    private func configureWaterTracker() {
        waterTrackerLabel.text = "Water Tracker"
        waterTrackerLabel.font = Fonts().systemFont(ofSize: 24, weight: .medium)
        waterTrackerLabel.textColor = Colors().labelBlackColor
        waterTrackerLabel.minimumScaleFactor = 0.5
        waterTrackerLabel.numberOfLines = 1
        if device.isOneOf(hugeDevices) {
            waterTrackerLabel.adjustsFontSizeToFitWidth = false
        } else {
            waterTrackerLabel.adjustsFontSizeToFitWidth = true
        }
        waterTrackerQuestionIcon.image = K().questionIcon
        waterProgressView.tintColor = .blue
        waterProgressView.layer.borderColor = Colors().waterProgressViewBackgroundColor.cgColor
        waterProgressView.layer.borderWidth = 1
        waterProgressView.trackTintColor = .clear
        waterProgressView.backgroundColor = Colors().waterProgressViewBackgroundColor
        waterProgressView.progressTintColor = Colors().waterProgressViewProgressTintColor
        waterProgressView.roundCorners(corners: [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: 4)
        waterProgressView.layer.masksToBounds = true
        waterProgressView.clipsToBounds = true
        waterProgressView.height(49)
        c.configureAddWaterButton(button: addWaterButton)
        
        waterProgressView.setProgress(0, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.waterProgressView.setProgress(self.currentWaterProgress, animated: true)
        }
    }
    
    @objc func waterTrackerIconTapped() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "waterInfoController") as! WaterInfoViewController
        
        if let vcAsSheet = vc.sheetPresentationController {
            
            if #available(iOS 16.0, *) {
                let customDetentID = UISheetPresentationController.Detent.Identifier("for16")
                let detent = UISheetPresentationController.Detent.custom(identifier: customDetentID) { context in
                    
                    return self.view.bounds.height / 1.21 - self.view.safeAreaInsets.bottom
                }
                
                vcAsSheet.detents = [detent]
                vc.needToHideButton = true
            } else {
                vcAsSheet.detents = [.large()]
            }
            vcAsSheet.prefersScrollingExpandsWhenScrolledToEdge = false
            vcAsSheet.prefersGrabberVisible = true
        }
        
        self.present(vc, animated: true)
    }
    
    private func configureChallengesView() {
        challengesLabel.text = "Challenges"
        challengesLabel.font = Fonts().systemFont(ofSize: 20, weight: .medium)
        challengesLabel.textColor = Colors().labelBlackColor
        challengesLabel.minimumScaleFactor = 0.5
        challengesLabel.numberOfLines = 1
        challengesLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func configureTabBar() {
        let tabBarAppereance = UITabBarAppearance()
        tabBarAppereance.backgroundColor = .clear
        tabBarAppereance.stackedLayoutAppearance.selected.iconColor = Colors().selectedTabBarIconColor
        tabBarAppereance.stackedLayoutAppearance.normal.iconColor = Colors().violetLight
        tabBarAppereance.stackedItemPositioning = .centered
        
        tabBarController?.tabBar.items![0].title = nil
        if device.isOneOf(smallDevices)  {
            tabBarAppereance.stackedItemSpacing = 5
            tabBarController?.tabBar.items![0].image = UIImage(named: "mainIconScaled")
            tabBarController?.tabBar.items![0].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        } else {
            tabBarAppereance.stackedItemSpacing = 10
            tabBarController?.tabBar.items![0].image = UIImage(named: "mainIcon")
            tabBarController?.tabBar.items![0].imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0)
        }
        
        tabBarController?.tabBar.items![1].title = nil
        if device.isOneOf(smallDevices)  {
            tabBarController?.tabBar.items![1].image = UIImage(named: "hoursIconScaled")
            tabBarController?.tabBar.items![1].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        } else {
            tabBarController?.tabBar.items![1].image = UIImage(named: "hoursIcon")
            tabBarController?.tabBar.items![1].imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0)
        }
        
        tabBarController?.tabBar.items![2].title = nil
        if device.isOneOf(smallDevices)  {
            tabBarController?.tabBar.items![2].image = UIImage(named: "progressIconScaled")
            tabBarController?.tabBar.items![2].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        } else {
            tabBarController?.tabBar.items![2].image = UIImage(named: "progressIcon")
            tabBarController?.tabBar.items![2].imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0)
        }
        
        tabBarController?.tabBar.items![3].title = nil
        if device.isOneOf(smallDevices)  {
            tabBarController?.tabBar.items![3].image = UIImage(named: "settingsIconScaled")
            tabBarController?.tabBar.items![3].imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        } else {
            tabBarController?.tabBar.items![3].image = UIImage(named: "settingsIcon")
            tabBarController?.tabBar.items![3].imageInsets = UIEdgeInsets(top: 15, left: 0, bottom: -15, right: 0)
        }
        
        tabBarController?.tabBar.scrollEdgeAppearance = tabBarAppereance
        tabBarController?.tabBar.standardAppearance = tabBarAppereance
        tabBarController?.tabBar.items![0].scrollEdgeAppearance = tabBarAppereance
        tabBarController?.tabBar.items![0].standardAppearance = tabBarAppereance
        tabBarController?.tabBar.items![1].scrollEdgeAppearance = tabBarAppereance
        tabBarController?.tabBar.items![1].standardAppearance = tabBarAppereance
        tabBarController?.tabBar.items![2].scrollEdgeAppearance = tabBarAppereance
        tabBarController?.tabBar.items![2].standardAppearance = tabBarAppereance
        tabBarController?.tabBar.items![3].scrollEdgeAppearance = tabBarAppereance
        tabBarController?.tabBar.items![3].standardAppearance = tabBarAppereance
    }
    
    private func configureRectangles() {
        c.configureRectangle(rectangle: userInfoRectangle)
        c.configureRectangle(rectangle: weightTrackerRect)
        c.configureRectangle(rectangle: timerRect)
        c.configureRectangle(rectangle: waterTrackerRect)
        c.configureRectangle(rectangle: challengesRect)
    }
    
    private func checkIfNeedToUpdatelPercentageLabel() {
        if updateWeightTrackerFromOnboarding == true {
            prettyPercent = "0%"
            fillPercenageLabel()
            updateWeightTrackerFromOnboarding = false
        } else {
            return
        }
    }
    
    private func checkIfNeedToAddLevelForChallenge() {
        if let date = dateToAddLvlForChallenge1 {
            let currentDate = Date.now
            if currentDate >= date {
                currentLevel += 2
                DispatchQueue.main.async {
                    self.updateLevelTitle()
                }
                dateToAddLvlForChallenge1 = nil
            }
        }
        if let date = dateToAddLvlForChallenge2 {
            let currentDate = Date.now
            if currentDate >= date {
                currentLevel += 2
                DispatchQueue.main.async {
                    self.updateLevelTitle()
                }
                dateToAddLvlForChallenge2 = nil
            }
        }
        if let date = dateToAddLvlForChallenge3 {
            let currentDate = Date.now
            if currentDate >= date {
                currentLevel += 2
                DispatchQueue.main.async {
                    self.updateLevelTitle()
                }
                dateToAddLvlForChallenge3 = nil
            }
        }
        if let date = dateToAddLvlForChallenge4 {
            let currentDate = Date.now
            if currentDate >= date {
                currentLevel += 2
                DispatchQueue.main.async {
                    self.updateLevelTitle()
                }
                dateToAddLvlForChallenge4 = nil
            }
        }
        if let date = dateToAddLvlForChallenge5 {
            let currentDate = Date.now
            if currentDate >= date {
                currentLevel += 2
                DispatchQueue.main.async {
                    self.updateLevelTitle()
                }
                dateToAddLvlForChallenge5 = nil
            }
        }
        if let date = dateToAddLvlForChallenge6 {
            let currentDate = Date.now
            if currentDate >= date {
                currentLevel += 2
                DispatchQueue.main.async {
                    self.updateLevelTitle()
                }
                dateToAddLvlForChallenge6 = nil
            }
        }
    }
    
    private func lvlUp() {
        currentLevelLabel.text = "Lv. " + String(currentLevel + 1)
        nextLevelLabel.text = String(currentLevel + 2)
    }
    
    private func configurePageControl() {
        challengesPageControl.currentPageIndicatorTintColor = Colors().switchTintColor
        challengesPageControl.pageIndicatorTintColor = Colors().grayTxt
        challengesPageControl.backgroundStyle = .minimal
    }
    
    private func synchronizeActiveChallengesState() {
        if isChallenge1Active == true {
            viewModels[0].viewModels[0].isActive = true
        }
        if isChallenge2Active == true {
            viewModels[0].viewModels[1].isActive = true
        }
        if isChallenge3Active == true {
            viewModels[0].viewModels[2].isActive = true
        }
        if isChallenge4Active == true {
            viewModels[0].viewModels[3].isActive = true
        }
        if isChallenge1Active == false {
            viewModels[0].viewModels[0].isActive = false
        }
        if isChallenge2Active == false {
            viewModels[0].viewModels[1].isActive = false
        }
        if isChallenge3Active == false {
            viewModels[0].viewModels[2].isActive = false
        }
        if isChallenge4Active == false {
            viewModels[0].viewModels[3].isActive = false
        }
    }
    
    private func synchronizeDoneChallengesState() {
        
        if isChallenge1Done == true {
            viewModels[0].viewModels[0].isDone = true
            activeChallenges.removeAll { $0 == 1 }
        }
        if isChallenge2Done == true {
            viewModels[0].viewModels[1].isDone = true
            activeChallenges.removeAll { $0 == 2 }
        }
        if isChallenge3Done == true {
            viewModels[0].viewModels[2].isDone = true
            activeChallenges.removeAll { $0 == 3 }
        }
        if isChallenge4Done == true {
            viewModels[0].viewModels[3].isDone = true
            activeChallenges.removeAll { $0 == 4 }
        }
        if isChallenge1Done == false {
            viewModels[0].viewModels[0].isDone = false
        }
        if isChallenge2Done == false {
            viewModels[0].viewModels[1].isDone = false
        }
        if isChallenge3Done == false {
            viewModels[0].viewModels[2].isDone = false
        }
        if isChallenge4Done == false {
            viewModels[0].viewModels[3].isDone = false
        }
    }
    
    private func fillPercenageLabel() {
        if let percent = prettyPercent {
            if percent.count > 1 {
                if percent == "0%" {
                    toReachGoalLabel.text = "You have your goal! Move towards it :)"
                } else {
                    let text = "\(percent) done on the way to your goal"
                    toReachGoalLabel.text = text
                }
            } else if wasGoalReached == true {
                toReachGoalLabel.text = "Goal was reached! Nice job :)"
            } else if wasGoalReached == false && currentUserWeight != "NA" && currentUserWeightGoal != "NA"{
                toReachGoalLabel.text = "You have your goal! Move towards it :)"
            } else {
                toReachGoalLabel.text = "Feel free to set your goal anytime!"
            }
        } else {
            toReachGoalLabel.text = "Feel free to set your goal anytime!"
        }
    }
    
    private func updateCurrentFastingHours() {
        if let index = lastFastingHour {
            let diff = Calendar.current.dateComponents([.hour, .minute, .second], from: .now, to: index)
            if diff.hour != nil && diff.minute != nil && diff.second != nil {
                let toLastFastHourInterval = (diff.hour! * 3600) + (diff.minute! * 60) + diff.second!
                if toLastFastHourInterval > 0 {
                    fastHoursPassed = Int((stableToLastFastInterval - Double(toLastFastHourInterval)) / 3600)
                }
            }
        }
    }
    
    private func checkIfGoalWasReached() {
        if goalFastStreak >= 7 {
            if let beforeTime: Date = streakStartDate {
                if beforeTime.timeAgoSince(days: goalFastStreak) {
                    startingDate = nil
                    streakStartDate = nil
                    fastingTimer.killTimer()
                    needToKillTimerOnMain = true
                    currentFastStreak = 0
                    wasGoalStreakReached = true
                    DispatchQueue.main.async { [self] in
                        setTimer()
                    }
                }
            }
        }
    }
    
    private func setTimer() {
        if isTimerRunningNowOnMain == false {
            
            if let index = startingDate {
                
                let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: .now, to: index)
                if difference.hour != nil && difference.minute != nil && difference.second != nil {
                    let beforeStartInterval = (difference.hour! * 3600) + (difference.minute! * 60) + difference.second!
                    if beforeStartInterval > 0 {
                            beforeStartDateTimer.startTimer(view: timerRectangle,
                                                            fastStatusView: fastingStatusView,
                                                            fastTimeView: fastingTimeView,
                                                            interval: TimeInterval(beforeStartInterval))
                            isTimerRunningNowOnMain = true
                            isFastingTimeNow = false
                            wasGoalStreakReached = false
                    } else if beforeStartInterval <= 0 {
                        if let index = lastFastingHour {
                            let diff = Calendar.current.dateComponents([.hour, .minute, .second], from: .now, to: index)
                            if diff.hour != nil && diff.minute != nil && diff.second != nil {
                                let toLastFastHourInterval = (diff.hour! * 3600) + (diff.minute! * 60) + diff.second!
                                if toLastFastHourInterval > 0 {
                                    fastHoursPassed = Int((stableToLastFastInterval - Double(toLastFastHourInterval)) / 3600)
                                        isIntervalFirst = false
                                        fastingTimer.startFeastingTimer(view: timerRectangle,
                                                                        fastStatusView: fastingStatusView,
                                                                        fastTimeView: fastingTimeView,
                                                                        interval: TimeInterval(toLastFastHourInterval),
                                                                        textForInfo: "Fasting Period",
                                                                        strokeColor: Colors().violetLight.cgColor)
                                        isTimerRunningNowOnMain = true
                                        isFastingTimeNow = true
                                        wasGoalStreakReached = false
                                } else if beforeStartInterval <= 0 && toLastFastHourInterval <= 0 {
                                    if let index = firstFastingHour {
                                        let diff = Calendar.current.dateComponents([.hour, .minute, .second], from: .now, to: index)
                                        if diff.hour != nil && diff.minute != nil && diff.second != nil {
                                            let toFirstFastHourInterval = (diff.hour! * 3600) + (diff.minute! * 60) + diff.second!
                                            if toFirstFastHourInterval > 0 {
                                                    isIntervalFirst = true
                                                    fastingTimer.startFeastingTimer(view: timerRectangle,
                                                                                    fastStatusView: fastingStatusView,
                                                                                    fastTimeView: fastingTimeView,
                                                                                    interval: TimeInterval(toFirstFastHourInterval),
                                                                                    textForInfo: "Eating Period",
                                                                                    strokeColor: Colors().violetDark.cgColor)
                                                    isTimerRunningNowOnMain = true
                                                    fastHoursPassed = 0
                                                    isFastingTimeNow = false
                                                    wasGoalStreakReached = false
                                            } else if beforeStartInterval <= 0 && toLastFastHourInterval <= 0 && toFirstFastHourInterval <= 0 {
                                                print("all intervals are <= 0")
                                                needToSetTimer = true
                                                fastHoursPassed = 0
                                                addDay()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                fastingTimer.noTimer(view: timerRectangle, hView: fastingStatusView, pView: fastingTimeView)
                isFastingTimeNow = false
            }
        } else {return}
    }
    
    private func addDay() {
        var oneDay = DateComponents()
        oneDay.day = 1
        
        if let firstHour = firstFastingHour, let lastHour = lastFastingHour {
            
            let newFirstDate = Calendar.current.date(byAdding: oneDay, to: firstHour)
            let newLastDate = Calendar.current.date(byAdding: oneDay, to: lastHour)
            
            firstFastingHour = newFirstDate
            lastFastingHour = newLastDate
            currentFastStreak += 1
            levelingLogic.addLevelPoints(points: 0.464, progressView: levelProgressView)
            
            checkIfNeedToSetTimer()
        }
    }
    
    private func checkIfNeedToSetTimer() {
        if needToSetTimer == true {
            setTimer()
            needToSetTimer = false
        } else {
            return
        }
    }
    
    private func checkIfNeedToKillTimer() {
        if needToKillTimerOnMain == true {
            beforeStartDateTimer.killTimer()
            fastingTimer.killTimer()
            isTimerRunningNowOnMain = false
            needToKillTimerOnMain = false
        } else {
            return
        }
    }
    
    private func updateWeight(_ newWeight: String) {
        if let newValue = Double(newWeight), let currentValue = Double(currentUserWeight ?? "NA") {
            print(newValue, currentValue)
            
            if newValue > currentValue {
                if let startingWeight = Double(startingUserWeight ?? "NA") {
                    if newValue > startingWeight {
                        UserDefaults.standard.set(newValue.clean, forKey: "startingWeight")
                        startingWeightLabel.text = (startingUserWeight ?? "NA") + " kg"
                        weightTracker.calculateWeight()
                        weightTracker.updateWeight(goalProgressView, addLevelPointsTo: levelProgressView, newWeight: newWeight, progressLabel: toReachGoalLabel)
                        fillPercenageLabel()
                        UserDefaults.standard.set(newWeight, forKey: "currentWeight")
                    } else if newValue < startingWeight {
                        weightTracker.updateWeight(goalProgressView, addLevelPointsTo: levelProgressView, newWeight: newWeight, progressLabel: toReachGoalLabel)
                        fillPercenageLabel()
                        UserDefaults.standard.set(newWeight, forKey: "currentWeight")
                    }
                }
            } else if newValue < currentValue {
                weightTracker.updateWeight(goalProgressView, addLevelPointsTo: levelProgressView, newWeight: newWeight, progressLabel: toReachGoalLabel)
                fillPercenageLabel()
                UserDefaults.standard.set(newWeight, forKey: "currentWeight")
            } else if newValue == currentValue {
                return
            }
        }
    }
    
    private func checkIfWeightWasUpdated() {
        if wasWeightUpdated == true {
            if let newWeight = userUpdatedWeight {
                updateWeight(newWeight)
                wasWeightUpdated = false
            }
        } else if wasWeightUpdated == false {
            return
        }
    }
    
    @IBAction func setUpButtonPressed(_ sender: UIButton) {
        fastingTimer.killTimer()
        beforeStartDateTimer.killTimer()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "trackerSettingsController") as! TrackerSettingsViewController
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addWaterPressed(_ sender: UIButton) {
        waterTracker.addWater(waterProgressView, addLevelPointsTo: levelProgressView)
        lvlUp()
        checkIfNeedToUpdateLevelTitle()
        addWaterButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.addWaterButton.isEnabled = true
        }
    }
    
    @IBAction func editWeightGoalButtonPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "weightController") as! EditWeightGoalViewController
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func editWaterGoalButtonPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "waterController") as! EditWaterGoalViewController
        waterTracker.resetWaterProgress(waterProgressView)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - ScrollView Delegate Methods
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.scrollView.contentOffset.x = 0.0
        
    }
}

//MARK: - Protocols

protocol MainViewControllerDelegate: AnyObject {
    var isFirst: Bool? { get set }
}

//MARK: - Extensions

extension MainViewController: EditWeightGoalViewControllerDelegate {
    func goalWasUpdated() {
        if let currentWeight = currentUserWeight {
            weightTracker.updateWeight(goalProgressView, newWeight: currentWeight, progressLabel: toReachGoalLabel)
            fillPercenageLabel()
        }
    }
}

extension MainViewController: UISheetPresentationControllerDelegate {
    
    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        (presentationController as? UISheetPresentationController)?.animateChanges {
            view.layoutIfNeeded()
        }
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        (presentationController as? UISheetPresentationController)?.animateChanges {
            view.layoutIfNeeded()
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChallengesTableViewCell.identifier, for: indexPath) as? ChallengesTableViewCell else {fatalError("Can't downcast cell as ChallengesTableViewCell, should not happen")}
        
        cell.delegate = self
        cell.configure(with: viewModel)
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return challengesTableView.viewHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        synchronizeDoneChallengesState()
        synchronizeActiveChallengesState()
    }
}

extension MainViewController: ChallengeCardViewControllerDelegate {
    func challengeWasSet(challengeID: Int) {
        let calendar = Calendar.current
        activeChallenges.append(challengeID)
        viewModels[0].viewModels[challengeID - 1].isActive = true
        viewModels[0].viewModels[challengeID - 1].isDone = false
        
        if challengeID == 1 {
            isChallenge1Active = true
            isChallenge1Done = false
            if isChallengeUpdateNotificationGranted == true {
                if let challengePeriod = challenge1Period {
                    let startDateAsComponents =  calendar.dateComponents([.year,.month, .day, .hour, .minute, .second], from: challengePeriod)
                    notifications.sendChallengeUpdateNotification(challengeName: "Go Vegan!", challengeStartDate: startDateAsComponents, challengeID: 1)
                    dateToAddLvlForChallenge1 = calendar.date(from: startDateAsComponents)
                }
            }
        } else if challengeID == 2 {
            isChallenge2Active = true
            isChallenge2Done = false
            if isChallengeUpdateNotificationGranted == true {
                if let challengePeriod = challenge2Period {
                    let startDateAsComponents =  calendar.dateComponents([.year,.month, .day, .hour, .minute, .second], from: challengePeriod)
                    notifications.sendChallengeUpdateNotification(challengeName: "No Smoking", challengeStartDate: startDateAsComponents, challengeID: 2)
                    dateToAddLvlForChallenge2 = calendar.date(from: startDateAsComponents)
                }
            }
        } else if challengeID == 3 {
            isChallenge3Active = true
            isChallenge3Done = false
            if isChallengeUpdateNotificationGranted == true {
                if let challengePeriod = challenge3Period {
                    let startDateAsComponents =  calendar.dateComponents([.year,.month, .day, .hour, .minute, .second], from: challengePeriod)
                    notifications.sendChallengeUpdateNotification(challengeName: "No Coffee", challengeStartDate: startDateAsComponents, challengeID: 3)
                    dateToAddLvlForChallenge3 = calendar.date(from: startDateAsComponents)
                }
            }
        } else if challengeID == 4 {
            isChallenge4Active = true
            isChallenge4Done = false
            if isChallengeUpdateNotificationGranted == true {
                if let challengePeriod = challenge4Period {
                    let startDateAsComponents =  calendar.dateComponents([.year,.month, .day, .hour, .minute, .second], from: challengePeriod)
                    notifications.sendChallengeUpdateNotification(challengeName: "No Alcohol", challengeStartDate: startDateAsComponents, challengeID: 4)
                    dateToAddLvlForChallenge4 = calendar.date(from: startDateAsComponents)
                }
            }
        } else if challengeID == 5 {
            isChallenge5Active = true
            isChallenge5Done = false
            if isChallengeUpdateNotificationGranted == true {
                if let challengePeriod = challenge5Period {
                    let startDateAsComponents =  calendar.dateComponents([.year,.month, .day, .hour, .minute, .second], from: challengePeriod)
                    notifications.sendChallengeUpdateNotification(challengeName: "No Fast Food", challengeStartDate: startDateAsComponents, challengeID: 5)
                    dateToAddLvlForChallenge5 = calendar.date(from: startDateAsComponents)
                }
            }
        } else if challengeID == 6 {
            isChallenge6Active = true
            isChallenge6Done = false
            if isChallengeUpdateNotificationGranted == true {
                if let challengePeriod = challenge6Period {
                    let startDateAsComponents =  calendar.dateComponents([.year,.month, .day, .hour, .minute, .second], from: challengePeriod)
                    notifications.sendChallengeUpdateNotification(challengeName: "Sugar Free", challengeStartDate: startDateAsComponents, challengeID: 6)
                    dateToAddLvlForChallenge6 = calendar.date(from: startDateAsComponents)
                }
            }
        }
        
        synchronizeActiveChallengesState()
        synchronizeDoneChallengesState()
        
        self.challengesTableView.reloadData()
    }
}

extension MainViewController: ChallengeTimerViewControllerDelegate {
    func challengeWasCancelled(challengeID: Int) {
        activeChallenges.removeAll { $0 == challengeID }
        var challengesTimer = ChallengesTimer()
        challengesTimer.killTimer()
        
        if challengeID == 1 {
            isChallenge1Active = false
            isChallenge1Done = false
            challenge1Period = nil
            notifications.center.removePendingNotificationRequests(withIdentifiers: ["challenge1Update"])
            dateToAddLvlForChallenge1 = nil
        } else if challengeID == 2 {
            isChallenge2Active = false
            isChallenge2Done = false
            challenge2Period = nil
            notifications.center.removePendingNotificationRequests(withIdentifiers: ["challenge2Update"])
            dateToAddLvlForChallenge2 = nil
        } else if challengeID == 3 {
            isChallenge3Active = false
            isChallenge3Done = false
            challenge3Period = nil
            notifications.center.removePendingNotificationRequests(withIdentifiers: ["challenge3Update"])
            dateToAddLvlForChallenge3 = nil
        } else if challengeID == 4 {
            isChallenge4Active = false
            isChallenge4Done = false
            challenge4Period = nil
            notifications.center.removePendingNotificationRequests(withIdentifiers: ["challenge4Update"])
            dateToAddLvlForChallenge4 = nil
        } else if challengeID == 5 {
            isChallenge5Active = false
            isChallenge5Done = false
            challenge5Period = nil
            notifications.center.removePendingNotificationRequests(withIdentifiers: ["challenge5Update"])
            dateToAddLvlForChallenge5 = nil
        } else if challengeID == 6 {
            isChallenge6Active = false
            isChallenge6Done = false
            challenge6Period = nil
            notifications.center.removePendingNotificationRequests(withIdentifiers: ["challenge6Update"])
            dateToAddLvlForChallenge6 = nil
        }
        
        synchronizeActiveChallengesState()
        synchronizeDoneChallengesState()
        
        self.challengesTableView.reloadData()
    }
}

extension MainViewController: ChallengesTableViewCellDelegate {
    func itemWasTapped(with viewModel: ChallengesCollectionViewCellViewModel) {
        if activeChallenges.contains(viewModel.id) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "challengeTimerController") as! ChallengeTimerViewController
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.challengeNumber = viewModel.id
            self.present(vc, animated: true, completion: nil)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "challengeCardController") as! ChallengeCardViewController
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.challengeNumber = viewModel.id
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func pageChanged(newPage: Int) {
        challengesPageControl.currentPage = newPage
    }
    
    func challengeStateChanged(with ID: Int) {
        synchronizeDoneChallengesState()
        synchronizeActiveChallengesState()
    }
}

extension MainViewController: UpdateWeightViewControllerDelegate {
    func weighWasUpdated(newWeight: String) {
        updateWeight(newWeight)
    }
}

extension MainViewController: FeastingProgressBarViewDelegate {
    func addDayToDate() {
//        addDay()
    }
    
    func timerEnded() {
        if isIntervalFirst == false {
            levelingLogic.addLevelPoints(points: 0.25, progressView: levelProgressView)
        }
        
        isTimerRunningNowOnMain = false
        fastHoursPassed = 0
        setTimer()
    }
}

extension MainViewController: BeforeStartDateTimerDelegate {
    func startDateIsNow() {
        isTimerRunningNowOnMain = false
        setTimer()
    }
}

extension MainViewController: TrackerSettingsViewControllerDelegate {
    func updateTrackerSettings() {
        fastingTimer.killTimer()
        beforeStartDateTimer.killTimer()
        isTimerRunningNowOnMain = false
    }
}
