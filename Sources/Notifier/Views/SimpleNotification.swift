//
//  SimpleNotification.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import SwiftUI

/// Built-in simple notification
public struct SimpleNotification: NotificationContent {
    public let id = UUID().uuidString
    public let title: String?
    public let message: String
    public let style: NotificationStyle
    public let duration: TimeInterval?
    
    public init(
        title: String? = nil,
        message: String,
        style: NotificationStyle = .info,
        duration: TimeInterval? = 3.0
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.duration = duration
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: style.iconName)
                .font(.system(size: 20))
                .foregroundColor(style.iconColor)
            
            // Content
            VStack(alignment: .leading, spacing: 2) {
                if let title = title {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                }
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(style.backgroundColor)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}
