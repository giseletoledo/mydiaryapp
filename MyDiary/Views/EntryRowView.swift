//
//  EntryRowView.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftUI


struct EntryRowView: View {
    let entry: DiaryEntry
    @State private var showAudioPlayer = false
    @State private var pulseAnimation = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header com tipo e data
            HStack(alignment: .top) {
                // Badge do tipo com animação
                HStack(spacing: 6) {
                    Image(systemName: entry.entryType.icon)
                        .font(.caption)
                        .foregroundColor(.white)
                        .scaleEffect(pulseAnimation ? 1.2 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1)
                                .repeatForever(autoreverses: true)
                                .delay(Double.random(in: 0...0.5)),
                            value: pulseAnimation
                        )
                    
                    Text(entry.entryType.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(entry.entryType.color.gradient)
                        .shadow(color: entry.entryType.color.opacity(0.3), radius: 3, y: 2)
                )
                .onAppear {
                    pulseAnimation = true
                }
                
                Spacer()
                
                // Data com formatação melhor
                VStack(alignment: .trailing, spacing: 2) {
                    Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(entry.date.formatted(date: .omitted, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Conteúdo da nota
            if !entry.text.isEmpty {
                Text(entry.text)
                    .font(.body)
                    .lineSpacing(4)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6).gradient)
                            .shadow(color: .black.opacity(0.05), radius: 3, y: 2)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
            }
            
            // Player de áudio (se tiver)
            if entry.hasAudio {
                VStack(spacing: 12) {
                    // Botão para expandir/ocultar player
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showAudioPlayer.toggle()
                        }
                    } label: {
                        HStack {
                            Image(systemName: showAudioPlayer ? "chevron.up" : "chevron.down")
                                .font(.caption)
                                .foregroundColor(.blue)
                            
                            Text(showAudioPlayer ? "Ocultar player" : "Ouvir gravação")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Image(systemName: "speaker.wave.2")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .symbolEffect(.bounce, value: showAudioPlayer)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.blue.opacity(0.1))
                        )
                    }
                    .buttonStyle(ScaleButtonStyle())
                    
                    // Player expandido
                    if showAudioPlayer, let fileName = entry.audioFileName {
                        AudioPlayerView(audioFileName: fileName)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .padding(.top, 4)
            }
            
            // Divider
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 1)
                .padding(.top, 8)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
        )
        .padding(.horizontal, 12)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
