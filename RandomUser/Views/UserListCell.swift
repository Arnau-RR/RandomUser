//
//  UserListCell.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import SwiftUI

struct UserListCell: View {
    
    @State var isChecked: Bool = false
    
    let userEntity: UserEntity
    let showCheckBoxButton: Bool
    
    //let onTap: ((UserEntity) -> Void)?
    let onCheckBoxTapped: ((UserEntity) -> Void)?
    
    @State private var isPressed = false
    
    init(
        userEntity: UserEntity,
        showCheckBoxButton: Bool,
        //onTap: ((UserEntity) -> Void)? = nil,
        onCheckBoxTapped: ((UserEntity) -> Void)? = nil,
    ) {
        self.userEntity = userEntity
        self.showCheckBoxButton = showCheckBoxButton
        //self.onTap = onTap
        self.onCheckBoxTapped = onCheckBoxTapped
    }
    
    var body: some View {
        
//        Button {
//            onTap?(userEntity)
//        } label: {
            GlassCardComponent {
                HStack (spacing: 16){
                    if showCheckBoxButton {
                        checkBoxButton
                            .simultaneousGesture(
                                TapGesture()
                                    .onEnded {
                                        onCheckBoxTapped?(userEntity)
                                    }
                            )
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .leading).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                )
                            )
                    }
                    userImage
                    userInfo
                    Spacer()
                    chevron
                }
                .padding(.vertical, 4)
                .animation(.spring(response: 0.22, dampingFraction: 0.8), value: showCheckBoxButton)
            }
        }
//        .buttonStyle(PressableButtonStyle())
//        
//    }
}

extension UserListCell {
    
    private var checkBoxButton: some View {
        CheckBoxView(checked: $isChecked)
    }
    
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
                url: URL(string: userEntity.pictureURL),
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
                Text(userEntity.firstName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                Text(userEntity.lastName)
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
                metadataRow(icon: "phone.fill", text: userEntity.phone)
                metadataRow(icon: "envelope.fill", text: userEntity.email)
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
        let first = userEntity.firstName.first.map(String.init) ?? ""
        let last = userEntity.lastName.first.map(String.init) ?? ""
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
    
    let user1 = UserEntity(
        uuid: UUID().uuidString,
        firstName: "Pablo",
        lastName: "García",
        email: "pablo@gmail.com",
        phone: "+34 667 421 445",
        gender: "male",
        city: "Barcelona",
        state: "Catalonia",
        registeredDate: "2026-06-10",
        pictureURL: "https://randomuser.me/api/portraits/men/75.jpg"
    )
    
    let user2 = UserEntity(
        uuid: UUID().uuidString,
        firstName: "María",
        lastName: "López",
        email: "maria.lopez@icloud.com",
        phone: "+34 612 885 331",
        gender: "female",
        city: "Madrid",
        state: "Madrid",
        registeredDate: "2026-06-10",
        pictureURL: "https://randomuser.me/api/portraits/women/44.jpg"
    )
    
    ZStack {
        Color(red: 0.08, green: 0.08, blue: 0.12)
            .ignoresSafeArea()
        
        VStack(spacing: 12) {
            
            UserListCell(
                userEntity: user1,
                showCheckBoxButton: false, onCheckBoxTapped:  {_ in
                    print("tapped")
                })
            
            UserListCell(
                userEntity: user2,
                showCheckBoxButton: true, onCheckBoxTapped:  {_ in
                    print("tapped")
                })
        }
        .padding()
    }
}
