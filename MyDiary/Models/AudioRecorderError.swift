//
//  AudioRecorderError.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//
// MARK: - AudioRecordingError

import Foundation

enum AudioRecordingError: LocalizedError {
    case permissionDenied
    case recordingFailed
    case invalidConfiguration
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Microphone access denied"
        case .recordingFailed:
            return "Failed to start recording"
        case .invalidConfiguration:
            return "Invalid audio configuration"
        }
    }
}
