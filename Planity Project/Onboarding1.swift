//
//  Onboarding1.swift
//  Planity Project
//
//  Created by Aliah Alhameed on 02/04/1446 AH.
//
import SwiftUI

struct Onboarding1: View {
    @AppStorage("isRegistered") var isRegistered: Bool = false
    @State private var currentPage = 0
    @State private var showUserDataView = false // State variable to control navigation to UserData
    private let totalPages = 3 // Total number of pages

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    // Background Image
                    Image("testPicture") // Replace with your image name
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .edgesIgnoringSafeArea(.all)

                    // Shine Effect Overlay
                    ShineEffect()
                        .edgesIgnoringSafeArea(.all)

                    VStack {
                        TabView(selection: $currentPage) {
                            // First Page
                            ZStack {
                                Color.clear // Ensures the ZStack works properly
                                
                                // Skip Button, only show on the first page
                                if currentPage == 0 {
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Button(action: {
                                                isRegistered = true // Mark as registered
                                                showUserDataView = true // Show UserData view
                                            }) {
                                                Text("Skip")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 12)
                                                    .padding(.vertical, 8)
                                                    .background(Color(red: 4/255, green: 54/255, blue: 74/255))
                                                    .cornerRadius(10)
                                            }
                                            .padding(.top, 40)
                                            .padding(.trailing, 20)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .tag(0)

                            // Second Page
                            Onboarding2()
                                .tag(1)

                            // Third Page
                            Onboarding3()
                                .tag(2)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never)) // Hide default indicators
                        
                        // Custom Page Indicators at the bottom
                        HStack(spacing: 8) {
                            ForEach(0..<totalPages, id: \.self) { index in
                                Circle()
                                    .fill(index == currentPage ? Color.purple : Color.gray.opacity(0.5))
                                    .frame(width: 10, height: 10)
                            }
                        }
                        .padding(.bottom, 20) // Adjust padding as needed
                    }
                }
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all) // Ensure to ignore safe areas
            .fullScreenCover(isPresented: $showUserDataView) {
                UserData()
            }
        }
    }
}

struct ShineEffect: View {
    @State private var shinePosition: CGFloat = -200 // Start off-screen

    var body: some View {
        LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.7), Color.clear]), startPoint: .leading, endPoint: .trailing)
            .frame(width: 300, height: 100) // Width and height for a more polished look
            .cornerRadius(50) // Rounded edges for a softer appearance
            .rotationEffect(.degrees(30))
            .offset(x: shinePosition, y: 0)
            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: shinePosition)
            .onAppear {
                shinePosition = UIScreen.main.bounds.width + 200 // Move shine across the screen
            }
    }
}

#Preview {
    Onboarding1()
}
