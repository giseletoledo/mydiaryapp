//
//  AppLoadingView.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 03/12/25.
//
import SwiftUI
// MARK: - AppLoadingView
struct AppLoadingView: View {
    var message: String = "Carregando..."
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: AppColors.primary))
                .scaleEffect(1.5)
            
            Text(message)
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.secondaryText)
        }
        .appCard()
    }
}
