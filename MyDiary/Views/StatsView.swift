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
        let total = stats.text + stats.audio + stats.mixed
        
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.headline)
                    .foregroundColor(AppColors.primary)
                
                Text("Estatísticas")
                    .font(.headline)
                    .foregroundColor(AppColors.primaryText)
                
                Spacer()
                
                Text("\(total) entradas")
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(AppColors.secondaryBackground)
                    )
            }
            
            HStack(spacing: 16) {
                StatItem(
                    count: stats.text,
                    label: "Textos",
                    entryType: .text,
                    total: total
                )
                
                StatItem(
                    count: stats.audio,
                    label: "Áudios",
                    entryType: .audio,
                    total: total
                )
                
                StatItem(
                    count: stats.mixed,
                    label: "Mistos",
                    entryType: .mixed,
                    total: total
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: AppColors.shadowLight, radius: 8, y: 2)
        )
        .padding(.horizontal, 16)
    }
}

struct StatItem: View {
    let count: Int
    let label: String
    let entryType: EntryType
    let total: Int
    
    private var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(count) / Double(total)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Icon and count with circular progress
            ZStack {
                // Background circle
                Circle()
                    .stroke(entryType.backgroundColor, lineWidth: 3)
                    .frame(width: 60, height: 60)
                
                // Progress circle
                Circle()
                    .trim(from: 0, to: percentage)
                    .stroke(
                        entryType.foregroundColor,
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: percentage)
                
                // Content
                VStack(spacing: 2) {
                    Image(systemName: entryType.icon)
                        .font(.caption)
                        .foregroundColor(entryType.foregroundColor)
                    
                    Text("\(count)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(entryType.foregroundColor)
                }
            }
            
            // Label
            Text(label)
                .font(.caption)
                .foregroundColor(AppColors.secondaryText)
            
            // Percentage
            Text("\(Int(percentage * 100))%")
                .font(.caption2)
                .foregroundColor(AppColors.tertiaryText)
        }
        .frame(maxWidth: .infinity)
    }
}
