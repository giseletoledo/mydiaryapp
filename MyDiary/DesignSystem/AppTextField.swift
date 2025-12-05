//
//  AppTextField.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 03/12/25.

import SwiftUI
// MARK: - AppTextField
struct AppTextField: View {
    let placeholder: String
    @Binding var text: String
    var icon: String?
    
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(AppColors.secondaryText)
            }
            
            TextField(placeholder, text: $text)
        }
        .inputField()
    }
}
