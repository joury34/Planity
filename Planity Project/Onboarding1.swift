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
                                                currentPage = 2 // Move to the third page
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
        }
    }
}

#Preview {
    Onboarding1()
}

