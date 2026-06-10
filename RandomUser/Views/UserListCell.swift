//
//  UserListCell.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import SwiftUI

struct UserListCell: View {
    
    let userName: String
    let userSurname: String
    let userEmail: String
    let userPicture: String
    let userPhone: String
    
    let onTap: (() -> Void)?
    
    @State private var isPressed = false
    
    init(
        userName: String,
        userSurname: String,
        userEmail: String,
        userPicture: String,
        userPhone: String,
        onTap: (() -> Void)? = nil
    ) {
        self.userName = userName
        self.userSurname = userSurname
        self.userEmail = userEmail
        self.userPicture = userPicture
        self.userPhone = userPhone
        self.onTap = onTap
    }
    
    var body: some View {
        
        Button {
            onTap?()
        } label: {
            GlassCardComponent {
                HStack (spacing: 16){
                    userImage
                    userInfo
                    Spacer()
                    chevron
                }
                .padding(.vertical, 4)
                
            }
        }
        .buttonStyle(PressableButtonStyle())
        
    }
}

extension UserListCell {
    
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
                url: URL(string: userPicture),
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
            
            Text(initials)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
        }
    }
    
    private var userInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Full name
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text(userName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                Text(userSurname)
                    .font(.system(size: 18, weight: .light))
                    .foregroundColor(.white.opacity(0.75))
            }
            .lineLimit(1)
            
            // Divider
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.purple.opacity(0.5), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
            
            // Contact info
            VStack(alignment: .leading, spacing: 3) {
                metadataRow(icon: "phone.fill", text: userPhone)
                metadataRow(icon: "envelope.fill", text: userEmail)
            }
        }
    }
    
    private func metadataRow(icon: String, text: String) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.purple.opacity(0.8))
                .frame(width: 14)
            Text(text)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.white.opacity(0.55))
                .lineLimit(1)
        }
    }
    
    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.white.opacity(0.25))
    }
    
    private var initials: String {
        let first = userName.first.map(String.init) ?? ""
        let last = userSurname.first.map(String.init) ?? ""
        return first + last
    }
}

// MARK: - Press Style

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.88 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(red: 0.08, green: 0.08, blue: 0.12)
            .ignoresSafeArea()
        
        VStack(spacing: 12) {
            UserListCell(
                userName: "Pablo",
                userSurname: "García",
                userEmail: "pablo@gmail.com",
                userPicture: "https://randomuser.me/api/portraits/men/75.jpg",
                userPhone: "+34 667 421 445"
            ) { print("tapped") }
            
            UserListCell(
                userName: "María",
                userSurname: "López",
                userEmail: "maria.lopez@icloud.com",
                userPicture: "https://randomuser.me/api/portraits/women/44.jpg",
                userPhone: "+34 612 885 331"
            ) { print("tapped") }
        }
        .padding()
    }
}
//extension UserListCell {
//
//    private var userImage: some View {
//        AsyncImage(
//            url: URL(string: userPicture),
//            transaction: Transaction(animation: .default),
//            content: { phase in
//                if let image = phase.image {
//                    image
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .clipShape(Circle())
//                } else {
//                    ProgressView()
//                }
//            }
//        )
//    }
//
//    private var nameAndSurname: some View {
//        VStack (spacing: 7){
//            Text(userName)
//                .font(.system(size: 27, weight: .regular))
//            Text(userSurname)
//                .font(.system(size: 15, weight: .light))
//        }
//    }
//
//    private var phoneAndEmail: some View {
//        VStack (spacing: 7){
//            Text(userPhone)
//                .font(.system(size: 27, weight: .regular))
//            Text(userEmail)
//                .font(.system(size: 15, weight: .light))
//        }
//    }
//}
//
//#Preview {
//    UserListCell(userName: "Pablo", userSurname: "Pablito", userEmail: "pablo@gmail.com", userPicture: "https://randomuser.me/api/portraits/men/75.jpg", userPhone: "+34 667 421 445") {
//        print("AU")
//    }
//}
