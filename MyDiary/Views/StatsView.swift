//
//  StatsView.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftUI

struct StatsView: View {
    @EnvironmentObject private var viewModel: DiaryViewModel
    
    var body: some View {
        let stats = viewModel.getStats()
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Estatísticas")
                .font(.headline)
            
            HStack(spacing: 20) {
                StatItem(
                    count: stats.text,
                    label: "Textos",
                    color: .blue,
                    icon: "note.text"
                )
                
                StatItem(
                    count: stats.audio,
                    label: "Áudios",
                    color: .red,
                    icon: "mic.fill"
                )
                
                StatItem(
                    count: stats.mixed,
                    label: "Mistos",
                    color: .purple,
                    icon: "waveform"
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
        .padding(.horizontal)
    }
}

struct StatItem: View {
    let count: Int
    let label: String
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text("\(count)")
                    .font(.headline)
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}
