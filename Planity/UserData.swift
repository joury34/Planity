//
//  UserData.swift
//  Planity Project
//
//  Created by Aliah Alhameed on 02/04/1446 AH.
//

import SwiftUI


struct UserData: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("userField") var userField: String = ""
    @AppStorage("isRegistered") var isRegistered: Bool = false
    @State private var showTaskHeadingView = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Dropdown variables
    @State private var isCategoryDropdownOpen = false
    @State private var selectedCategoryOption = "Select your field"
    let categoryOptions = ["Food", "Fashion"]

    var body: some View {
        ZStack{ Image("info")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .frame(height: 200)
            
            VStack(spacing: 20) {
               
                
                Text("Please enter your information")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .bold()
                    .padding(.top, 10)

                TextField("Enter your name", text: $userName)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .frame(width: 300, height: 50)
                    .shadow(color: Color("colortexe").opacity(0.8), radius: 10, x: 3, y: 2)
                    

                // Dropdown for selecting field
                VStack {
                    Button(action: {
                        withAnimation {
                            isCategoryDropdownOpen.toggle()
                        }
                    }) {
                        HStack {
                            Text(selectedCategoryOption)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: isCategoryDropdownOpen ? "chevron.up" : "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(width: 300, height: 55)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color("colortexe").opacity(0.8), radius: 10, x: 3, y: 2)
                        
                    }
                    .overlay(
                        VStack(alignment: .leading, spacing: 0) {
                            if isCategoryDropdownOpen {
                                ForEach(categoryOptions, id: \.self) { option in
                                    Button(action: {
                                        selectedCategoryOption = option
                                        isCategoryDropdownOpen = false
                                    }) {
                                        HStack {
                                            Text(option)
                                                .foregroundColor(.black)
                                            Spacer()
                                            if selectedCategoryOption == option {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .padding()
                                        .frame(width: 250)
                                    }
                                    .background(Color.white)
                                }
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .frame(maxHeight: isCategoryDropdownOpen ? .infinity : 0)
                        .animation(.easeInOut, value: isCategoryDropdownOpen)
                    )
                }

                Button(action: {
                    if userName.isEmpty {
                        alertMessage = "Please enter your name."
                        showAlert = true
                    } else if selectedCategoryOption == "Select your field" {
                        alertMessage = "Please select your field."
                        showAlert = true
                    } else {
                        userField = selectedCategoryOption
                        isRegistered = true
                        showTaskHeadingView = true
                    }
                }) {
                    Text("Generate Plan")
                        .foregroundColor(.white)
                        .bold()
                        .frame(width: 300, height: 50)
                        .background(Color("Colorpage"))
                        .cornerRadius(16)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Input Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                .fullScreenCover(isPresented: $showTaskHeadingView) {
                    CalendarTask()
                }
                .padding(.top, 30)
            }
            .padding()
        }
    }
}


#Preview {
    UserData()
}
