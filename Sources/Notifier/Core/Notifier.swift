// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI
import Combine
#if os(iOS)
import CoreHaptics
import AVFoundation
#endif

// MARK: - Core Notifier

/// Main entry point for the notification system
public struct Notifier: @unchecked Sendable {
    
    internal let state: NotificationState
    
    public init(configuration: NotificationConfiguration = .default) {
        self.state = NotificationState(configuration: configuration)
    }
    
    internal init(state: NotificationState) {
        self.state = state
    }
    
    // MARK: - Public API
    
    /// Show a notification with default presentation
    @MainActor
    public func notify<N: NotificationContent>(_ notification: N) {
        notify(notification, method: notification.method)
    }
    
    /// Show a notification with specific presentation method
    @MainActor
    public func notify<N: NotificationContent>(_ notification: N, method: NotificationMethod) {
        state.enqueue(notification, method: method)
    }
    
    /// Show a simple text notification
    @MainActor
    public func notify(
        title: String? = nil,
        message: String,
        style: NotificationStyle = .info,
        duration: TimeInterval = 3.0
    ) {
        let notification = SimpleNotification(
            title: title,
            message: message,
            style: style,
            duration: duration
        )
        notify(notification)
    }
    
    /// Show a notification with completion handler
    @MainActor
    public func notify<N: NotificationContent>(
        _ notification: N,
        method: NotificationMethod,
        onDismiss: @escaping () -> Void
    ) {
        state.enqueue(notification, method: method, onDismiss: onDismiss)
    }
    
    /// Dismiss current notification
    @MainActor
    public func dismiss() {
        state.dismissCurrent()
    }
    
    /// Dismiss all notifications
    @MainActor
    public func dismissAll() {
        state.dismissAll()
    }
    
    /// Dismiss a specific notification item
    @MainActor
    internal func dismissSpecific(_ item: NotificationItem) {
        state.dismissSpecific(item)
    }
    
    /// Check if notifications are currently showing
    public var isPresenting: Bool {
        !state.activeNotifications.isEmpty
    }
}

private struct NotifierKey: EnvironmentKey {
    static let defaultValue = Notifier()
}

extension EnvironmentValues {
    public var notifier: Notifier {
        get { self[NotifierKey.self] }
        set { self[NotifierKey.self] = newValue }
    }
}
