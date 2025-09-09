//
//  NotificationStackView.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import SwiftUI

struct NotificationStackView: View {
    let notifications: [NotificationItem]
    let spacing: CGFloat
    let notifier: Notifier
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(notifications) { item in
                NotificationWrapper(item: item, notifier: notifier)
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
        }
        .padding()
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: notifications.map(\.id))
    }
}
