//
//  NotificationContainer.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import SwiftUI

/// Root notification container view modifier
public struct NotificationContainer: ViewModifier {
    @StateObject private var state: NotificationState
    private let notifier: Notifier
    
    init(notifier: Notifier) {
        self.notifier = notifier
        self._state = StateObject(wrappedValue: notifier.state)
    }
    
    public func body(content: Content) -> some View {
        content
            .environment(\.notifier, notifier)
            .overlay(alignment: .top) {
                NotificationStackView(
                    notifications: state.activeNotifications.filter { item in
                        item.method.position == .topEdge
                    },
                    spacing: state.configuration.spacing,
                    notifier: notifier
                )
            }
            .overlay(alignment: .bottom) {
                NotificationStackView(
                    notifications: state.activeNotifications.filter { item in
                        item.method.position == .bottomEdge
                    },
                    spacing: state.configuration.spacing,
                    notifier: notifier
                )
            }
            .overlay(alignment: .center) {
                NotificationStackView(
                    notifications: state.activeNotifications.filter { item in
                        item.method.position == .center
                    },
                    spacing: state.configuration.spacing,
                    notifier: notifier
                )
            }
            .overlay {
                // Handle custom positions
                ForEach(state.activeNotifications.filter { item in
                    if case .custom = item.method.position { return true }
                    return false
                }) { item in
                    NotificationWrapper(item: item, notifier: notifier)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: item.method.position.alignment)
                        .padding()
                }
            }
    }
}
