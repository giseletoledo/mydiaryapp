//
//  EntryType.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

// MARK: - ENUM para tipo de entrada
import SwiftUI

enum EntryType: String, Codable, CaseIterable {
    case text = "Texto"
    case audio = "Áudio"
    case mixed = "Misto"
    
    var icon: String {
        switch self {
        case .text: return "note.text"
        case .audio: return "mic.fill"
        case .mixed: return "waveform"
        }
    }
    
    var color: Color {
        switch self {
        case .text: return .blue
        case .audio: return .red
        case .mixed: return .purple
        }
    }
}
