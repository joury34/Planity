//
//  Onboarding2.swift
//  Planity Project
//
//  Created by Aliah Alhameed on 02/04/1446 AH.
//
import SwiftUI

struct Onboarding2: View {
    @State private var sparkleOpacity: Double = 0.0

    var body: some View {
        ZStack {
            // Background Image
            Image("testPicture2")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .edgesIgnoringSafeArea(.all)

            // Sparkling effect
            ForEach(0..<30) { _ in // Increased number of sparkles for better effect
                Circle()
                    .fill(Color.blue.opacity(0.6)) // Baby blue color
                    .frame(width: 6, height: 6) // Smaller size
                    .opacity(sparkleOpacity)
                    .position(randomPosition())
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: sparkleOpacity)
            }
        }
        .onAppear {
            sparkleOpacity = 1.0
        }
    }

    private func randomPosition() -> CGPoint {
        let x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
        let y = CGFloat.random(in: 0...UIScreen.main.bounds.height)
        return CGPoint(x: x, y: y)
    }
}

#Preview {
    Onboarding2()
}
