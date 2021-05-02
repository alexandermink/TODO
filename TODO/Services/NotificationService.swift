//
//  NotificationService.swift
//  TODO
//
//  Created by Vit K on 02.04.2021.
//  Copyright © 2021 Alexander Mink. All rights reserved.
//

import UIKit

class NotificationService {
    
    var dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
    }
    
    func makeNotificationContent(title: String) -> UNNotificationContent {
        Main.instance.notifBadgeCount += 1
        let content = UNMutableNotificationContent()
        content.title = title
        content.badge = NSNumber(value: Main.instance.notifBadgeCount)
        return content
    }

    func makeIntervalNotificationTrigger(double: Double) -> UNNotificationTrigger {
        let pickedTime = double // подставить выбранное в picker время
        let curentTime = Date().timeIntervalSince1970 // текущее время
        let interval = pickedTime - curentTime // интервал в секундах между выбранным и текущим
        Main.instance.notificationDateInterval = interval
        guard interval > 0 else {
            Main.instance.notificationDateInterval = 1
            return UNTimeIntervalNotificationTrigger(
                timeInterval: 1,
                repeats: false
            )
        }
        return UNTimeIntervalNotificationTrigger(
            timeInterval: interval,
            repeats: false
        )
    }

    func sendNotificationRequest(
        task: Task) -> String {
        
//        guard let identifier = task.notificationID else { return }
        let identifier = task.notificationID!
        let content = makeNotificationContent(title: task.name)
        let trigger = makeIntervalNotificationTrigger(double: dateFormatter.date(from: task.notificationDate ?? "")?.timeIntervalSince1970 ?? Date().timeIntervalSince1970+1000)
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        return identifier
    }
    
    func updateNotificationRequest(task: Task, notificationIdentifier: String) -> String {
        deleteNotificationRequest(notificationIdentifier: notificationIdentifier)
        return sendNotificationRequest(task: task)
    }
    
    func deleteNotificationRequest(notificationIdentifier: String) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
    }
}


