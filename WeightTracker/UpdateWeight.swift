// Функция обновляет данные юзера, работает на нескольких экранах
private func updateWeight(_ newWeight: String) {
        if let newValue = Double(newWeight), let currentValue = Double(currentUserWeight ?? "NA") {
            // если новые данные больше текущих, проверить больше ли они изначальных
            if newValue > currentValue {
                if let startingWeight = Double(startingUserWeight ?? "NA") {
                  // если больше изначальных, сделать новые стартовыми
                    if newValue > startingWeight {
                        UserDefaults.standard.set(newValue.clean, forKey: "startingWeight")
                        startingWeightLabel.text = (startingUserWeight ?? "NA") + " kg"
                        weightTracker.calculateWeight()
                        weightTracker.updateWeight(goalProgressView, addLevelPointsTo: levelProgressView, newWeight: newWeight, progressLabel: toReachGoalLabel)
                        fillPercenageLabel()
                        UserDefaults.standard.set(newWeight, forKey: "currentWeight")
                      // если меньше изначальных, записать данные
                    } else if newValue < startingWeight {
                        weightTracker.updateWeight(goalProgressView, addLevelPointsTo: levelProgressView, newWeight: newWeight, progressLabel: toReachGoalLabel)
                        fillPercenageLabel()
                        UserDefaults.standard.set(newWeight, forKey: "currentWeight")
                    }
                }
              // если новые данные меньше текущих, записать данные
            } else if newValue < currentValue {
                weightTracker.updateWeight(goalProgressView, addLevelPointsTo: levelProgressView, newWeight: newWeight, progressLabel: toReachGoalLabel)
                fillPercenageLabel()
                UserDefaults.standard.set(newWeight, forKey: "currentWeight")
              // если данные равны - return
            } else if newValue == currentValue {
                return
            }
        }
    }
    
// Проверить, если данные были обновлены (для работы на нескольких экранах)
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
