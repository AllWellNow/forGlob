    
// Функция пересчитывает интервалы между текущим моментом и выбранными юзером часами и запускает таймер
private func setTimer() {
    // если таймер уже запущен - return
        if isTimerRunningNowOnMain == false {
            
            if let index = startingDate {
                // подсчет интервала до даты старта, выбранной юзером
                let difference = Calendar.current.dateComponents([.hour, .minute, .second], from: .now, to: index)
                if difference.hour != nil && difference.minute != nil && difference.second != nil {
                    let beforeStartInterval = (difference.hour! * 3600) + (difference.minute! * 60) + difference.second!
                    // если  интервал > 0 запустить таймер на него
                    if beforeStartInterval > 0 {
                            beforeStartDateTimer.startTimer(view: timerRectangle,
                                                            fastStatusView: fastingStatusView,
                                                            fastTimeView: fastingTimeView,
                                                            interval: TimeInterval(beforeStartInterval))
                            isTimerRunningNowOnMain = true
                            isFastingTimeNow = false
                            wasGoalStreakReached = false
                        // если дата старта прошла, подсчет основного интервала 
                    } else if beforeStartInterval <= 0 {
                        if let index = lastFastingHour {
                            let diff = Calendar.current.dateComponents([.hour, .minute, .second], from: .now, to: index)
                            if diff.hour != nil && diff.minute != nil && diff.second != nil {
                                let toLastFastHourInterval = (diff.hour! * 3600) + (diff.minute! * 60) + diff.second!
                                // если  интервал > 0 запустить таймер на него
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
                                    // если дата старта и основной интервал прошли, подсчет второго интервала
                                } else if beforeStartInterval <= 0 && toLastFastHourInterval <= 0 {
                                    if let index = firstFastingHour {
                                        let diff = Calendar.current.dateComponents([.hour, .minute, .second], from: .now, to: index)
                                        if diff.hour != nil && diff.minute != nil && diff.second != nil {
                                            let toFirstFastHourInterval = (diff.hour! * 3600) + (diff.minute! * 60) + diff.second!
                                            // если  интервал > 0 запустить таймер на него
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
                                                // если все даты прошли и интервалы <= 0, сбросить доп. параметры, добавить 1 день к интервалам (кроме первого интервала до даты старта)
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
                // если дата старта == nil, выводим плейсхолдер
            } else {
                fastingTimer.noTimer(view: timerRectangle, hView: fastingStatusView, pView: fastingTimeView)
                isFastingTimeNow = false
            }
        } else {return}
    }
    
// добавить 1 день к дате и лвл поинты
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
    
// проверить, работает ли таймер (для синхронизации таймеров на нескольких экранах)
    private func checkIfNeedToSetTimer() {
        if needToSetTimer == true {
            setTimer()
            needToSetTimer = false
        } else {
            return
        }
    }
    
   
