//
//  AppShadows.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 03/12/25.

import SwiftUI

// MARK: - Shadow Model
struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - App Shadows
struct AppShadow {
    static let light = Shadow(
        color: AppColors.shadowLight,
        radius: 3,
        x: 0,
        y: 2
    )
    
    static let medium = Shadow(
        color: AppColors.shadowMedium,
        radius: 5,
        x: 0,
        y: 3
    )
    
    static let heavy = Shadow(
        color: AppColors.shadowMedium,
        radius: 10,
        x: 0,
        y: 5
    )
}

// MARK: - View Extension para aplicar shadows
extension View {
    func applyShadow(_ shadow: Shadow) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}
