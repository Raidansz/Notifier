//
//  NotificationConfiguration.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import Foundation

public struct NotificationConfiguration: @unchecked Sendable {
    public let maxConcurrentNotifications: Int
    public let defaultDuration: TimeInterval
    public let animationDuration: Double
    public let spacing: CGFloat
    
    public init(
        maxConcurrentNotifications: Int = 3,
        defaultDuration: TimeInterval = 3.0,
        animationDuration: Double = 0.3,
        spacing: CGFloat = 8
    ) {
        self.maxConcurrentNotifications = maxConcurrentNotifications
        self.defaultDuration = defaultDuration
        self.animationDuration = animationDuration
        self.spacing = spacing
    }
    
    public static let `default` = NotificationConfiguration()
}
