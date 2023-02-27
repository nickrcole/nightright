//
//  Config.swift
//  Night Right
//
//  Created by Nicholas Cole on 2/7/23.
//

import Foundation
import SwiftUI

@MainActor class Config: ObservableObject {
    @Published var accentColor: Color = defaultColor
    @Published var snoreReduction: Bool = true
    @Published var snooze: Bool = true
    @Published var bedtimeNotifications: Bool = false
    @Published var alarm: Bool = false
    @Published var alarmTime: Date = createDate(date: "2023/01/17 08:30")
    @Published var bedtime: Date = createDate(date: "2022/1/12 23:00")
    @Published var triggerAlarm: Bool = false
    var notificationsAllowed: Bool = false
    enum Settings {
        case accentColor, snoreReduction, snooze, bedtimeNotifications, alarm, alarmTime, bedtime, triggerAlarm, notificationsAllowed
    }
    
    private func initialize() {
        if let data = UserDefaults.standard.data(forKey: "accentColor") {
//            if let decoded = JSONDecoder().decode(Color.self, from: data) {
//                self.accentColor = decoded
//            }
        }
    }
    
    func setVal(for setting: Settings, to: Any) {
        switch(setting) {
        case .accentColor:
            UserDefaults.standard.set(to, forKey: "accentColor")
        case .snoreReduction:
            UserDefaults.standard.set(to, forKey: "snoreReduction")
        case .snooze:
            UserDefaults.standard.set(to, forKey: "snooze")
        case .bedtimeNotifications:
            UserDefaults.standard.set(to, forKey: "bedtimeNotifications")
        case .alarm:
            UserDefaults.standard.set(to, forKey: "alarm")
        case .alarmTime:
            UserDefaults.standard.set(to, forKey: "alarmTime")
        case .bedtime:
            UserDefaults.standard.set(to, forKey: "bedtime")
        case .triggerAlarm:
            UserDefaults.standard.set(to, forKey: "triggerAlarm")
        case .notificationsAllowed:
            UserDefaults.standard.set(to, forKey: "notificationsAllowed")
        }
    }
}
