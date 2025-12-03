//
//  DiaryIntents.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import AppIntents
import SwiftUI

// Intent para criar nota
struct CreateNoteIntent: AppIntent {
    static var title: LocalizedStringResource = "Criar nota no diário"
    static var description = IntentDescription("Adiciona uma nova nota ao seu diário")
    
    @Parameter(title: "Texto da nota")
    var text: String
    
    static var parameterSummary: some ParameterSummary {
        Summary("Criar nota: \(\.$text)")
    }
    
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        // Aqui você salvaria no banco de dados
        // Por enquanto apenas retornamos sucesso
        
        let result = "Nota criada: \(text.prefix(30))..."
        
        return .result(
            dialog: "Nota criada com sucesso!",
            view: Text(result)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
        )
    }
}

// Intent para gravar áudio
struct RecordAudioIntent: AppIntent {
    static var title: LocalizedStringResource = "Gravar áudio no diário"
    static var description = IntentDescription("Inicia uma gravação de áudio para o diário")
    
    @Parameter(title: "Duração máxima (segundos)", default: 60)
    var duration: TimeInterval
    
    static var parameterSummary: some ParameterSummary {
        Summary("Gravar áudio por \(\.$duration) segundos")
    }
    
    func perform() async throws -> some ProvidesDialog {
        // Em um app real, iniciaria a gravação
        print("Iniciando gravação de \(duration) segundos")
        
        return .result(
            dialog: "Gravação de áudio iniciada!"
        )
    }
}

// Registrar atalhos (versão atualizada)
struct DiaryShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CreateNoteIntent(),
            phrases: [
                "Criar uma nota no \(.applicationName)",
                "Adicionar ao diário \(.applicationName)",
                "Nova entrada no \(.applicationName)"
            ],
            shortTitle: "Nova Nota",
            systemImageName: "note.text"
        );
        AppShortcut(
            intent: RecordAudioIntent(),
            phrases: [
                "Gravar áudio no \(.applicationName)",
                "Nova gravação no \(.applicationName)"
            ],
            shortTitle: "Gravar Áudio",
            systemImageName: "mic.fill"
        )
    }
}
