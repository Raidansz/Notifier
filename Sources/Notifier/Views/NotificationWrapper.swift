//
//  NotificationWrapper.swift
//  Notifier
//
//  Created by Raidan on 2025. 09. 09..
//

import SwiftUI

struct NotificationWrapper: View {
    let item: NotificationItem
    let notifier: Notifier
    @State private var offset: CGFloat = 0
    @State private var isDragging = false
    
    private let dismissThreshold: CGFloat = 100
    
    var body: some View {
        item.content.view()
            .offset(x: offset)
            .opacity(min(1, max(0, 1 - (Double(abs(offset)) / 200))))
            .gesture(
                item.content.wrapped.isSwipeToDismissEnabled ?
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        offset = value.translation.width
                    }
                    .onEnded { value in
                        isDragging = false
                        if abs(value.translation.width) > dismissThreshold {
                            withAnimation(.easeOut(duration: 0.2)) {
                                offset = value.translation.width > 0 ? 500 : -500
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                notifier.dismissSpecific(item)
                            }
                        } else {
                            withAnimation(.spring()) {
                                offset = 0
                            }
                        }
                    }
                : nil
            )
            .animation(.spring(), value: offset)
    }
}
