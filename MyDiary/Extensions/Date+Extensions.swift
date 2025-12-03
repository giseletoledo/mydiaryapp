//
//  Date+Extensions.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftUI
import Foundation

// Extension para Date
extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: self)
    }
}

// Extension para View (animação simples)
extension View {
    func fadeIn() -> some View {
        self.modifier(FadeInModifier())
    }
}

struct FadeInModifier: ViewModifier {
    @State private var show = false
    
    func body(content: Content) -> some View {
        content
            .opacity(show ? 1 : 0)
            .animation(.easeIn(duration: 0.3), value: show)
            .onAppear { show = true }
    }
}
