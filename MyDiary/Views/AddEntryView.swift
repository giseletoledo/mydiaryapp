//
//  AddEntryView.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//
import SwiftUI
import PhotosUI

struct AddEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: DiaryViewModel
    
    let entryType: EntryType
    
    @State private var text = ""
    @State private var isRecording = false
    @State private var audioFileName: String?
    @State private var showPermissionAlert = false
    @State private var recordingTime = 0
    @State private var timer: Timer?
    @State private var waveAmplitudes: [CGFloat] = Array(repeating: 5, count: 15)
    
    @State private var selectedDate = Date()
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header com título
                VStack(spacing: 10) {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 30)
                .padding(.bottom, 20)
                
                // Conteúdo principal
                ScrollView {
                    VStack(spacing: 30) {
                        DatePicker(
                                "Data da entrada",
                                selection: $selectedDate,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.compact)
                            .padding(.horizontal)
                        if entryType == .text {
                            textEntryView
                        } else {
                            audioEntryView
                        }
                    }
                    .padding()
                }
                
                // Botões de ação
                actionButtons
                    .padding()
                    .background(
                        Rectangle()
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: -5, y: -5)
                    )
            }
            .background(Color(.systemGray6))
            .navigationBarHidden(true)
            .alert("Permissão necessária", isPresented: $showPermissionAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Precisamos de acesso ao microfone para gravar áudio.")
            }
        }
    }
    
    // MARK: - Views
    private var textEntryView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Sua nota", systemImage: "note.text")
                .font(.headline)
                .foregroundColor(.blue)
            
            TextEditor(text: $text)
                .frame(height: 200)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 5, y: 3)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
            // Pré-visualização da imagem, se tiver
            if let data = selectedImageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 160)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .clipped()
            }

            // Botão para escolher foto
            PhotosPicker(
                selection: $selectedPhotoItem,
                matching: .images
            ) {
                Label("Adicionar imagem", systemImage: "photo.on.rectangle")
                    .font(.subheadline)
            }
            .buttonStyle(.bordered)
            .tint(.blue)
            .padding(.top, 8)

            .onChange(of: selectedPhotoItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }

        }
    }
    
    private var audioEntryView: some View {
        VStack(spacing: 30) {
            // Visualizador de gravação
            VStack(spacing: 20) {
                // Indicador de status
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
                    
                    // Timer
                    Text(formatTime(recordingTime))
                        .font(.title3.monospacedDigit())
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                }
                
                // Visualizador de onda
                WaveformView(amplitudes: waveAmplitudes, isPlaying: isRecording)
                    .frame(height: 100)
                    .onChange(of: isRecording) { oldValue, newValue in
                        if newValue {
                            startWaveAnimation()
                        }
                    }
                
                // Botão de gravação principal
                Button {
                    toggleRecording()
                } label: {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: isRecording ?
                                        [.red, .orange] :
                                        [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                            .shadow(
                                color: isRecording ?
                                    .red.opacity(0.4) :
                                    .blue.opacity(0.4),
                                radius: 15,
                                y: 5
                            )
                            .scaleEffect(isRecording ? 1.05 : 1.0)
                            .animation(.spring(), value: isRecording)
                        
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(ScaleButtonStyle())
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            )
            
            // Campo de nota opcional
            VStack(alignment: .leading, spacing: 12) {
                Label("Nota (opcional)", systemImage: "text.append")
                    .font(.headline)
                    .foregroundColor(.purple)
                
                TextField("Adicione uma nota à gravação...", text: $text)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray5))
                    )
            }
        }
    }
    
    private var actionButtons: some View {
        HStack(spacing: 20) {
            // Botão cancelar
            Button {
                cancelRecording()
                dismiss()
            } label: {
                Text("Cancelar")
                    .font(.headline)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Capsule()
                            .fill(Color.red.opacity(0.1))
                    )
            }
            
            // Botão salvar
            Button {
                saveEntry()
            } label: {
                Text("Salvar")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        Capsule()
                            .fill(canSave ? Color.blue.gradient : Color.gray.gradient)
                    )
            }
            .disabled(!canSave)
        }
    }
    
    // MARK: - Computed Properties
    private var title: String {
        switch entryType {
        case .text: return "Nova Nota"
        case .audio: return "Gravação de Áudio"
        case .mixed: return "Gravação com Nota"
        }
    }
    
    private var subtitle: String {
        switch entryType {
        case .text: return "Escreva o que quiser lembrar"
        case .audio: return "Grave seus pensamentos em voz alta"
        case .mixed: return "Combine áudio e texto"
        }
    }
    
    private var canSave: Bool {
        if entryType == .text {
            return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else {
            return audioFileName != nil || !text.isEmpty
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
            let hasPermission = await AudioManager.shared.requestPermission()
            
            if hasPermission {
                audioFileName = AudioManager.shared.startRecording()
                isRecording = true
                startTimer()
            } else {
                showPermissionAlert = true
            }
        }
    }
    
    private func stopRecording() {
        AudioManager.shared.stopRecording()
        isRecording = false
        stopTimer()
    }
    
    private func cancelRecording() {
        if isRecording {
            stopRecording()
        }
        if let fileName = audioFileName {
            AudioManager.shared.deleteAudioFile(named: fileName)
            audioFileName = nil
        }
    }
    
    private func saveEntry() {
        print("💾 Salvando entry - texto vazio? \(text.isEmpty), audioFileName: \(audioFileName ?? "nil")")

        viewModel.addEntry(
            text: text,
            audioFileName: audioFileName,
            date: selectedDate,
            imageData: selectedImageData
        )
        dismiss()
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
