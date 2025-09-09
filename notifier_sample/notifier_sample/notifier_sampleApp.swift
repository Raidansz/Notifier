//
//  notifier_sampleApp.swift
//  notifier_sample
//
//  Created by Raidan on 2025. 09. 09..
//

import SwiftUI
import Notifier

@main
struct notifier_sampleApp: App {
    let notifier = Notifier(
        configuration: NotificationConfiguration(
            maxConcurrentNotifications: 3,
            defaultDuration: 3.0,
            animationDuration: 0.3,
            spacing: 8
        )
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .notificationContainer(notifier)
        }
    }
}
