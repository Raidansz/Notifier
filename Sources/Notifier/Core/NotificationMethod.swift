//
//  NotificationMethod.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import Foundation

public enum NotificationMethod: Equatable {
    case banner(position: NotificationPosition = .topEdge, animation: NotificationAnimation = .slide)
    case toast(position: NotificationPosition = .bottomEdge)
    case alert
    case fullScreen
    case custom(priority: NotificationPriority = .normal)
    
    var priority: NotificationPriority {
        switch self {
        case .alert, .fullScreen:
            return .immediate
        case .banner:
            return .high
        case .toast:
            return .normal
        case .custom(let priority):
            return priority
        }
    }
    
    var position: NotificationPosition {
        switch self {
        case .banner(let position, _):
            return position
        case .toast(let position):
            return position
        case .alert, .fullScreen:
            return .center
        case .custom:
            return .topEdge
        }
    }
}
