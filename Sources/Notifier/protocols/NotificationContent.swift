//
//  NotificationContent.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import SwiftUI

/// Protocol for defining notification content
@MainActor
public protocol NotificationContent: Identifiable, View {
    var method: NotificationMethod { get }
    var duration: TimeInterval? { get }
    var style: NotificationStyle { get }
    var hapticFeedback: HapticFeedback? { get }
    var soundEffect: NotificationSound? { get }
    var isSwipeToDismissEnabled: Bool { get }
}

extension NotificationContent {
    public var id: String { UUID().uuidString }
    public var method: NotificationMethod { .banner() }
    public var duration: TimeInterval? { 3.0 }
    public var style: NotificationStyle { .info }
    public var hapticFeedback: HapticFeedback? { nil }
    public var soundEffect: NotificationSound? { nil }
    public var isSwipeToDismissEnabled: Bool { true }
}
