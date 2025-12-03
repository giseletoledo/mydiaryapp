//
//  DiaryListView.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftUI
import SwiftData

struct DiaryListView: View {
    @EnvironmentObject private var viewModel: DiaryViewModel
    
    var body: some View {
        List {
            // Estatísticas
            StatsView()
                .environmentObject(viewModel)
            
            // Entradas
            ForEach(viewModel.entries) { entry in
                EntryRowView(entry: entry)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deleteEntry(entry)
                        } label: {
                            Label("Excluir", systemImage: "trash")
                        }
                    }
            }
        }
        .listStyle(.plain)
    }
}
