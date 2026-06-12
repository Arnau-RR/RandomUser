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
        ZStack (alignment: .top){
            Color.black.edgesIgnoringSafeArea(.all)
            
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.clear]), startPoint: .top, endPoint: .bottom)
                .frame(height: 200)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                
                VStack(spacing: 16) {
                    userImage
                    nameAndSurname
                    gender
                }
                
                ScrollView(showsIndicators: false) {
                    
                    phoneAndEmail
                    locationStreetCityAndState
                    memberSince
                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
    }
}

extension ProfileView {
    
    private var userImage: some View {
        LoadAsyncImage(
            imageURL: viewModel.userInformation.pictureURL,
            initials: viewModel.getInitials(),
            circleSize: 120,
            imageSize: 112
        )
    }
    
    private var nameAndSurname: some View {
        HStack {
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text(viewModel.userInformation.firstName)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.white)
                Text(viewModel.userInformation.lastName)
                    .font(.system(size: 22, weight: .light))
                    .foregroundColor(.white.opacity(0.75))
            }
            .lineLimit(1)
        }
    }
    
    private var gender: some View {
        Label {
            Text(viewModel.getGenderWithTranslation().capitalized)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.75))
        } icon: {
            Image(systemName: "person.fill")
                .foregroundColor(.purple.opacity(0.8))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .foregroundColor(.white.opacity(0.75))
        .clipShape(Capsule())
    }
    
    private var phoneAndEmail: some View {
        GlassCardComponent {
            VStack(spacing: 16) {
                infoRowView(
                    icon: "phone.fill",
                    title: String(localized: "phone"),
                    value: viewModel.userInformation.phone
                )
                
                infoRowView(
                    icon: "envelope.fill",
                    title: String(localized: "email"),
                    value: viewModel.userInformation.email
                )
            }
        }
    }
    
    private var memberSince: some View {
        GlassCardComponent {
            VStack(alignment: .leading, spacing: 12) {
                
                Label {
                    Text(String(localized: "member_since"))
                        .font(.caption)
                        .foregroundColor(.white)
                } icon: {
                    Image(systemName: "calendar")
                        .foregroundColor(.purple.opacity(0.8))
                }
                
                HStack {
                    Spacer()
                    Text("\(viewModel.getMemberSinceFormatted())")
                    Spacer()
                }
                .foregroundColor(.white.opacity(0.75))
                .font(.system(size: 15, weight: .medium))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    private var locationStreetCityAndState: some View {
        GlassCardComponent {
            VStack(alignment: .leading, spacing: 12) {
                
                Label {
                    Text(String(localized: "location"))
                        .font(.caption)
                        .foregroundColor(.white)
                } icon: {
                    Image(systemName: "location.fill")
                        .foregroundColor(.purple.opacity(0.8))
                }
                
                // RandomUser coordinates may not match the displayed address.
                // That's the reason why you can see X street but then the coordinates are on the Pacific Ocean for example.
                
                MapCard(
                    latitude: Double(viewModel.userInformation.latitude) ?? 0.0,
                    longitude: Double(viewModel.userInformation.longitude) ?? 0.0
                )
                
                Text("""
                • \(viewModel.userInformation.streetName) \(viewModel.userInformation.streetNumber), 
                  \(viewModel.userInformation.city), \(viewModel.userInformation.state)
                """)
                .foregroundColor(.white.opacity(0.75))
                .font(.system(size: 15, weight: .medium))
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

