//
//  ViewModifiers.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 03/12/25.
//

import SwiftUI

// MARK: - Card Modifiers
extension View {
    func appCard() -> some View {
        self
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(AppColors.cardBackground)
                    .shadow(color: AppColors.shadowLight, radius: 5, y: 3)
            )
    }
    
    func appCardWithBorder(color: Color = .gray) -> some View {
        self
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(color.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: AppColors.shadowLight, radius: 3, y: 2)
    }
}

// MARK: - Button Modifiers
extension View {
    func primaryButton(isEnabled: Bool = true) -> some View {
        self
            .font(AppTypography.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.md)
            .background(
                Capsule()
                    .fill(isEnabled ? AppColors.primary.gradient : Color.gray.gradient)
            )
            .shadow(color: isEnabled ? AppColors.primary.opacity(0.3) : .clear, radius: 8, y: 4)
    }
    
    func secondaryButton() -> some View {
        self
            .font(AppTypography.headline)
            .foregroundColor(AppColors.primary)
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.md)
            .background(
                Capsule()
                    .fill(AppColors.primary.opacity(0.1))
            )
    }
    
    func destructiveButton() -> some View {
        self
            .font(AppTypography.headline)
            .foregroundColor(AppColors.error)
            .frame(maxWidth: .infinity)
            .padding(AppSpacing.md)
            .background(
                Capsule()
                    .fill(AppColors.error.opacity(0.1))
            )
    }
}

// MARK: - Badge Modifier
extension View {
    func badge(color: Color) -> some View {
        self
            .font(AppTypography.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(color.gradient)
                    .shadow(color: color.opacity(0.3), radius: 3, y: 2)
            )
    }
}

// MARK: - Text Container Modifier
extension View {
    func textContainer() -> some View {
        self
            .padding(AppSpacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.sm)
                    .fill(AppColors.secondaryBackground.gradient)
                    .shadow(color: AppColors.shadowLight, radius: 3, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.sm)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
    }
}

// MARK: - Input Field Modifier
extension View {
    func inputField() -> some View {
        self
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(AppColors.background)
                    .shadow(color: AppColors.shadowLight, radius: 5, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .stroke(AppColors.primary.opacity(0.2), lineWidth: 1)
            )
    }
}

// MARK: - Animation Modifiers
extension View {
    /// Animação de bounce (pulo)
    func bounce(trigger: Bool) -> some View {
        self.modifier(BounceEffect(trigger: trigger))
    }
    
    /// Fade in/out com duração customizável
    func fadeTransition(show: Bool, duration: Double = 0.3) -> some View {
        self.opacity(show ? 1 : 0)
            .animation(.easeInOut(duration: duration), value: show)
    }
}

// MARK: - Bounce Effect Modifier
struct BounceEffect: ViewModifier {
    let trigger: Bool
    @State private var offset: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .offset(y: offset)
            .onChange(of: trigger) { _, _ in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                    offset = -10
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        offset = 0
                    }
                }
            }
    }
}

// MARK: - iOS Native Style Modifiers
extension View {
    // MARK: - iOS Style Button
    func iosButton(style: AppButtonStyle = .primary, isEnabled: Bool = true) -> some View {  // Mude aqui
        self
            .font(AppTypography.headline)
            .foregroundColor(style.foregroundColor(isEnabled: isEnabled))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(style.backgroundColor(isEnabled: isEnabled))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style.borderColor(isEnabled: isEnabled), lineWidth: style.borderWidth)
            )
    }
    
    // MARK: - Small iOS Button
    func iosSmallButton(style: AppButtonStyle = .primary, isEnabled: Bool = true) -> some View {  // Mude aqui
        self
            .font(AppTypography.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(style.foregroundColor(isEnabled: isEnabled))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(style.backgroundColor(isEnabled: isEnabled))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style.borderColor(isEnabled: isEnabled), lineWidth: style.borderWidth)
            )
    }
    
    // MARK: - iOS Style Card
    func iosCard() -> some View {
        self
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.1), lineWidth: 1)
            )
    }
    
    // MARK: - iOS Style Input Field
    func iosInputField() -> some View {
        self
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColors.background)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
    }
    
    // MARK: - iOS Style Badge
    func iosBadge(color: Color) -> some View {
        self
            .font(AppTypography.caption2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(color)
            )
    }
}

// MARK: - Button Style Enum
enum AppButtonStyle {
    case primary
    case secondary
    case destructive
    case plain
    
    func backgroundColor(isEnabled: Bool = true) -> Color {
        if !isEnabled {
            return Color.gray.opacity(0.2)
        }
        
        switch self {
        case .primary:
            return AppColors.primary
        case .secondary:
            return AppColors.secondaryBackground
        case .destructive:
            return AppColors.error.opacity(0.1)
        case .plain:
            return Color.clear
        }
    }
    
    func foregroundColor(isEnabled: Bool = true) -> Color {
        if !isEnabled {
            return Color.gray
        }
        
        switch self {
        case .primary:
            return .white
        case .secondary:
            return AppColors.primary
        case .destructive:
            return AppColors.error
        case .plain:
            return AppColors.primary
        }
    }
    
    func borderColor(isEnabled: Bool = true) -> Color {
        if !isEnabled {
            return Color.gray.opacity(0.3)
        }
        
        switch self {
        case .primary, .destructive:
            return Color.clear
        case .secondary:
            return AppColors.primary.opacity(0.3)
        case .plain:
            return Color.clear
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .primary, .destructive, .plain:
            return 0
        case .secondary:
            return 1
        }
    }
}

// MARK: - Preview
#Preview {
    ScrollView {
        VStack(spacing: AppSpacing.xl) {
            // Cards
            Text("Card padrão")
                .appCard()
            
            Text("Card com borda")
                .appCardWithBorder(color: .blue)
            
            // Buttons
            Text("Primary")
                .primaryButton()
            
            Text("Secondary")
                .secondaryButton()
            
            Text("Destructive")
                .destructiveButton()
            
            // Badge
            Text("Badge")
                .badge(color: .blue)
            
            // Text Container
            Text("Container de texto")
                .textContainer()
        }
        .padding()
    }
    .background(AppColors.secondaryBackground)
}
