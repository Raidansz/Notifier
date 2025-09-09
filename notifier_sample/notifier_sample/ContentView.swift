//
//  ContentView.swift
//  notifier_sample
//
//  Created by Raidan on 2025. 09. 09..
//

import SwiftUI
import AVFoundation
import Notifier

struct ContentView: View {
    @Environment(\.notifier) var notifier
    @State private var showCustomNotification = false
    @MainActor @State private var progressValue = 0.0
    @State private var isUploading = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Basic Notifications Section
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Basic Notifications", systemImage: "bell")
                                .font(.headline)
                            
                            HStack(spacing: 12) {
                                Button("Info") {
                                    notifier.notify(
                                        title: "Information",
                                        message: "This is an informational message",
                                        style: .info
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("Success") {
                                    notifier.notify(
                                        title: "Success!",
                                        message: "Operation completed successfully",
                                        style: .success,
                                        duration: 4.0
                                    )
                                }
                                .buttonStyle(.bordered)
                                .tint(.green)
                                
                                Button("Warning") {
                                    notifier.notify(
                                        title: "Warning",
                                        message: "Please check your settings",
                                        style: .warning
                                    )
                                }
                                .buttonStyle(.bordered)
                                .tint(.orange)
                                
                                Button("Error") {
                                    notifier.notify(
                                        title: "Error",
                                        message: "Something went wrong",
                                        style: .error
                                    )
                                }
                                .buttonStyle(.bordered)
                                .tint(.red)
                            }
                        }
                    }
                    
                    // Positioning Section
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Positioning", systemImage: "square.stack.3d.up")
                                .font(.headline)
                            
