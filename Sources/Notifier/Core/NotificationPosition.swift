//
//  NotificationPosition.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import SwiftUI

public enum NotificationPosition: Equatable {
    case topEdge
    case bottomEdge
    case center
    case custom(alignment: Alignment)
    
    var alignment: Alignment {
        switch self {
        case .topEdge:
            return .top
        case .bottomEdge:
            return .bottom
        case .center:
            return .center
        case .custom(let alignment):
            return alignment
        }
    }
    
    public static func == (lhs: NotificationPosition, rhs: NotificationPosition) -> Bool {
        switch (lhs, rhs) {
        case (.topEdge, .topEdge), (.bottomEdge, .bottomEdge), (.center, .center):
            return true
        case (.custom(let lhsAlignment), .custom(let rhsAlignment)):
            return lhsAlignment == rhsAlignment
        default:
            return false
        }
    }
}
