//
//  DiaryEntry.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftData
import Foundation

@Model
class DiaryEntry {
    var id: UUID
    var date: Date
    var text: String
    var audioFileName: String?
    
    var imageData: Data?

    var hasImage: Bool {
        imageData != nil
    }

    
    init(id: UUID = UUID(), text: String, audioFileName: String? = nil, date:Date = Date(), imageData: Data? = nil) {
        self.id = id
        self.date = Date()
        self.text = text
        self.audioFileName = audioFileName
    }
    
    var hasAudio: Bool {
        audioFileName != nil && !audioFileName!.isEmpty
    }
    
    var entryType: EntryType {
        if hasAudio && !text.isEmpty {
            return .mixed
        } else if hasAudio {
            return .audio
        } else {
            return .text
        }
    }
}