                            HStack(spacing: 12) {
                                Button("Top Banner") {
                                    notifier.notify(
                                        NetworkNotification(message: "Connected to WiFi"),
                                        method: .banner(position: .topEdge)
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("Bottom Toast") {
                                    notifier.notify(
                                        SimpleNotification(
                                            title: nil,
                                            message: "Quick toast message",
                                            style: .info,
                                            duration: 2.0
                                        ),
                                        method: .toast(position: .bottomEdge)
                                    )
                                }
                                .buttonStyle(.bordered)
                                
                                Button("Center Alert") {
                                    notifier.notify(
                                        SimpleNotification(
                                            title: "Centered",
                                            message: "This appears in the center",
                                            style: .info,
                                            duration: 3.0
                                        ),
                                        method: .banner(position: .center)
                                    )
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }
                    
                    // Haptic Feedback Section
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Haptic Feedback", systemImage: "waveform")
                                .font(.headline)
                            
                            Text("Note: Haptics only work on physical iOS devices")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            VStack(spacing: 8) {
                                Button("Success with Haptic") {
                                    notifier.notify(HapticNotification(
                                        title: "Payment Successful",
                                        message: "Your payment has been processed",
                                        style: .success,
                                        haptic: .success
                                    ))
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity)
                                .tint(.green)
                                
                                Button("Error with Haptic") {
                                    notifier.notify(HapticNotification(
                                        title: "Payment Failed",
                                        message: "Please check your card details",
                                        style: .error,
                                        haptic: .error
                                    ))
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity)
                                .tint(.red)
                                
                                Button("Warning with Haptic") {
                                    notifier.notify(HapticNotification(
                                        title: "Low Battery",
                                        message: "10% battery remaining",
                                        style: .warning,
                                        haptic: .warning
                                    ))
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity)
                                .tint(.orange)
                                
                                Button("Light Touch") {
                                    notifier.notify(HapticNotification(
                                        title: "Item Added",
                                        message: "Added to your favorites",
                                        style: .info,
                                        haptic: .light
                                    ))
                                }
                                .buttonStyle(.bordered)
                                .frame(maxWidth: .infinity)
                                
                                Button("Heavy Impact") {
                                    notifier.notify(HapticNotification(
                                        title: "Achievement Unlocked!",
                                        message: "You've reached level 10",
                                        style: .custom(
                                            iconName: "star.fill",
                                            iconColor: .yellow,
                                            backgroundColor: Color(.systemBackground)
                                        ),
                                        haptic: .heavy
                                    ))
                                }
                                .buttonStyle(.bordered)
                                .frame(maxWidth: .infinity)
                                
                                Button("Selection Haptic") {
                                    notifier.notify(HapticNotification(
                                        title: "Option Selected",
                                        message: "Your choice has been saved",
                                        style: .info,
                                        haptic: .selection
                                    ))
                                }
                                .buttonStyle(.bordered)
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    
                    // Sound Notifications Section
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Sound Notifications", systemImage: "speaker.wave.2")
                                .font(.headline)
                            
                            VStack(spacing: 8) {
                                Button("Success Sound") {
                                    notifier.notify(SoundNotification(
                                        title: "Task Complete",
                                        message: "All items have been processed",
                                        style: .success,
                                        sound: .success
                                    ))
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity)
                                .tint(.green)
                                
                                Button("Error Sound") {
                                    notifier.notify(SoundNotification(
                                        title: "Operation Failed",
                                        message: "Unable to complete the request",
                                        style: .error,
                                        sound: .error
                                    ))
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity)
                                .tint(.red)
                                
                                Button("Default Sound") {
                                    notifier.notify(SoundNotification(
                                        title: "New Message",
                                        message: "You have a new notification",
                                        style: .info,
                                        sound: .default
                                    ))
                                }
                                .buttonStyle(.bordered)
                                .frame(maxWidth: .infinity)
                                
                                Button("Sound + Haptic Combo") {
                                    notifier.notify(ComboNotification(
                                        title: "🎉 Combo Alert!",
                                        message: "Both sound and haptic feedback",
                                        style: .custom(
                                            iconName: "sparkles",
                                            iconColor: .purple,
                                            backgroundColor: Color(.systemBackground)
                                        ),
                                        haptic: .medium,
                                        sound: .success
                                    ))
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity)
                                .tint(.purple)
                            }
                        }
                    }
                    
                    // Custom Banners Section
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Custom Banners", systemImage: "rectangle.stack")
                                .font(.headline)
                            
                            VStack(spacing: 8) {
                                Button("Message Banner") {
                                    notifier.notify(CustomBanner(
                                        title: "New Message",
                                        subtitle: "You have a message from Sarah",
                                        imageURL: nil,
                                        iconName: "message.fill"
                                    ))
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity)
                                
                                Button("Product Banner") {
                                    notifier.notify(InteractiveBanner(
                                        product: .init(
                                            name: "AirPods Pro",
                                            price: 249.99,
                                            image: "airpodspro"
                                        )
                                    ))
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity)
                                
                                Button("Animated Offer") {
                                    notifier.notify(AnimatedBanner())
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity)
                                
                                Button("System Update") {
                                    notifier.notify(FullWidthBanner(
                                        systemUpdate: .init(
                                            version: "2.0.1",
                                            features: [
                                                "Bug fixes and stability improvements",
                                                "Enhanced performance",
                                                "New dark mode support"
                                            ]
                                        )
                                    ))
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity)
                                
                                Button("Achievement") {
                                    notifier.notify(AchievementNotification(
                                        achievement: "Master Explorer",
                                        points: 500
                                    ))
                                }
                                .buttonStyle(.borderedProminent)
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    
                    // Interactive Notifications Section
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Interactive Notifications", systemImage: "hand.tap")
                                .font(.headline)
                            
                            Button("Action Required") {
                                notifier.notify(
                                    ActionNotification(
                                        title: "Delete Item?",
                                        message: "This action cannot be undone",
                                        primaryAction: {
                                            notifier.notify(
                                                message: "Item deleted",
                                                style: .success
                                            )
                                        },
                                        secondaryAction: {
                                            print("Cancelled")
                                        }
                                    )
                                )
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Button("Show Progress") {
                                isUploading = true
                                progressValue = 0.0
                                startProgressSimulation()
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Button("User Profile") {
                                notifier.notify(UserNotification(
                                    userName: "John Doe",
                                    userImage: "person.circle.fill",
                                    action: "just logged in"
                                ))
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Button("Download Complete") {
                                notifier.notify(DownloadNotification(
                                    fileName: "Document.pdf",
                                    fileSize: "2.4 MB",
                                    onOpen: {
                                        print("Opening file...")
                                        notifier.dismiss()
                                    }
                                ))
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    
                    // Swipe Control Section
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Swipe Controls", systemImage: "hand.draw")
                                .font(.headline)
                            
                            Button("Swipeable Notification") {
                                notifier.notify(SwipeableNotification(
                                    message: "Swipe me left or right to dismiss",
                                    canSwipe: true
                                ))
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(maxWidth: .infinity)
                            
                            Button("Non-Swipeable (Important)") {
                                notifier.notify(SwipeableNotification(
                                    message: "This notification cannot be swiped away",
                                    canSwipe: false
                                ))
                            }
                            .buttonStyle(.borderedProminent)
                            .frame(maxWidth: .infinity)
                            .tint(.orange)
                        }
                    }
                    
                    // Priority & Queue Management
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Priority & Queue", systemImage: "list.number")
                                .font(.headline)
                            
                            Button("Queue Multiple") {
                                notifier.notify(
                                    message: "First notification",
                                    style: .info,
                                    duration: 2.0
                                )
                                notifier.notify(
                                    message: "Second notification",
                                    style: .success,
                                    duration: 2.0
                                )
                                notifier.notify(
                                    message: "Third notification",
                                    style: .warning,
                                    duration: 2.0
                                )
                            }
                            .buttonStyle(.bordered)
                            
                            Button("High Priority") {
                                notifier.notify(
                                    message: "Regular priority",
                                    style: .info
                                )
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    notifier.notify(
                                        ImportantNotification(
                                            message: "⚡ High Priority Message"
                                        ),
                                        method: .custom(priority: .high)
                                    )
                                }
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Immediate (Clears Queue)") {
                                for i in 1...3 {
                                    notifier.notify(
                                        message: "Queued message \(i)",
                                        style: .info
                                    )
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    notifier.notify(
                                        CriticalNotification(
                                            message: "🚨 Critical: Queue cleared!"
                                        ),
                                        method: .custom(priority: .immediate)
                                    )
                                }
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                        }
                    }
                    
                    // Control Section
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Controls", systemImage: "slider.horizontal.3")
                                .font(.headline)
                            
                            HStack {
                                Button("Dismiss Current") {
                                    notifier.dismiss()
                                }
                                .buttonStyle(.bordered)
                                
                                Button("Dismiss All") {
                                    notifier.dismissAll()
                                }
                                .buttonStyle(.bordered)
                                .tint(.red)
                                
                                if notifier.isPresenting {
                                    Label("Active", systemImage: "circle.fill")
                                        .foregroundColor(.green)
                                        .font(.caption)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Notifier Demo")
        }
    }
    
    private func startProgressSimulation() {

        let token = ProgressToken(title: "Uploading file…")
        isUploading = true
        notifier.notify(ProgressNotification(token: token))
        Task {
            for i in 0...100 {
                try await Task.sleep(nanoseconds: 100_000_000)
                token.progress = Double(i) / 100.0
            }

            notifier.dismiss()

            notifier.notify(
                title: "Upload Complete",
                message: "File uploaded successfully",
                style: .success
            )
            isUploading = false
        }
    }
}

// MARK: - Sound Notifications

struct SoundNotification: NotificationContent {
    let id = UUID().uuidString
    let title: String
    let message: String
    let style: NotificationStyle
    let sound: NotificationSound
    
    var soundEffect: NotificationSound? { sound }
    var duration: TimeInterval? { 3.0 }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "speaker.wave.2.fill")
                .font(.title2)
                .foregroundColor(style.iconColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
        )
    }
}

struct ComboNotification: NotificationContent {
    let id = UUID().uuidString
    let title: String
    let message: String
    let style: NotificationStyle
    let haptic: HapticFeedback
    let sound: NotificationSound
    
    var hapticFeedback: HapticFeedback? { haptic }
    var soundEffect: NotificationSound? { sound }
    var duration: TimeInterval? { 3.0 }
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Image(systemName: "waveform")
                    .font(.title3)
                    .foregroundColor(style.iconColor)
                Image(systemName: "speaker.wave.2")
                    .font(.caption)
                    .foregroundColor(style.iconColor)
                    .offset(x: 12, y: -8)
            }
            .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
        )
    }
}

