//
//  ProfileView.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import SwiftUI

struct ProfileView: View {

    @StateObject private var viewModel: ProfileViewModel

    init(user: UserEntity) {
        _viewModel = StateObject(
            wrappedValue: ProfileViewModel(userInformation: user)
        )
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.clear]), startPoint: .top, endPoint: .bottom)
                .frame(height: 200)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(viewModel.userInformation.firstName)
            }
        }
    }
}

extension ProfileView {
    
    private var userImage: some View {
        ZStack {
            // Gradient ring
            Circle()
                .strokeBorder(
                    LinearGradient(
                        colors: [.purple, .blue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2.5
                )
                .frame(width: 68, height: 68)
            
            AsyncImage(
                url: URL(string: viewModel.userInformation.pictureURL),
                transaction: Transaction(animation: .easeInOut(duration: 0.3))
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 62, height: 62)
                        .clipShape(Circle())
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                case .failure:
                    initialsPlaceholder
                default:
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 62, height: 62)
                        ProgressView()
                            .tint(.white.opacity(0.5))
                            .scaleEffect(0.8)
                    }
                }
            }
        }
    }
    
    private var initialsPlaceholder: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.purple.opacity(0.6), .blue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 62, height: 62)
            
            Text(viewModel.getInitials())
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

