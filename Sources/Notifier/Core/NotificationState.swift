//
//  NotificationState.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//


import Combine
#if os(iOS)
import CoreHaptics
import AVFoundation
#endif

/// Manages the notification queue and presentation state
public class NotificationState: ObservableObject {
    
    @Published internal var activeNotifications: [NotificationItem] = []
    @Published internal var queuedNotifications: [NotificationItem] = []
    
    internal let configuration: NotificationConfiguration
    private let maxConcurrent: Int
    private var dismissalTasks: [UUID: Task<Void, Never>] = [:]
    //private var dismissalTasks: [UUID: Task<Void, Never>] = [:]
    private var dismissalCallbacks: [UUID: () -> Void] = [:]
    
    #if os(iOS)
    private var hapticEngine: CHHapticEngine?
    private var audioPlayer: AVAudioPlayer?
    #endif
    
    init(configuration: NotificationConfiguration) {
        self.configuration = configuration
        self.maxConcurrent = configuration.maxConcurrentNotifications
        #if os(iOS)
        prepareHaptics()
        #endif
    }
    
    deinit {
        dismissalTasks.values.forEach { $0.cancel() }
        dismissalTasks.removeAll()
        #if os(iOS)
        hapticEngine?.stop()
        #endif
    }
    
    #if os(iOS)
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("Haptics engine error: \(error.localizedDescription)")
        }
    }
    #endif
    
    @MainActor
    internal func enqueue<N: NotificationContent>(
        _ notification: N,
        method: NotificationMethod,
        onDismiss: (() -> Void)? = nil
    ) {
        let item = NotificationItem(
            content: AnyNotificationContent(notification),
            method: method
        )
        
        // Store dismissal callback if provided
        if let onDismiss = onDismiss {
            dismissalCallbacks[item.id] = onDismiss
        }
        
        // Trigger haptic feedback if specified
        #if os(iOS)
        if let haptic = notification.hapticFeedback {
            triggerHaptic(haptic)
        }
        
        // Play sound effect if specified
        if let sound = notification.soundEffect {
            playSound(sound)
        }
        #endif
        
        switch method.priority {
        case .immediate:
            // Clear queue and show immediately
            queuedNotifications.removeAll()
            activeNotifications.insert(item, at: 0)
            scheduleAutoDismiss(for: item)
            
        case .high:
            // Add to front of queue
            if activeNotifications.count < maxConcurrent {
                activeNotifications.insert(item, at: 0)
                scheduleAutoDismiss(for: item)
            } else {
                queuedNotifications.insert(item, at: 0)
            }
            
        case .normal:
            // Add to queue normally
            if activeNotifications.count < maxConcurrent {
                activeNotifications.append(item)
                scheduleAutoDismiss(for: item)
            } else {
                queuedNotifications.append(item)
            }
            
        case .low:
            // Add to end of queue
            queuedNotifications.append(item)
        }
        
        processQueue()
    }
    
    #if os(iOS)
    private func triggerHaptic(_ feedback: HapticFeedback) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics,
              let hapticEngine = hapticEngine else { return }

        let events: [CHHapticEvent]

        switch feedback {
        case .light:
            events = [CHHapticEvent(eventType: .hapticTransient,
                                    parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3),
                                                 CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)],
                                    relativeTime: 0)]
        case .medium:
            events = [CHHapticEvent(eventType: .hapticTransient,
                                    parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6),
                                                 CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)],
                                    relativeTime: 0)]
        case .heavy:
            events = [CHHapticEvent(eventType: .hapticTransient,
                                    parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                                                 CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)],
                                    relativeTime: 0)]
        case .success:
            events = [
                CHHapticEvent(eventType: .hapticTransient,
                              parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)],
                              relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient,
                              parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.4)],
                              relativeTime: 0.1)
            ]
        case .warning:
            events = [CHHapticEvent(eventType: .hapticContinuous,
                                    parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.6)],
                                    relativeTime: 0,
                                    duration: 0.4)]
        case .error:
            events = [
                CHHapticEvent(eventType: .hapticTransient,
                              parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)],
                              relativeTime: 0),
                CHHapticEvent(eventType: .hapticTransient,
                              parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.8)],
                              relativeTime: 0.15)
            ]
        case .selection:
            events = [CHHapticEvent(eventType: .hapticTransient,
                                    parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5),
                                                 CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)],
                                    relativeTime: 0)]
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: 0)
        } catch {
            print("Failed to play haptic: \(error.localizedDescription)")
        }
    }
    
    private func playSound(_ sound: NotificationSound) {
        switch sound {
        case .default:
            AudioServicesPlaySystemSound(1007) // Standard notification sound
        case .success:
            AudioServicesPlaySystemSound(1025)
        case .error:
            AudioServicesPlaySystemSound(1073)
        case .custom(let name):
            guard let url = Bundle.main.url(forResource: name, withExtension: "mp3")
                    ?? Bundle.main.url(forResource: name, withExtension: "wav") else { return }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Failed to play custom sound: \(error.localizedDescription)")
            }
        }
    }
    #endif
    
    @MainActor
    internal func dismissCurrent() {
        guard !activeNotifications.isEmpty else { return }
        dismiss(activeNotifications[0])
    }
    
    @MainActor
    internal func dismissAll() {
        dismissalTasks.values.forEach { $0.cancel() }
        dismissalTasks.removeAll()
        
        // Call all dismissal callbacks
        activeNotifications.forEach { item in
            dismissalCallbacks[item.id]?()
        }
        queuedNotifications.forEach { item in
            dismissalCallbacks[item.id]?()
        }
        dismissalCallbacks.removeAll()
        
        activeNotifications.removeAll()
        queuedNotifications.removeAll()
    }
    
    @MainActor
    internal func dismissSpecific(_ item: NotificationItem) {
        dismiss(item)
    }
    
    @MainActor
    private func dismiss(_ item: NotificationItem) {
        dismissalTasks[item.id]?.cancel()
        dismissalTasks.removeValue(forKey: item.id)
        
        // Call dismissal callback
        dismissalCallbacks[item.id]?()
        dismissalCallbacks.removeValue(forKey: item.id)
        
        activeNotifications.removeAll { $0.id == item.id }
        processQueue()
    }
    
    @MainActor
    private func scheduleAutoDismiss(for item: NotificationItem) {
        guard let duration = item.content.wrapped.duration, duration > 0 else { return }

        let task = Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            guard !Task.isCancelled else { return }
            dismiss(item)
        }
        dismissalTasks[item.id] = task
    }

    @MainActor
    private func processQueue() {
        while activeNotifications.count < maxConcurrent && !queuedNotifications.isEmpty {
            let item = queuedNotifications.removeFirst()
            activeNotifications.append(item)
            scheduleAutoDismiss(for: item)
        }
    }
}
