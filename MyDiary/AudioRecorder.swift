// AudioRecorder.swift
import Foundation
import AVFoundation
import AVFAudio       // para AVAudioApplication (iOS 17+)
import Combine

// MARK: - Protocols

protocol AudioRecording {
    var isRecording: Bool { get }
    var currentTime: TimeInterval { get }
    var recordingURL: URL? { get }

    func startRecording() throws
    func stopRecording() -> RecordingResult
    func requestPermission(completion: @escaping (Bool) -> Void)
}

// MARK: - Models

struct RecordingResult {
    let fileURL: URL?
    let fileName: String?
    let duration: TimeInterval
    let fileSize: Int64?
}

// MARK: - AudioRecorder

final class AudioRecorder: NSObject, AudioRecording {

    // MARK: - Published Properties

    @Published private(set) var isRecording = false
    @Published private(set) var currentTime: TimeInterval = 0
    @Published private(set) var recordingURL: URL?

    // MARK: - Private Properties

    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var startTime: Date?
    private var audioSession: AVAudioSession { AVAudioSession.sharedInstance() }

    // MARK: - Constants

    private struct Constants {
        static let audioFormat = kAudioFormatMPEG4AAC
        static let sampleRate: Double = 44_100.0
        static let numberOfChannels = 1
        static let fileExtension = "m4a"
        static let timerInterval = 0.1
    }

    // MARK: - Initialization

    override init() {
        super.init()
        setupAudioSession()
    }

    deinit {
        cleanup()
    }

    // MARK: - Public Methods

    func requestPermission(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            // Em iOS 17+ o método é ESTÁTICO (sem .shared)
            AVAudioApplication.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        } else {
            audioSession.requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }

    func startRecording() throws {
        guard !isRecording else { return }

        try validateMicrophoneAccess()
        try configureAudioSession()

        let settings = createAudioSettings()
        let fileURL = generateFileURL()

        audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
        audioRecorder?.delegate = self
        audioRecorder?.isMeteringEnabled = true
        audioRecorder?.prepareToRecord()

        guard audioRecorder?.record() == true else {
            throw AudioRecordingError.recordingFailed
        }

        startRecordingSession(fileURL: fileURL)
    }

    func stopRecording() -> RecordingResult {
        let duration = currentTime
        let fileURL = recordingURL

        audioRecorder?.stop()
        stopTimer()
        isRecording = false

        let fileSize = getFileSize(at: fileURL)
        let result = RecordingResult(
            fileURL: fileURL,
            fileName: fileURL?.lastPathComponent,
            duration: duration,
            fileSize: fileSize
        )

        cleanup()
        return result
    }

    // MARK: - Private Methods

    private func setupAudioSession() {
        do {
            try audioSession.setCategory(
                .playAndRecord,
                mode: .default,
                options: [.defaultToSpeaker, .allowBluetoothHFP] // atualizado
            )
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup error: \(error)")
        }
    }

    private func validateMicrophoneAccess() throws {
        if #available(iOS 17.0, *) {
            // recordPermission continua sendo propriedade de instância em .shared
            guard AVAudioApplication.shared.recordPermission == .granted else {
                throw AudioRecordingError.permissionDenied
            }
        } else {
            guard audioSession.recordPermission == .granted else {
                throw AudioRecordingError.permissionDenied
            }
        }
    }

    private func configureAudioSession() throws {
        try audioSession.setActive(true)
    }

    private func createAudioSettings() -> [String: Any] {
        [
            AVFormatIDKey: Int(Constants.audioFormat),
            AVSampleRateKey: Constants.sampleRate,
            AVNumberOfChannelsKey: Constants.numberOfChannels,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey: 192_000
        ]
    }

    private func generateFileURL() -> URL {
        let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]

        let fileName = "\(UUID().uuidString).\(Constants.fileExtension)"
        return documentsDirectory.appendingPathComponent(fileName)
    }

    private func startRecordingSession(fileURL: URL) {
        isRecording = true
        recordingURL = fileURL
        startTime = Date()
        startTimer()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: Constants.timerInterval,
            repeats: true
        ) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.currentTime = Date().timeIntervalSince(startTime)
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func getFileSize(at url: URL?) -> Int64? {
        guard let url = url else { return nil }

        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
            return attributes[.size] as? Int64
        } catch {
            return nil
        }
    }

    private func cleanup() {
        audioRecorder = nil
        currentTime = 0
        recordingURL = nil
        startTime = nil
    }
}

// MARK: - AVAudioRecorderDelegate

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("Recording finished with errors")
        }
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        if let error = error {
            print("Recording encoding error: \(error)")
        }
    }
}

