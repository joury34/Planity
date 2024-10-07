//
//  ContentView.swift
//  Planity Project
//
//  Created by Aliah Alhameed on 26/03/1446 AH.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isRegistered") var isRegistered: Bool = false
    @AppStorage("userName") var userName: String = ""

    var body: some View {
        if !isRegistered {
            Onboarding1() // Show onboarding if the user is not registered
        } else {
            if userName.isEmpty {
                UserData() // Show UserData view if no name is set
            } else {
                CalendarTask() // Show TaskHeading view if the user has completed the registration
            }
        }
    }
}
#Preview {
    ContentView()
}
