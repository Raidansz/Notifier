//
//  NotificationItem.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import Foundation


struct NotificationItem: Identifiable, Equatable, @unchecked Sendable {
    let id = UUID()
    let content: AnyNotificationContent
    let method: NotificationMethod
    let timestamp = Date()
    
    static func == (lhs: NotificationItem, rhs: NotificationItem) -> Bool {
        lhs.id == rhs.id
    }
}
