//
//  Date+Extensions.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import Foundation

extension Date {
    func formatDate() -> String {
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(self) {
            formatter.dateFormat = "'Hoje' HH:mm"
        } else if Calendar.current.isDateInYesterday(self) {
            formatter.dateFormat = "'Ontem' HH:mm"
        } else {
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
        }
        
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: self)
    }
}
