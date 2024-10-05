//
//  Onboarding3.swift
//  Planity Project
//
//  Created by Aliah Alhameed on 02/04/1446 AH.
//

import SwiftUI


struct Onboarding3: View {
    @AppStorage("isRegistered") var isRegistered: Bool = false
    @State private var sparkleOpacity: Double = 0.0

    var body: some View {
        ZStack {
            Image("testPicture3")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .edgesIgnoringSafeArea(.all)

            ForEach(0..<30) { _ in
                Circle()
                    .fill(Color.white)
                    .frame(width: 8, height: 8)
                    .opacity(sparkleOpacity)
                    .position(randomPosition())
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: sparkleOpacity)
            }

            VStack {
                Spacer()
                NavigationLink(destination: UserData()) {
                    Text("Let's Go!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 250)
                        .background(Color(red: 4/255, green: 54/255, blue: 74/255))
                        .cornerRadius(10)
                        .padding(40)
                }
                .padding(.bottom, 40)
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
    Onboarding3()
}

