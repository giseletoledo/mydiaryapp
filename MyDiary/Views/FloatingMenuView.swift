//
//  FloatingMenuView.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftUI

struct FloatingMenuView: View {
    @EnvironmentObject private var viewModel: DiaryViewModel
    
    @State private var isExpanded = false
    @State private var rotation: Double = 0
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 15) {
                    // Botões quando expandido
                    if isExpanded {
                        ForEach(EntryType.allCases, id: \.self) { type in
                            Button {
                                viewModel.selectEntryType(type)
                                collapseMenu()
                            } label: {
                                HStack {
                                    Image(systemName: type.icon)
                                    Text(type.rawValue)
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .fill(type.color)
                                )
                            }
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    
                    // Botão principal
                    Button {
                        withAnimation(.spring()) {
                            isExpanded.toggle()
                            rotation = isExpanded ? 45 : 0
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(rotation))
                            .frame(width: 60, height: 60)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.purple, .indigo],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .shadow(radius: 5)
                    }
                }
                .padding(.trailing, 20)
                .padding(.bottom, 30)
            }
        }
    }
    
    private func collapseMenu() {
        withAnimation(.spring()) {
            isExpanded = false
            rotation = 0
        }
    }
}
