//
//  NotificationStyle.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import SwiftUI


public enum NotificationStyle {
    case info
    case success
    case warning
    case error
    case custom(iconName: String, iconColor: Color, backgroundColor: Color)
    
    var iconName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        case .custom(let icon, _, _): return icon
        }
    }
    
    var iconColor: Color {
        switch self {
        case .info: return .blue
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        case .custom(_, let color, _): return color
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .info: return Color(.systemBackground)
        case .success: return Color(.systemBackground)
        case .warning: return Color(.systemBackground)
        case .error: return Color(.systemBackground)
        case .custom(_, _, let bg): return bg
        }
    }
}
