// В данном файле я собрал ключевые функции через которые работает карусель итемов collectionView в tableView

// Итемы добавляются через модель
var viewModels: [ChallengesTableViewCellViewModel] = [
        ChallengesTableViewCellViewModel(viewModels: [
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().goVeganChallengeHeader, image: K().goVeganChallengeImage!, id: 1, isActive: false, isDone: false),
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().noSmokingChallengeHeader, image: K().noSmokingChallengeImage!, id: 2, isActive: false, isDone: false),
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().noCoffeeChallengeHeader, image: K().noCoffeeChallengeImage!, id: 3, isActive: false, isDone: false),
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().noAlcoholChallengeHeader, image: K().noAlcoholChallengeImage!, id: 4, isActive: false, isDone: false),
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().noFastFoodChallengeHeader, image: K().noFastFoodChallengeImage!, id: 5, isActive: false, isDone: false),
            ChallengesCollectionViewCellViewModel(challengeLabelText: K().noSugarChallengeHeader, image: K().noSugarChallengeImage!, id: 6, isActive: false, isDone: false)
        ])
    ]

// За прохождение испытаний (каждое испытание это один итем) предусмотрены лвл поинты, эта функция планирует их начисление в зависимости от даты конца челленджа, выбранной юзером
// При отмене прохождения date становится nil и функция не вызывается
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

// функция проверяет какое испытание было выбрано, передает данные в модель, отображает это в UI и планирует пуш если юзер их включил
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

// противоположная предыдущей функция, отменяет челлендж и пуш
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

// функция передает данные о выбранном испытании нужному экрану испытаний (оба есть в этом фолдере) и экран отображает соотвествующий контент
func itemWasTapped(with viewModel: ChallengesCollectionViewCellViewModel) {
        // если испытание уже активно, вызывается экран с таймером до окончания
        if activeChallenges.contains(viewModel.id) {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "challengeTimerController") as! ChallengeTimerViewController
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.challengeNumber = viewModel.id
            self.present(vc, animated: true, completion: nil)
         // если испытание не активно, вызывается экран с выбором интервала и кнопкой старт
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "challengeCardController") as! ChallengeCardViewController
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.challengeNumber = viewModel.id
            self.present(vc, animated: true, completion: nil)
        }
}

// на экране испытания функция ниже заполняет UI контентом в зависимости от выбранного челленджа
  private func fillChallengeContent() {
        if challengeNumber == 1 {
            if let p1 = challenge1Period {
                imageView.image = K().goVeganChallengeImage
                headerTextLabel.text = K().goVeganChallengeHeader
                paragraphTextLabel.text = K().goVeganChallengeDescriptionNotDone
                challengeTextLabel.text = K().challengeTimeLeftLabel
                challengesTimer.startTimer(view: timerView, numberOfDays: 2, targetDate: p1)
            }
        }
        if challengeNumber == 2 {
            if let p2 = challenge2Period {
                imageView.image = K().noSmokingChallengeImage
                headerTextLabel.text = K().noSmokingChallengeHeader
                paragraphTextLabel.text = K().noSmokingChallengeDescriptionNotDone
                challengeTextLabel.text = K().challengeTimeLeftLabel
                challengesTimer.startTimer(view: timerView, numberOfDays: 2, targetDate: p2)
            }
        }
        if challengeNumber == 3 {
            if let p3 = challenge3Period {
                imageView.image = K().noCoffeeChallengeImage
                headerTextLabel.text = K().noCoffeeChallengeHeader
                paragraphTextLabel.text = K().noCoffeeChallengeDecriptionNotDone
                challengeTextLabel.text = K().challengeTimeLeftLabel
                challengesTimer.startTimer(view: timerView, numberOfDays: 2, targetDate: p3)
            }
        }
        if challengeNumber == 4 {
            if let p4 = challenge4Period {
                imageView.image = K().noAlcoholChallengeImage
                headerTextLabel.text = K().noAlcoholChallengeHeader
                paragraphTextLabel.text = K().noAlcoholChallengeDescriptionNotDone
                challengeTextLabel.text = K().challengeTimeLeftLabel
                challengesTimer.startTimer(view: timerView, numberOfDays: 2, targetDate: p4)
            }
        }
        if challengeNumber == 5 {
            if let p5 = challenge5Period {
                imageView.image = K().noFastFoodChallengeImage
                headerTextLabel.text = K().noFastFoodChallengeHeader
                paragraphTextLabel.text = K().noFastFoodChalengeDescriptionNotDone
                challengeTextLabel.text = K().challengeTimeLeftLabel
                challengesTimer.startTimer(view: timerView, numberOfDays: 2, targetDate: p5)
            }
        }
        if challengeNumber == 6 {
            if let p6 = challenge6Period {
                imageView.image = K().noSugarChallengeImage
                headerTextLabel.text = K().noSugarChallengeHeader
                paragraphTextLabel.text = K().noSugarChallengeDescriptionNotDone
                challengeTextLabel.text = K().challengeTimeLeftLabel
                challengesTimer.startTimer(view: timerView, numberOfDays: 2, targetDate: p6)
            }
        }
    }
