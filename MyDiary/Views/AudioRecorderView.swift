//
//  AudioRecorderView.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftUI

struct AudioRecorderView: View {
    @ObservedObject private var audioManager = AudioManager.shared
    @Binding var audioFileName: String?
    @Binding var isRecording: Bool
    
    @State private var recordingTime = 0
    @State private var timer: Timer?
    @State private var waveAmplitudes: [CGFloat] = Array(repeating: 5, count: 15)
    @State private var showPermissionAlert = false
    
    var body: some View {
        VStack(spacing: 30) {
            // Status e Timer
            VStack(spacing: 20) {
                HStack {
                    Circle()
                        .fill(isRecording ? Color.red : Color.green)
                        .frame(width: 10, height: 10)
                        .scaleEffect(isRecording ? 1.5 : 1.0)
                        .animation(
                            isRecording ?
                                .easeInOut(duration: 0.5).repeatForever() :
                                .default,
                            value: isRecording
                        )
                    
                    Text(isRecording ? "GRAVANDO" : "PRONTO PARA GRAVAR")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(isRecording ? .red : .green)
                    
                    Spacer()
                    
                    Text(formatTime(recordingTime))
                        .font(.title3.monospacedDigit())
                        .fontWeight(.medium)
                }
                
                // Waveform
                WaveformView(amplitudes: waveAmplitudes, isPlaying: isRecording)
                    .frame(height: 100)
                
                // Botão de gravação
                Button {
                    toggleRecording()
                } label: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: isRecording ? [.red, .orange] : [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .shadow(
                                color: isRecording ? .red.opacity(0.4) : .blue.opacity(0.4),
                                radius: 15,
                                y: 5
                            )
                            .scaleEffect(isRecording ? 1.05 : 1.0)
                        
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .animation(.spring(), value: isRecording)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            )
        }
        .alert("Permissão necessária", isPresented: $showPermissionAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Precisamos de acesso ao microfone para gravar áudio.")
        }
        .onChange(of: isRecording) { _, newValue in
            if newValue {
                startWaveAnimation()
            }
        }
    }
    
    // MARK: - Actions
    private func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        Task {
            let hasPermission = await audioManager.requestPermission()
            
            if hasPermission {
                audioFileName = audioManager.startRecording()
                isRecording = true
                startTimer()
            } else {
                showPermissionAlert = true
            }
        }
    }
    
    private func stopRecording() {
        audioManager.stopRecording()
        isRecording = false
        stopTimer()
    }
    
    // MARK: - Timer
    private func startTimer() {
        recordingTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            recordingTime += 1
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func startWaveAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if isRecording {
                withAnimation(.linear(duration: 0.1)) {
                    waveAmplitudes = waveAmplitudes.map { _ in
                        CGFloat.random(in: 10...40)
                    }
                }
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
