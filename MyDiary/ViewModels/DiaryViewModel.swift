//
//  DiaryViewModel.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//
import SwiftUI
import SwiftData
import Combine 

@MainActor
class DiaryViewModel: ObservableObject {
    @Published var entries: [DiaryEntry] = []
    @Published var selectedEntry: DiaryEntry?
    @Published var showAddSheet = false
    @Published var selectedEntryType: EntryType = .text
    
    private var modelContext: ModelContext?
    
    // Setup
    func setupContext(_ context: ModelContext) {
        self.modelContext = context
        loadEntries()
    }
    
    // Carregar
    func loadEntries() {
        guard let context = modelContext else { return }
        
        do {
            let descriptor = FetchDescriptor<DiaryEntry>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            entries = try context.fetch(descriptor)
        } catch {
            print("Erro ao carregar: \(error)")
            entries = []
        }
    }
    
    // Adicionar
    func addEntry(
        text: String,
        audioFileName: String? = nil,
        date: Date = Date(),
        imageData: Data? = nil
    ) {
        guard let context = modelContext else { return }

        let entry = DiaryEntry(
            text: text,
            audioFileName: audioFileName,
            date: date,
            imageData: imageData
        )

        context.insert(entry)
        saveContext()
        loadEntries()
    }

    
    // Deletar
    func deleteEntry(_ entry: DiaryEntry) {
        guard let context = modelContext else { return }
        
        // Remove audio
        if let audioFile = entry.audioFileName {
            AudioManager.shared.deleteAudioFile(named: audioFile)
        }
        
        context.delete(entry)
        saveContext()
        loadEntries()
    }
    
    // Selecionar tipo
    func selectEntryType(_ type: EntryType) {
        selectedEntryType = type
        showAddSheet = true
    }
    
    // Buscar
    func searchEntries(query: String) -> [DiaryEntry] {
        if query.isEmpty { return entries }
        return entries.filter { $0.text.localizedCaseInsensitiveContains(query) }
    }
    
    // Estatísticas
    func getStats() -> (text: Int, audio: Int, mixed: Int) {
        var stats = (0, 0, 0)
        
        for entry in entries {
            switch entry.entryType {
            case .text: stats.0 += 1
            case .audio: stats.1 += 1
            case .mixed: stats.2 += 1
            }
        }
        
        return stats
    }

    // Atualizar
    func updateEntry(
        _ entry: DiaryEntry,
        newText: String,
        newAudioFileName: String? = nil,
        newDate: Date? = nil,
        newImageData: Data? = nil
    ) {
        guard let context = modelContext else { return }
        
        // Atualiza os dados
        entry.text = newText
        entry.date = newDate ?? entry.date
        
        // Atualiza áudio se necessário
        if let newAudio = newAudioFileName {
            // Remove arquivo de áudio antigo se existir
            if let oldAudio = entry.audioFileName {
                AudioManager.shared.deleteAudioFile(named: oldAudio)
            }
            entry.audioFileName = newAudio
        }
        
        // Atualiza imagem
        entry.imageData = newImageData
        
        saveContext()
        loadEntries()
    }

    // Método auxiliar para verificar se é edição
    func isEditing(_ entry: DiaryEntry?) -> Bool {
        return entry != nil
    }
    
    // Salvar contexto
    private func saveContext() {
        guard let context = modelContext else { return }
        
        do {
            try context.save()
        } catch {
            print("Erro ao salvar: \(error)")
        }
    }
}
