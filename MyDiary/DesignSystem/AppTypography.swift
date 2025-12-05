//
//  AppTipography.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 03/12/25.
//
import SwiftUI
// MARK: - Typography
struct AppTypography {
    // Title
    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title = Font.title.weight(.bold)
    static let title2 = Font.title2.weight(.bold)
    static let title3 = Font.title3.weight(.semibold)
    
    // Body
    static let body = Font.body
    static let bodyBold = Font.body.weight(.semibold)
    static let callout = Font.callout
    
    // Small
    static let caption = Font.caption
    static let caption2 = Font.caption2
    
    // Special
    static let headline = Font.headline
    static let subheadline = Font.subheadline
    static let monospacedDigit = Font.title3.monospacedDigit()
}
