//
//  EntryRowView.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftUI

struct EntryRowView: View {
    @EnvironmentObject private var viewModel: DiaryViewModel
    
    let entry: DiaryEntry
    @State private var showAudioPlayer = false
    @State private var showEditSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(alignment: .top) {
                // Badge
                AppBadge(
                    text: entry.entryType.rawValue,
                    icon: entry.entryType.icon,
                    color: entry.entryType.foregroundColor
                )
                
                Spacer()
                
                // Data/Hora
                VStack(alignment: .trailing, spacing: 4) {
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText)
                    
                    Text(entry.date.formatted(date: .omitted, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(AppColors.tertiaryText)
                }
                
                // Botão editar
                Button {
                    showEditSheet = true
                } label: {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title2)
                        .foregroundColor(entry.entryType.foregroundColor)
                        .padding(.leading, 8)
                }
                .buttonStyle(.plain)
            }
            
            // Texto
            if !entry.text.isEmpty {
                Text(entry.text)
                    .font(.body)
                    .lineSpacing(4)
                    .foregroundColor(AppColors.primaryText)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(entry.entryType.backgroundColor)
                    .cornerRadius(10)
            }
            
            // Imagem
            if let data = entry.imageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .clipped()
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
            }
            
            // Áudio
            if entry.hasAudio {
                audioSection
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: AppColors.shadowLight, radius: 8, y: 2)
        )
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .sheet(isPresented: $showEditSheet) {
            AddEntryView(
                entryType: entry.entryType,
                entryToEdit: entry
            )
            .environmentObject(viewModel)
        }
    }
    
    // MARK: - Audio Section
    private var audioSection: some View {
        VStack(spacing: 12) {
            Button {
                withAnimation(.spring()) {
                    showAudioPlayer.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: showAudioPlayer ? "chevron.up.circle.fill" : "play.circle.fill")
                        .font(.title3)
                        .foregroundColor(entry.entryType.foregroundColor)
                    
                    Text(showAudioPlayer ? "Ocultar player" : "Ouvir gravação")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(entry.entryType.foregroundColor)
                    
                    Spacer()
                    
                    Image(systemName: "waveform")
                        .font(.caption)
                        .foregroundColor(entry.entryType.foregroundColor.opacity(0.7))
                        .symbolEffect(.bounce, value: showAudioPlayer)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(entry.entryType.backgroundColor)
                .cornerRadius(10)
            }
            .buttonStyle(PlainButtonStyle())
            
            if showAudioPlayer, let fileName = entry.audioFileName {
                AudioPlayerView(audioFileName: fileName)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}
