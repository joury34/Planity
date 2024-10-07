//
//  HintView.swift
//  Planity Project
//
//  Created by Aisha Asiri on 02/04/1446 AH.
//

import SwiftUI

import SwiftUI

struct HintView: View {
    
   
    // List of hints
    let hints = [
        "The best two platforms for the food industry are: Instagram & TikTok",
        "💡Consistency is the key, you need to post daily to keep your engagement high and the audience magnetized.",
        "💡Targeting your business audience will keep your engagement worthwhile and valuable.",
        "💡It's essential to track the trend to create content that makes a buzz online.",
        "💡Use high-quality images and videos to attract more attention.",
        "💡Engage with your audience by asking questions in your posts.",
        "💡Leverage influencer marketing to expand your reach.",
        "💡Post at peak times to maximize visibility.",
        "💡Use relevant hashtags to increase discoverability.",
        "💡Create behind-the-scenes content to make your brand more relatable.",
        "💡Collaborate with other creators to reach a broader audience.",
        "💡Utilize Stories to keep your followers updated.",
        "💡Showcase user-generated content to build trust with your audience.",
        "💡Host giveaways to encourage user engagement.",
        "💡Share recipe tips or food hacks to provide value to your followers.",
        "💡Run polls to understand your audience’s preferences.",
        "💡Use catchy captions to grab attention.",
        "💡Highlight your unique selling points in your posts.",
        "💡Track and analyze your content performance to improve your strategy.",
        "💡Post consistently, but don’t compromise on quality.",
        "💡Respond to comments to build a strong community.",
        "💡Create content that aligns with trending topics.",
        "💡Use Instagram Reels to showcase creative content.",
        "💡Keep your branding consistent across all your posts.",
        "💡Test different types of content to see what works best.",
        "💡Share your brand story to create a connection with your audience.",
        "💡Use humor in your content to make it more engaging.",
        "💡Encourage followers to share their experiences using your products.",
        "💡Create content with a clear call-to-action to drive engagement.",
        "💡Use a mix of content formats: photos, videos, carousels."
    ]

    // Get the current day of the month
    var currentHint: String {
        let day = Calendar.current.component(.day, from: Date()) - 1
        return hints[day % hints.count] // Ensure the hint index wraps around
    }

    var body: some View {
     
        ZStack {
          
            Image("cloud")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Text("Hint Of The Day")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Colorpage"))
                
                Text(currentHint)
                    .foregroundColor(Color("Colorpage"))
                    .font(.system(size: 30, weight: .regular, design: .default))
                    .padding()
            }
            .padding(.leading, 20)
        }
    }
}

#Preview {
    HintView()
}

