//
//  LoadAsyncImage.swift
//  RandomUser
//
//  Created by Arnau on 11/06/2026.
//

import SwiftUI

struct LoadAsyncImage: View {
    
    let imageURL: String
    let initials: String
    
    let circleSize: CGFloat
    let imageSize: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(
                    LinearGradient(
                        colors: [.purple, .blue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2.5
                )
                .frame(width: circleSize, height: circleSize)
            
            AsyncImage(
                url: URL(string: imageURL),
                transaction: Transaction(animation: .easeInOut(duration: 0.3))
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(Circle())
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    
                case .failure:
                    placeholder
                    
                default:
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: imageSize, height: imageSize)
                        
                        ProgressView()
                            .tint(.white.opacity(0.5))
                            .scaleEffect(0.8)
                    }
                }
            }
        }
    }
    
    private var placeholder: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.purple.opacity(0.6), .blue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: imageSize, height: imageSize)
            
            Text(initials)
                .font(
                    .system(
                        size: imageSize * 0.32,
                        weight: .semibold,
                        design: .rounded
                    )
                )
                .foregroundColor(.white)
        }
    }
}
