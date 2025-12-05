//
//  AppButton.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 03/12/25.
//
import SwiftUI

// MARK: - AppButton
struct AppButton: View {
    enum Style {
        case primary, secondary, destructive
    }
    
    let title: String
    let icon: String?
    let style: Style
    let action: () -> Void
    var isEnabled: Bool = true
    
    init(
        _ title: String,
        icon: String? = nil,
        style: Style = .primary,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            buttonContent
                .modifier(ButtonStyleModifier(style: style, isEnabled: isEnabled))
        }
        .disabled(!isEnabled)
        .buttonStyle(ScaleButtonStyle())
    }
    
    private var buttonContent: some View {
        HStack(spacing: AppSpacing.xs) {
            if let icon = icon {
                Image(systemName: icon)
            }
            Text(title)
        }
    }
}


// MARK: - Button Styles

/// Estilo padrão de botão com efeito de escala
struct ScaleButtonStyle: ButtonStyle {
    let scale: CGFloat
    let duration: Double
    
    init(scale: CGFloat = 0.97, duration: Double = 0.1) {
        self.scale = scale
        self.duration = duration
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .animation(.easeInOut(duration: duration), value: configuration.isPressed)
    }
}

/// Estilo para botões que não devem ter efeito visual
struct NoEffectButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}


// MARK: - Button Style Modifier
struct ButtonStyleModifier: ViewModifier {
    let style: AppButton.Style
    let isEnabled: Bool
    
    func body(content: Content) -> some View {
        switch style {
        case .primary:
            content.primaryButton(isEnabled: isEnabled)
        case .secondary:
            content.secondaryButton()
        case .destructive:
            content.destructiveButton()
        }
    }
}
