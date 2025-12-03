//
//  ContentView.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = DiaryViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Lista ou estado vazio
                if viewModel.entries.isEmpty {
                    EmptyStateView()
                } else {
                    DiaryListView()
                        .environmentObject(viewModel)
                }
                
                // Menu flutuante
                FloatingMenuView()
                    .environmentObject(viewModel)
            }
            .navigationTitle("Meu Diário")
            .onAppear {
                viewModel.setupContext(modelContext)
            }
            .sheet(isPresented: $viewModel.showAddSheet) {
                AddEntryView(entryType: viewModel.selectedEntryType)
                    .environmentObject(viewModel)
            }
        }
    }
}

// Estado vazio
struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("Nenhuma entrada")
                .font(.title2)
                .foregroundColor(.secondary)
            
            Text("Toque no botão + para começar")
                .font(.body)
                .foregroundColor(.gray)
        }
    }
}
