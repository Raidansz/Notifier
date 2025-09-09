# Notifier Framework Documentation

A SwiftUI in-app notification system, providing unified, customizable notifications with support for haptics, sounds, swipe gestures, and more to come.
<p align="center">
  <a href="https://github.com/user-attachments/assets/e94ea3e9-f5b7-4319-9ea5-ecbf624a2667">
    <img src="https://github.com/user-attachments/assets/e94ea3e9-f5b7-4319-9ea5-ecbf624a2667" alt="Upload Success" width="300">
  </a>
  &nbsp;&nbsp;
  <a href="https://github.com/user-attachments/assets/0eccd2b2-0f32-431a-ac2c-aaaf29957742">
    <img src="https://github.com/user-attachments/assets/0eccd2b2-0f32-431a-ac2c-aaaf29957742" alt="Uploading Progress" width="300">
  </a>
</p>

## Table of Contents
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Core Concepts](#core-concepts)
- [Basic Usage](#basic-usage)
- [Custom Notifications](#custom-notifications)
- [Advanced Features](#advanced-features)
- [API Reference](#api-reference)
- [Examples](#examples)

## Installation
Through SPM.


The framework is self-contained and doesn't require any external dependencies beyond SwiftUI.

## Quick Start

### 1. Set up the Notifier in your app

```swift
@main
struct MyApp: App {
    let notifier = Notifier()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .notificationContainer(notifier)
        }
    }
}
```

### 2. Use notifications in any view

```swift
struct ContentView: View {
    @Environment(\.notifier) var notifier
    
    var body: some View {
        Button("Show Notification") {
            notifier.notify(
                title: "Hello",
                message: "This is a notification",
                style: .success
            )
        }
    }
}
```

## Core Concepts

### Architecture

The framework follows a clean separation of concerns:

- **`Notifier`**: Public API struct for triggering notifications
- **`NotificationState`**: Manages queue and presentation state
- **`NotificationContent`**: Protocol for defining custom notifications
- **`NotificationMethod`**: Presentation style (banner, toast, alert)

### Queue Management

Notifications are managed through a priority queue system:
- **Immediate**: Clears queue and shows immediately
- **High**: Shows as soon as possible
- **Normal**: Standard queue behavior
- **Low**: Only shows when queue is empty

## Basic Usage

### Simple Text Notifications

```swift
// Basic notification
notifier.notify(
    message: "Operation complete",
    style: .success
)

// With title
notifier.notify(
    title: "Success",
    message: "File uploaded",
    style: .success,
    duration: 4.0
)
```

### Notification Styles

```swift
// Predefined styles
notifier.notify(message: "Info", style: .info)
notifier.notify(message: "Success", style: .success)
notifier.notify(message: "Warning", style: .warning)
notifier.notify(message: "Error", style: .error)

// Custom style
notifier.notify(
    message: "Custom",
    style: .custom(
        iconName: "star.fill",
        iconColor: .yellow,
        backgroundColor: .blue.opacity(0.1)
    )
)
```

### Positioning

```swift
// Top banner (default)
notifier.notify(
    SimpleNotification(message: "Top"),
    method: .banner(position: .topEdge)
)

// Bottom toast
notifier.notify(
    SimpleNotification(message: "Bottom"),
    method: .toast(position: .bottomEdge)
)

// Center
notifier.notify(
    SimpleNotification(message: "Center"),
    method: .banner(position: .center)
)
```

## Custom Notifications

### Creating Custom Notifications

Implement the `NotificationContent` protocol:

```swift
struct CustomNotification: NotificationContent {
    let id = UUID().uuidString
    let data: MyData
    
    // Optional overrides
    var duration: TimeInterval? { 5.0 }
    var hapticFeedback: HapticFeedback? { .light }
    var isSwipeToDismissEnabled: Bool { true }
    
    var body: some View {
        // Your custom view
        HStack {
            Image(systemName: "bell")
            Text(data.message)
        }
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
    }
}
```

### Interactive Notifications

```swift
struct InteractiveNotification: NotificationContent {
    let id = UUID().uuidString
    @Environment(\.notifier) var notifier
    
    var duration: TimeInterval? { nil } // Manual dismiss
    var isSwipeToDismissEnabled: Bool { false }
    
    var body: some View {
        VStack {
            Text("Confirm Action?")
            HStack {
                Button("Cancel") {
                    notifier.dismiss()
                }
                Button("Confirm") {
                    performAction()
                    notifier.dismiss()
                }
            }
        }
        .padding()
    }
}
```

## Advanced Features

### Haptic Feedback

Haptics work only on physical iOS devices:

```swift
struct HapticNotification: NotificationContent {
    var hapticFeedback: HapticFeedback? { .success }
    // ... rest of implementation
}

// Available haptic types:
// .light, .medium, .heavy
// .success, .warning, .error
// .selection
```

### Sound Effects

```swift
struct SoundNotification: NotificationContent {
    var soundEffect: NotificationSound? { .success }
    // ... rest of implementation
}

// To implement sounds, add to NotificationState.enqueue:
if let sound = notification.soundEffect {
    // Play system sound or custom audio
}
```

### Swipe to Dismiss

Control swipe behavior per notification:

```swift
struct SwipeableNotification: NotificationContent {
    var isSwipeToDismissEnabled: Bool { true }
    // Swipe left or right to dismiss
}

struct ImportantNotification: NotificationContent {
    var isSwipeToDismissEnabled: Bool { false }
    // Cannot be swiped away
}
```

### Priority Queue

```swift
// High priority - jumps queue
notifier.notify(
    MyNotification(),
    method: .custom(priority: .high)
)

// Immediate - clears queue
notifier.notify(
    CriticalNotification(),
    method: .custom(priority: .immediate)
)
```

### Progress Notifications

```swift
struct ProgressNotification: NotificationContent {
    let progress: Double
    var duration: TimeInterval? { nil }
    
    var body: some View {
        VStack {
            Text("Uploading...")
            ProgressView(value: progress)
        }
    }
}

// Update progress
Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
    progress += 0.1
    notifier.dismiss()
    notifier.notify(ProgressNotification(progress: progress))
    
    if progress >= 1.0 {
        timer.invalidate()
        notifier.notify(message: "Complete!", style: .success)
    }
}
```

## API Reference

### Notifier Methods

```swift
// Show notification with default method
func notify<N: NotificationContent>(_ notification: N)

// Show with specific method
func notify<N: NotificationContent>(_ notification: N, method: NotificationMethod)

// Simple text notification
func notify(
    title: String? = nil,
    message: String,
    style: NotificationStyle = .info,
    duration: TimeInterval = 3.0
)

// Dismiss current
func dismiss()

// Dismiss all
func dismissAll()

// Check if presenting
var isPresenting: Bool
```

### NotificationContent Protocol

```swift
protocol NotificationContent: Identifiable, View {
    var method: NotificationMethod { get }
    var duration: TimeInterval? { get }
    var style: NotificationStyle { get }
    var hapticFeedback: HapticFeedback? { get }
    var soundEffect: NotificationSound? { get }
    var isSwipeToDismissEnabled: Bool { get }
}
```

### Configuration

```swift
let notifier = Notifier(
    configuration: NotificationConfiguration(
        maxConcurrentNotifications: 3,
        defaultDuration: 3.0,
        animationDuration: 0.3,
        spacing: 8
    )
)
```

## Examples

### Action Confirmation

```swift
notifier.notify(
    ActionNotification(
        title: "Delete Item?",
        message: "This cannot be undone",
        primaryAction: {
            deleteItem()
            notifier.notify(message: "Deleted", style: .success)
        },
        secondaryAction: {
            // Cancel
        }
    )
)
```

### Download Complete

```swift
notifier.notify(
    DownloadNotification(
        fileName: "Report.pdf",
        fileSize: "2.4 MB",
        onOpen: {
            openFile()
            notifier.dismiss()
        }
    )
)
```

### Network Status

```swift
// Monitor network changes
notifier.notify(
    NetworkNotification(
        isConnected: true,
        networkType: "WiFi"
    )
)
```

## Troubleshooting

**Haptics not working**: Ensure testing on physical iOS device, not simulator

**Notifications not appearing**: Check that `.notificationContainer()` is applied at root level

**Swipe not working**: Verify `isSwipeToDismissEnabled` is true for the notification

**Queue overflow**: Adjust `maxConcurrentNotifications` in configuration



## Contributing

We welcome contributions to the Notifier framework! Whether you're fixing bugs, adding features, or improving documentation, your help makes this project better for everyone.

### Getting Started

1. **Fork** the repository on GitHub.
2. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name


3. **Make your changes** following the contribution guidelines.
4. **Test thoroughly** on both simulator and physical devices.
5. **Submit a pull request** with a clear and descriptive summary.
