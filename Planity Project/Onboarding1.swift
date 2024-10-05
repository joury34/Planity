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
    private let totalPages = 3

    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                TabView(selection: $currentPage) {
                    // First Page
                    ZStack {
                        Image("testPicture")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .edgesIgnoringSafeArea(.all)

                        // Skip Button, only show on the first page
                        if currentPage == 0 {
                            VStack {
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        isRegistered = true // Skip to register
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
                    ZStack {
                        Image("secondPage")
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .edgesIgnoringSafeArea(.all)
                    }
                    .tag(1)

                    // Third Page
                    Onboarding3()
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }
            .navigationBarHidden(true)
            .edgesIgnoringSafeArea(.all)
        }
    }
}
#Preview {
    Onboarding1()
}

