//
//  AppColors.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 03/12/25.
//

import SwiftUI

struct AppColors {
    // Primary Theme
    static let primary = Color(red: 0.2, green: 0.4, blue: 0.8) // Azul principal
    static let secondary = Color(red: 0.6, green: 0.3, blue: 0.9) // Lilás
    static let accent = Color(red: 0.9, green: 0.4, blue: 0.6) // Rosa
    
    // Entry Types - CORES DE FUNDO
    static let textEntry = Color(red: 0.85, green: 0.9, blue: 1.0) // Azul claro
    static let audioEntry = Color(red: 1.0, green: 0.9, blue: 0.95) // Rosa claro
    static let mixedEntry = Color(red: 0.95, green: 0.9, blue: 1.0) // Lilás claro
    
    // Entry Types - CORES DE TEXTO/ICONE
    static let textEntryDark = Color(red: 0.2, green: 0.4, blue: 0.8) // Azul escuro
    static let audioEntryDark = Color(red: 0.8, green: 0.3, blue: 0.6) // Rosa escuro
    static let mixedEntryDark = Color(red: 0.6, green: 0.3, blue: 0.8) // Lilás escuro
    
    // Backgrounds
    static let background = Color(red: 0.95, green: 0.96, blue: 0.98) // Cinza azulado claro
    static let secondaryBackground = Color(red: 0.98, green: 0.98, blue: 1.0) // Branco azulado
    static let cardBackground = Color.white
    
    // Text
    static let primaryText = Color(red: 0.1, green: 0.1, blue: 0.2) // Quase preto
    static let secondaryText = Color(red: 0.4, green: 0.4, blue: 0.5) // Cinza azulado
    static let tertiaryText = Color(red: 0.6, green: 0.6, blue: 0.7) // Cinza claro
    
    // Status
    static let success = Color(red: 0.2, green: 0.7, blue: 0.4) // Verde
    static let warning = Color(red: 1.0, green: 0.6, blue: 0.2) // Laranja
    static let error = Color(red: 1.0, green: 0.3, blue: 0.3) // Vermelho
    static let recording = Color(red: 1.0, green: 0.2, blue: 0.2) // Vermelho vivo
    
    // Overlays
    static let shadowLight = Color.black.opacity(0.05)
    static let shadowMedium = Color.black.opacity(0.1)
    static let overlay = Color.black.opacity(0.3)
}

// Extensão para EntryType
extension EntryType {
    var backgroundColor: Color {
        switch self {
        case .text:
            return AppColors.textEntry
        case .audio:
            return AppColors.audioEntry
        case .mixed:
            return AppColors.mixedEntry
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .text:
            return AppColors.textEntryDark
        case .audio:
            return AppColors.audioEntryDark
        case .mixed:
            return AppColors.mixedEntryDark
        }
    }
}
