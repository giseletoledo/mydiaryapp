//
//  AudioManager.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import AVFoundation
import SwiftUI
import Combine

class AudioManager: NSObject, ObservableObject {
    static let shared = AudioManager()
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    
    @Published var isRecording = false
    @Published var isPlaying = false
    
    private override init() {
        super.init()
    }
    
    // MARK: - Setup
    private func setupAudioSession(for recording: Bool) {
        do {
            let session = AVAudioSession.sharedInstance()
            if recording {
                try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
            } else {
                try session.setCategory(.playback)
            }
            try session.setActive(true)
        } catch {
            print("❌ Erro na sessão: \(error)")
        }
    }
    
    // MARK: - Gravação
    func startRecording() -> String? {
        setupAudioSession(for: true)
        
        let fileName = "\(UUID().uuidString).m4a"
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
            print("🎤 Gravando: \(fileName)")
            return fileName
        } catch {
            print("❌ Erro ao gravar: \(error)")
            return nil
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        print("⏹️ Gravação parada")
    }
    
    // MARK: - Reprodução
    func playAudio(named fileName: String) -> Bool {
        print("▶️ Tentando tocar arquivo: \(fileName)")
        setupAudioSession(for: false)
        
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("❌ Arquivo não existe")
            return false
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
            print("▶️ Reproduzindo")
            return true
        } catch {
            print("❌ Erro ao reproduzir: \(error)")
            return false
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
        print("⏹️ Reprodução parada")
    }
    
    // MARK: - Permissão (iOS 17+)
    func requestPermission() async -> Bool {
        return await withCheckedContinuation { continuation in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
    
    // MARK: - Utilitários
    func deleteAudioFile(named fileName: String) {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        try? FileManager.default.removeItem(at: url)
        print("🗑️ Arquivo deletado")
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}

// MARK: - Delegates
extension AudioManager: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        isRecording = false
        print(flag ? "✅ Gravação salva" : "❌ Erro na gravação")
    }
}

extension AudioManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        print("✅ Reprodução concluída")
    }
}
