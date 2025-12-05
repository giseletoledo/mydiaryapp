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
    let entryToEdit: DiaryEntry?
    
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
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header
                    headerView
                        .padding(.top, 24)
                        .padding(.bottom, 20)
                        .background(Color.white)
                    
                    // Content
                    ScrollView {
                        VStack(spacing: 20) {
                            // Date Picker
                            datePickerSection
                            
                            // Entry Content
                            if entryType == .text || entryType == .mixed {
                                textEntrySection
                            }
                            
                            if entryType == .audio || entryType == .mixed {
                                audioEntrySection
                            }
                        }
                        .padding(20)
                    }
                    
                    // Action Buttons
                    actionButtonsView
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                loadEntryDataIfEditing()
            }
            .alert("Permissão necessária", isPresented: $showPermissionAlert) {
                Button("Configurações") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancelar", role: .cancel) { }
            } message: {
                Text("Precisamos de acesso ao microfone para gravar áudio. Você pode ativar nas Configurações do iOS.")
            }
        }
    }
    
    // MARK: - Load Entry Data
    private func loadEntryDataIfEditing() {
        if let entry = entryToEdit {
            // Carrega os dados da entrada existente
            text = entry.text
            selectedDate = entry.date
            audioFileName = entry.audioFileName
            selectedImageData = entry.imageData
            
            // Se já tem áudio, desativa gravação
            if entry.hasAudio {
                isRecording = false
            }
        }
    }
    
    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 8) {
            HStack {
                Button {
                    cancelRecording()
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.body.weight(.medium))
                        .foregroundColor(AppColors.primary)
                }
                
                Spacer()
                
                AppBadge(
                    text: entryType.rawValue,
                    icon: entryType.icon,
                    color: entryType.color
                )
                
                Spacer()
                
                // Botão invisível para manter layout
                Image(systemName: "xmark")
                    .font(.body.weight(.medium))
                    .foregroundColor(.clear)
            }
            .padding(.horizontal, 20)
            
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundColor(.primary)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Date Picker Section
    private var datePickerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(AppColors.primary)
                Text("Data e Hora")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            DatePicker(
                "",
                selection: $selectedDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .tint(AppColors.primary)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
    }
    
    // MARK: - Text Entry Section
    private var textEntrySection: some View {
        VStack(spacing: 20) {
            // Text Editor
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "note.text")
                        .foregroundColor(AppColors.primary)
                    Text("Sua nota")
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                    Spacer()
                }
                
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("Digite sua nota aqui...")
                            .foregroundColor(.secondary.opacity(0.6))
                            .padding(.top, 8)
                            .padding(.leading, 5)
                    }
                    
                    TextEditor(text: $text)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(minHeight: 120)
                }
                .padding(12)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
            }
            
            // Image Section
            imageSection
        }
    }
    
    // MARK: - Image Section
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "photo")
                    .foregroundColor(AppColors.secondary)
                Text("Imagem (opcional)")
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.primary)
                Spacer()
            }
            
            // Preview da imagem
            if let data = selectedImageData,
               let uiImage = UIImage(data: data) {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
                    
                    // Botão para remover
                    Button {
                        withAnimation(.spring()) {
                            selectedImageData = nil
                            selectedPhotoItem = nil
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(
                                Circle()
                                    .fill(Color.black.opacity(0.5))
                                    .frame(width: 28, height: 28)
                            )
                    }
                    .padding(8)
                }
                .transition(.scale.combined(with: .opacity))
            }
            
            PhotosPicker(
                selection: $selectedPhotoItem,
                matching: .images
            ) {
                HStack {
                    Image(systemName: selectedImageData == nil ? "photo.badge.plus" : "photo.badge.arrow.down")
                    Text(selectedImageData == nil ? "Adicionar imagem" : "Trocar imagem")
                }
                .font(.subheadline)
                .foregroundColor(AppColors.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                )
            }
            .onChange(of: selectedPhotoItem) { _, newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        withAnimation(.spring()) {
                            selectedImageData = data
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
    }
    
    // MARK: - Audio Entry Section
    private var audioEntrySection: some View {
        VStack(spacing: 20) {
            // Recording Interface
            audioRecorderCard
            
            // Optional Note (para tipos mixed)
            if entryType == .mixed {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "text.append")
                            .foregroundColor(AppColors.secondary)
                        Text("Nota (opcional)")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    TextField("Adicione uma nota à gravação...", text: $text)
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
            }
        }
    }
    
    // MARK: - Audio Recorder Card
    private var audioRecorderCard: some View {
        VStack(spacing: 20) {
            // Status Bar
            HStack {
                // Status Indicator
                HStack(spacing: 6) {
                    Circle()
                        .fill(isRecording ? AppColors.recording : AppColors.success)
                        .frame(width: 8, height: 8)
                        .scaleEffect(isRecording ? 1.5 : 1.0)
                        .animation(
                            isRecording ?
                                Animation.easeInOut(duration: 0.5).repeatForever() :
                                .default,
                            value: isRecording
                        )
                    
                    Text(isRecording ? "GRAVANDO" : "PRONTO")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(isRecording ? AppColors.recording : AppColors.success)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.white)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(isRecording ? AppColors.recording.opacity(0.3) : AppColors.success.opacity(0.3), lineWidth: 1)
                )
                
                Spacer()
                
                // Timer
                Text(formatTime(recordingTime))
                    .font(.system(.title3, design: .monospaced))
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
            }
            
            // Waveform
            HStack(spacing: 3) {
                ForEach(0..<waveAmplitudes.count, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 1)
                        .fill(isRecording ? AppColors.recording : AppColors.primary)
                        .frame(width: 3, height: waveAmplitudes[index])
                }
            }
            .frame(height: 40)
            .onChange(of: isRecording) { _, newValue in
                if newValue {
                    startWaveAnimation()
                }
            }
            
            // Record Button
            Button {
                toggleRecording()
            } label: {
                Circle()
                    .fill(isRecording ? Color.red : AppColors.primary)
                    .frame(width: 70, height: 70)
                    .overlay(
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    )
                    .shadow(color: isRecording ? .red.opacity(0.3) : AppColors.primary.opacity(0.3),
                           radius: 10, y: 5)
            }
            
            Text(isRecording ? "Toque para parar" : "Toque para gravar")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.08), radius: 8, y: 3)
    }
    
    // MARK: - Action Buttons
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            // Botão Salvar
            if canSave {
                Button {
                    saveEntry()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark")
                        Text("Salvar")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.primary)
                    .cornerRadius(12)
                }
            }
            
            // Botão Cancelar
            Button {
                cancelRecording()
                dismiss()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "xmark")
                    Text("Cancelar")
                }
                .font(.headline)
                .foregroundColor(AppColors.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.primary.opacity(0.3), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 32)
        .background(Color.white.shadow(color: .black.opacity(0.1), radius: 10, y: -5))
    }
    
    // MARK: - Computed Properties
    private var title: String {
        if entryToEdit != nil {
            return "Editar Entrada"
        } else {
            switch entryType {
            case .text: return "Nova Nota"
            case .audio: return "Gravação de Áudio"
            case .mixed: return "Gravação com Nota"
            }
        }
    }
    
    private var subtitle: String {
        if entryToEdit != nil {
            return "Atualize sua entrada"
        } else {
            switch entryType {
            case .text: return "Escreva o que quiser lembrar"
            case .audio: return "Grave seus pensamentos em voz alta"
            case .mixed: return "Combine áudio e texto"
            }
        }
    }
    
    private var canSave: Bool {
        if entryType == .text {
            return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        } else if entryType == .audio {
            return audioFileName != nil || !text.isEmpty
        } else { // mixed
            return audioFileName != nil || !text.isEmpty
        }
    }
    
    // MARK: - Audio Actions
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
                withAnimation(.spring()) {
                    isRecording = true
                }
                startTimer()
            } else {
                showPermissionAlert = true
            }
        }
    }
    
    private func stopRecording() {
        AudioManager.shared.stopRecording()
        withAnimation(.spring()) {
            isRecording = false
        }
        stopTimer()
    }
    
    private func cancelRecording() {
        if isRecording {
            stopRecording()
        }
        
        // Só deleta o arquivo se for uma nova entrada (não edição)
        if let fileName = audioFileName, entryToEdit == nil {
            AudioManager.shared.deleteAudioFile(named: fileName)
            audioFileName = nil
        }
    }
    
    private func saveEntry() {
        if let entryToEdit = entryToEdit {
            // MODE: EDITAR entrada existente
            viewModel.updateEntry(
                entryToEdit,
                newText: text,
                newAudioFileName: audioFileName,
                newDate: selectedDate,
                newImageData: selectedImageData
            )
        } else {
            // MODE: CRIAR nova entrada
            viewModel.addEntry(
                text: text,
                audioFileName: audioFileName,
                date: selectedDate,
                imageData: selectedImageData
            )
        }
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

// MARK: - Preview
#Preview {
    AddEntryView(entryType: .text, entryToEdit: nil)
        .environmentObject(DiaryViewModel())
}
