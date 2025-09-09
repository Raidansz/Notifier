//
//  View+notificationContainer.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import SwiftUI

extension View {
    /// Install the notification container at the root of your app
    public func notificationContainer(_ notifier: Notifier = Notifier()) -> some View {
        self.modifier(NotificationContainer(notifier: notifier))
    }
    
    /// Trigger notification on binding change
    public func notify<N: NotificationContent>(on trigger: Binding<Bool>, notification: N) -> some View {
        self.onChange(of: trigger.wrappedValue) { _, newValue in
            if newValue {
                trigger.wrappedValue = false
                @Environment(\.notifier) var notifier
                notifier.notify(notification)
            }
        }
    }
}
