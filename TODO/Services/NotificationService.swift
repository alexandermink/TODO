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
    
    func makeIntervalNotificationTrigger(pickedTime: Double) -> Double {
        return pickedTime - Date().timeIntervalSince1970
    }

    func sendNotificationRequest(
        task: Task) -> String {
        
        let identifier = UUID().uuidString
        let content = makeNotificationContent(title: task.name)
        let triggerInterval =  makeIntervalNotificationTrigger(pickedTime: dateFormatter.date(from: task.notificationDate ?? "")?.timeIntervalSince1970 ?? Date().timeIntervalSince1970)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerInterval, repeats: false)
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
    
    func updateNotificationRequest(task: Task) -> String {
        deleteNotificationRequest(task: task)
        return sendNotificationRequest(task: task)
    }
    
    func deleteNotificationRequest(task: Task) {
        Main.instance.notifBadgeCount -= 1
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [task.notificationID!])
    }
}


