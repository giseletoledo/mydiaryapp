//
//  AudioPlayerView.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftUI

struct AudioPlayerView: View {
    let audioFileName: String
    
    @ObservedObject private var audioManager = AudioManager.shared
    @State private var waveAmplitudes: [CGFloat] = Array(repeating: 10, count: 20)
    
    var body: some View {
        VStack(spacing: 20) {
            // Visualizador de onda
            WaveformView(amplitudes: waveAmplitudes, isPlaying: audioManager.isPlaying)
                .frame(height: 80)
            
            // Botão play/pause
            Button {
                if audioManager.isPlaying {
                    audioManager.stopPlaying()
                } else {
                    _ = audioManager.playAudio(named: audioFileName)
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: audioManager.isPlaying ? [.red, .orange] : [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .shadow(
                            color: audioManager.isPlaying ? .red.opacity(0.3) : .blue.opacity(0.3),
                            radius: 10
                        )
                    
                    Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.title2)
                        .foregroundColor(.white)
                        .offset(x: audioManager.isPlaying ? 0 : 2)
                }
            }
            .scaleEffect(audioManager.isPlaying ? 1.05 : 1.0)
            .animation(.spring(response: 0.3), value: audioManager.isPlaying)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8)
        )
        .onAppear {
            startWaveAnimation()
        }
        .onDisappear {
            if audioManager.isPlaying {
                audioManager.stopPlaying()
            }
        }
    }
    
    private func startWaveAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if audioManager.isPlaying {
                withAnimation(.linear(duration: 0.1)) {
                    waveAmplitudes = waveAmplitudes.map { _ in
                        CGFloat.random(in: 10...35)
                    }
                }
            } else {
                withAnimation(.linear(duration: 0.2)) {
                    waveAmplitudes = waveAmplitudes.map { _ in 10 }
                }
            }
        }
    }
}
