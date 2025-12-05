//
//  AppAnimations.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 03/12/25.
//
import SwiftUI

struct AppAnimations {
    static let quick = Animation.easeInOut(duration: 0.2)
    static let standard = Animation.easeInOut(duration: 0.3)
    static let smooth = Animation.easeInOut(duration: 0.4)
    static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)
}
