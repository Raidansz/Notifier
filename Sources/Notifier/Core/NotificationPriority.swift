//
//  NotificationPriority.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//


public enum NotificationPriority: Int, Equatable {
    case immediate = 3  // Clears queue, shows immediately
    case high = 2       // Shows as soon as possible
    case normal = 1     // Normal queue behavior
    case low = 0        // Only shows when queue is empty
}