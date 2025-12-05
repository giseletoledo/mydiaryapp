//
//  AppBadge.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 03/12/25.
//
import SwiftUI
// MARK: - AppBadge
struct AppBadge: View {
    let text: String
    let icon: String
    let color: Color
    @State private var pulse = false
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(AppTypography.caption)
                .scaleEffect(pulse ? 1.2 : 1.0)
            
            Text(text)
        }
        .badge(color: color)
        .onAppear {
            withAnimation(
                Animation.easeInOut(duration: 1)
                    .repeatForever(autoreverses: true)
            ) {
                pulse = true
            }
        }
    }
}
