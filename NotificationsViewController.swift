//
//  NotificationsViewController.swift
//  IF project
//
//  Created by Misha on 17.01.2023.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    private let c = Components()
    
    private var isOneHourBeforeEatingNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isOneHourBeforeEatingNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isOneHourBeforeEatingNotificationGranted")
        }
    }
    private var isEatingTimeStartNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isEatingTimeStartNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isEatingTimeStartNotificationGranted")
        }
    }
    private var isOneHourBeforeFastingNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isOneHourBeforeFastingNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isOneHourBeforeFastingNotificationGranted")
        }
    }
    private var isFastingTimeStartNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isFastingTimeStartNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isFastingTimeStartNotificationGranted")
        }
    }
    private var isWaterReminderNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isWaterReminderNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isWaterReminderNotificationGranted")
        }
    }
    private var isChallengeUpdateNotificationGranted: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isChallengeUpdateNotificationGranted")
        } set {
            UserDefaults.standard.set(newValue, forKey: "isChallengeUpdateNotificationGranted")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        self.title = "Notifications center"
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        DispatchQueue.main.async { [self] in
            c.configureRectangle(rectangle: contentView)
            view.backgroundColor = Colors().contentViewBackgroundColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableHeaderView = UIView()
        tableView.sectionHeaderTopPadding = 0.0
        
        print(isOneHourBeforeEatingNotificationGranted)
        print(isEatingTimeStartNotificationGranted)
        print(isOneHourBeforeFastingNotificationGranted)
        print(isFastingTimeStartNotificationGranted)
        print(isWaterReminderNotificationGranted)
        print(isChallengeUpdateNotificationGranted)
    }
}

//MARK: - Extensions

extension NotificationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let switchView = UISwitch(frame: .zero)
        switchView.onTintColor = Colors().switchTintColor
        switchView.tag = indexPath.row
        switchView.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        cell.accessoryView = switchView
        
        var config = UIListContentConfiguration.cell()
        
        switch indexPath.row {
        case 0:
            config.text = "1 hour before eating"
            if isOneHourBeforeEatingNotificationGranted == true {
                switchView.setOn(true, animated: true)
            } else {
                switchView.setOn(false, animated: true)
            }
        case 1:
            config.text = "Eating time start"
            if isEatingTimeStartNotificationGranted == true {
                switchView.setOn(true, animated: true)
            } else {
                switchView.setOn(false, animated: true)
            }
        case 2:
            config.text = "1 hour before fasting"
            if isOneHourBeforeFastingNotificationGranted == true {
                switchView.setOn(true, animated: true)
            } else {
                switchView.setOn(false, animated: true)
            }
        case 3:
            config.text = "Fast time start"
            if isFastingTimeStartNotificationGranted == true {
                switchView.setOn(true, animated: true)
            } else {
                switchView.setOn(false, animated: true)
            }
        case 4:
            config.text = "Water reminder"
            if isWaterReminderNotificationGranted == true {
                switchView.setOn(true, animated: true)
            } else {
                switchView.setOn(false, animated: true)
            }
        case 5:
            config.text = "Challenges reminder"
            if isChallengeUpdateNotificationGranted == true {
                switchView.setOn(true, animated: true)
            } else {
                switchView.setOn(false, animated: true)
            }
        default:
            config.text = "Additional cell which should not exist"
        }
        
        cell.contentConfiguration = config
        
        return cell
    }
    
    @objc func switchChanged(_ sender: UISwitch!) {
        let notifications = NotificationsCenter()
        switch sender.tag {
        case 0:
            if sender.isOn == true {
                isOneHourBeforeEatingNotificationGranted = true
                NotificationsCenter().sendOneHourBeforeEatingNotification()
            } else if sender.isOn == false {
                isOneHourBeforeEatingNotificationGranted = false
                notifications.center.removePendingNotificationRequests(withIdentifiers: ["oneHourBeforeEating"])
            }
        case 1:
            if sender.isOn == true {
                isEatingTimeStartNotificationGranted = true
                notifications.sendEatingTimeStartNotification()
            } else if sender.isOn == false {
                isEatingTimeStartNotificationGranted = false
                notifications.center.removePendingNotificationRequests(withIdentifiers: ["eatingTimeStart"])
            }
        case 2:
            if sender.isOn == true {
                isOneHourBeforeFastingNotificationGranted = true
                notifications.sendOneHourBeforeFastingNotification()
            } else if sender.isOn == false {
                isOneHourBeforeFastingNotificationGranted = false
                notifications.center.removePendingNotificationRequests(withIdentifiers: ["oneHourBeforeFasting"])
            }
        case 3:
            if sender.isOn == true {
                isFastingTimeStartNotificationGranted = true
                notifications.sendFastingTimeStartNotification()
            } else if sender.isOn == false {
                isFastingTimeStartNotificationGranted = false
                notifications.center.removePendingNotificationRequests(withIdentifiers: ["fastingTimeStart"])
            }
        case 4:
            if sender.isOn == true {
                isWaterReminderNotificationGranted = true
                notifications.sendWaterReminderNotification()
            } else if sender.isOn == false {
                isWaterReminderNotificationGranted = false
                notifications.center.removePendingNotificationRequests(withIdentifiers: ["waterReminder"])
            }
        case 5:
            print(sender.isOn)
            if sender.isOn == true {
                isChallengeUpdateNotificationGranted = true
            } else if sender.isOn == false {
                isChallengeUpdateNotificationGranted = false
                notifications.center.removePendingNotificationRequests(withIdentifiers: ["challenge1Update", "challenge2Update", "challenge3Update", "challenge4Update", "challenge5Update", "challenge6Update" ])
            }
        default:
            print("Additional tag which should not exist")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
}
