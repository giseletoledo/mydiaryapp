//
//  MyDiaryApp.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftUI
import SwiftData

@main
struct MyDiaryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: DiaryEntry.self)
    }
}
