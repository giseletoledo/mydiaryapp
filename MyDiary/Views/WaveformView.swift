//
//  WaveformView.swift
//  MyDiary
//
//  Created by GISELE TOLEDO on 01/12/25.
//

import SwiftUI

struct WaveformView: View {
    let amplitudes: [CGFloat]
    let isPlaying: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            ForEach(0..<amplitudes.count, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(
                        LinearGradient(
                            colors: isPlaying ?
                                [.blue, .purple] :
                                [.gray.opacity(0.3), .gray.opacity(0.2)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 3, height: amplitudes[index])
                    .animation(.linear(duration: 0.1), value: amplitudes[index])
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// Preview
#Preview {
    WaveformView(
        amplitudes: Array(repeating: 20, count: 20),
        isPlaying: true
    )
    .padding()
}
