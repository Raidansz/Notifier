//
//  AnyNotificationContent.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import SwiftUI

struct AnyNotificationContent: Equatable {
    let wrapped: any NotificationContent

    private let stableID: String

    @MainActor
    init<N: NotificationContent>(_ notification: N) {
        self.wrapped = notification
        self.stableID = notification.id
    }

    @MainActor @ViewBuilder
    func view() -> some View {
        AnyView(wrapped)
    }

    // No actor isolation here; compare the stored ID
    static func == (lhs: AnyNotificationContent, rhs: AnyNotificationContent) -> Bool {
        lhs.stableID == rhs.stableID
    }
}
