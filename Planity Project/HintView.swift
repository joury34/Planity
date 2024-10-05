//
//  HintView.swift
//  Planity Project
//
//  Created by Aisha Asiri on 02/04/1446 AH.
//

import SwiftUI

struct HintView: View {
    var body: some View {
        ZStack {
            Image("cloud")
                .resizable()
                .ignoresSafeArea()
            VStack{
                Text ("The best two platforms for the food industry are: Instagram & TikTok")
                    .fontWeight(.bold)
                    .foregroundColor(Color("Colorpage"))
                    .font(.system(size: 30, weight: .regular, design: .default))
                    .padding()
                Text ("💡Consistency is the key, you need to post daily to keep your engagement high and the audience magnetized.")
                
                Text ("💡Targeting your business audience will keep your engagement worthwhile and valuable.")
                
                Text ("💡It's essential to track the trend to create a content that makes a buzz online.")
            }
            .padding(.leading, 20)
        }
        }
    }


#Preview {
    HintView()
}

