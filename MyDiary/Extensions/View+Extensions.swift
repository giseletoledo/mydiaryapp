//
//  View+Extensions.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftUI

// Extensions para iOS 17+
extension View {
    // Corner radius específico
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
    
    // Hide com animação
    @ViewBuilder
    func hidden(_ hide: Bool) -> some View {
        if hide {
            self.opacity(0)
        } else {
            self
        }
    }
    
    // Pulse animation
    func pulse(animate: Bool) -> some View {
        self.modifier(PulseModifier(animate: animate))
    }
    
    // Shake animation
    func shake(trigger: Bool) -> some View {
        self.modifier(ShakeEffect(animatableData: trigger ? 1 : 0))
    }
}

// MARK: - Modifiers
struct PulseModifier: ViewModifier {
    let animate: Bool
    @State private var scale: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(scale)
            .onChange(of: animate) { oldValue, newValue in
                if newValue {
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        scale = 1.1
                    }
                } else {
                    withAnimation {
                        scale = 1.0
                    }
                }
            }
    }
}

struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let offset = sin(animatableData * .pi * 4) * 5
        return ProjectionTransform(CGAffineTransform(translationX: offset, y: 0))
    }
}

// MARK: - Shapes
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