// MARK: - Existing Custom Notifications (keeping all your original ones)

struct CustomBanner: NotificationContent {
    let id = UUID().uuidString
    let title: String
    let subtitle: String
    let imageURL: String?
    let iconName: String
    
    var duration: TimeInterval? { 5.0 }
    var method: NotificationMethod { .banner(position: .topEdge) }
    
    var body: some View {
        HStack(spacing: 16) {
            if let imageURL = imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Image(systemName: iconName)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .frame(width: 60, height: 60)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
        )
    }
}

struct InteractiveBanner: NotificationContent {
    let id = UUID().uuidString
    let product: Product
    @State private var quantity = 1
    @Environment(\.notifier) private var notifier
    
    var duration: TimeInterval? { nil }
    var isSwipeToDismissEnabled: Bool { false }
    
    struct Product {
        let name: String
        let price: Double
        let image: String
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: product.image)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text(product.name)
                        .font(.headline)
                    Text("$\(product.price, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack {
                    Button("-") {
                        if quantity > 1 { quantity -= 1 }
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    
                    Text("\(quantity)")
                        .frame(minWidth: 30)
                    
                    Button("+") {
                        quantity += 1
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
            
            HStack {
                Button("Add to Cart") {
                    notifier.dismiss()
                    notifier.notify(
                        message: "Added \(quantity) items to cart",
                        style: .success
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Dismiss") {
                    notifier.dismiss()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(radius: 15)
        )
    }
}

struct AnimatedBanner: NotificationContent {
    let id = UUID().uuidString
    @State private var isAnimating = false
    
    var body: some View {
        HStack {
            Image(systemName: "bell.fill")
                .font(.title2)
                .foregroundColor(.yellow)
                .rotationEffect(.degrees(isAnimating ? 20 : -20))
                .animation(
                    .easeInOut(duration: 0.2)
                    .repeatForever(autoreverses: true),
                    value: isAnimating
                )
            
            Text("Special Offer!")
                .font(.headline)
            
            Spacer()
            
            Text("50% OFF")
                .font(.caption)
                .fontWeight(.bold)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(4)
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .foregroundColor(.white)
        .cornerRadius(12)
        .onAppear {
            isAnimating = true
        }
    }
}

struct FullWidthBanner: NotificationContent {
    let id = UUID().uuidString
    let systemUpdate: SystemUpdate
    @Environment(\.notifier) private var notifier
    
    struct SystemUpdate {
        let version: String
        let features: [String]
    }
    
    var duration: TimeInterval? { nil }
    var method: NotificationMethod { .banner(position: .topEdge) }
    var isSwipeToDismissEnabled: Bool { false }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("System Update Available", systemImage: "arrow.down.circle.fill")
                    .font(.headline)
                Spacer()
                Text("v\(systemUpdate.version)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                ForEach(systemUpdate.features, id: \.self) { feature in
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text(feature)
                            .font(.caption)
                    }
                }
            }
            
            HStack {
                Button("Update Now") {
                    notifier.dismiss()
                    notifier.notify(
                        message: "Update started...",
                        style: .info
                    )
                }
                .buttonStyle(.borderedProminent)
                
                Button("Later") {
                    notifier.dismiss()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

struct NetworkNotification: NotificationContent {
    let id = UUID().uuidString
    let message: String
    var duration: TimeInterval? { 2.0 }
    
    var body: some View {
        HStack {
            Image(systemName: "wifi")
                .foregroundColor(.green)
            Text(message)
                .font(.subheadline)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.green.opacity(0.1))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.green.opacity(0.3), lineWidth: 1)
        )
    }
}

struct UserNotification: NotificationContent {
    let id = UUID().uuidString
    let userName: String
    let userImage: String
    let action: String
    var duration: TimeInterval? { 4.0 }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: userImage)
                .font(.largeTitle)
                .foregroundColor(.blue)
            
            VStack(alignment: .leading) {
                Text(userName)
                    .font(.headline)
                Text(action)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("now")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
        )
    }
}

struct DownloadNotification: NotificationContent {
    let id = UUID().uuidString
    let fileName: String
    let fileSize: String
    let onOpen: () -> Void
    var duration: TimeInterval? { nil }
    var isSwipeToDismissEnabled: Bool { false }
    
    @Environment(\.notifier) private var notifier
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "arrow.down.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                VStack(alignment: .leading) {
                    Text("Download Complete")
                        .font(.headline)
                    Text("\(fileName) • \(fileSize)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Open") {
                    onOpen()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

struct ImportantNotification: NotificationContent {
    let id = UUID().uuidString
    let message: String
    var method: NotificationMethod { .custom(priority: .high) }
    var duration: TimeInterval? { 5.0 }
    
    var body: some View {
        Text(message)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct CriticalNotification: NotificationContent {
    let id = UUID().uuidString
    let message: String
    var method: NotificationMethod { .custom(priority: .immediate) }
    var duration: TimeInterval? { 5.0 }
    
    var body: some View {
        Text(message)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

// Haptic-enabled notification
struct HapticNotification: NotificationContent {
    let id = UUID().uuidString
    let title: String
    let message: String
    let style: NotificationStyle
    let haptic: HapticFeedback
    
    var hapticFeedback: HapticFeedback? { haptic }
    var duration: TimeInterval? { 3.0 }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: style.iconName)
                .font(.title2)
                .foregroundColor(style.iconColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
        )
    }
}

// Swipe control example
struct SwipeableNotification: NotificationContent {
    let id = UUID().uuidString
    let message: String
    let canSwipe: Bool
    
    var isSwipeToDismissEnabled: Bool { canSwipe }
    var duration: TimeInterval? { canSwipe ? 5.0 : nil }
    
    var body: some View {
        HStack {
            if !canSwipe {
                Image(systemName: "lock.fill")
                    .foregroundColor(.orange)
            }
            
            Text(message)
                .font(.subheadline)
            
            Spacer()
            
            if canSwipe {
                Image(systemName: "hand.point.left.fill")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(canSwipe ? Color(.systemBackground) : Color.orange.opacity(0.1))
                .shadow(radius: 5)
        )
    }
}

// Game achievement with heavy haptic
struct AchievementNotification: NotificationContent {
    let id = UUID().uuidString
    let achievement: String
    let points: Int
    
    var hapticFeedback: HapticFeedback? { .heavy }
    var duration: TimeInterval? { 4.0 }
    
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "trophy.fill")
                .font(.largeTitle)
                .foregroundColor(.yellow)
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        scale = 1.0
                    }
                }
            
            Text(achievement)
                .font(.headline)
            
            Text("+\(points) XP")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
    }
}

#Preview {
    ContentView()
}


// MARK: - Example Custom Notifications

/// Example: Action notification with buttons
public struct ActionNotification: NotificationContent {
    public let id = UUID().uuidString
    public let title: String
    public let message: String
    public let primaryActionLabel: String
    public let secondaryActionLabel: String?
    public let primaryAction: () -> Void
    public let secondaryAction: (() -> Void)?
    
    public var duration: TimeInterval? { nil } // Manual dismiss only
    public var isSwipeToDismissEnabled: Bool { false } // Disable swipe for action notifications
    
    public init(
        title: String,
        message: String,
        primaryActionLabel: String = "Confirm",
        secondaryActionLabel: String? = "Cancel",
        primaryAction: @escaping () -> Void,
        secondaryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryActionLabel = primaryActionLabel
        self.secondaryActionLabel = secondaryActionLabel
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
    
    public var body: some View {
        ActionNotificationView(notification: self)
    }
}

private struct ActionNotificationView: View {
    let notification: ActionNotification
    @Environment(\.notifier) private var notifier
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.headline)
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                if let secondaryActionLabel = notification.secondaryActionLabel {
                    Button(secondaryActionLabel) {
                        notification.secondaryAction?()
                        notifier.dismiss()
                    }
                    .buttonStyle(.bordered)
                }
                
                Button(notification.primaryActionLabel) {
                    notification.primaryAction()
                    notifier.dismiss()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}


/// Example: Loading notification
public struct LoadingNotification: NotificationContent {
    public let id = UUID().uuidString
    public let message: String
    
    public var duration: TimeInterval? { nil }
    public var isSwipeToDismissEnabled: Bool { false }
    
    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(0.8)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.primary)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

public final class ProgressToken: ObservableObject, Identifiable, @unchecked Sendable {
    public let id = UUID()
    @Published public var progress: Double = 0
    public let title: String

    public init(title: String, initial: Double = 0) {
        self.title = title
        self.progress = initial
    }
}

public struct ProgressNotification: NotificationContent {
    @ObservedObject public var token: ProgressToken

    // Keep the same identity across updates
    public var id: String { token.id.uuidString }
    public var duration: TimeInterval? { nil }
    public var isSwipeToDismissEnabled: Bool { false }

    public init(token: ProgressToken) { self.token = token }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(token.title).font(.subheadline)

            // Only this re-renders when token.progress changes
            ProgressView(value: token.progress)
                .progressViewStyle(.linear)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 5)
    }
}

extension ProgressNotification: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.token.id == rhs.token.id  // ignore progress for equality
    }
}
