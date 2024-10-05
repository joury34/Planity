//
//  TaskHeadingView.swift
//  Planity Project
//
//  Created by Aliah Alhameed on 02/04/1446 AH.
//

import SwiftUI

struct TaskHeadingView: View {
    @AppStorage("userName") var userName: String = ""
    @AppStorage("userField") var userField: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, \(userName)")
                .font(.title)
                .bold()
                .padding()

            Text("The best plan for \(userField) field.")
                .font(.headline)
                .padding()

            // Add content plan or details here...
        }
    }
}

#Preview {
    TaskHeadingView()
}
