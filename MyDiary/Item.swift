//
//  Item.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
