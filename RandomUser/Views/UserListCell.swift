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
    let onCheckBoxTapped: ((UserEntity) -> Void)?
    
    @State private var isPressed = false
    
    init(
        userEntity: UserEntity,
        showCheckBoxButton: Bool,
        onCheckBoxTapped: ((UserEntity) -> Void)? = nil,
    ) {
        self.userEntity = userEntity
        self.showCheckBoxButton = showCheckBoxButton
        self.onCheckBoxTapped = onCheckBoxTapped
    }
    
    var body: some View {
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
}

extension UserListCell {
    
    private var checkBoxButton: some View {
        CheckBoxView(checked: $isChecked)
    }
    
    private var userImage: some View {
        LoadAsyncImage(
            imageURL: userEntity.pictureURL,
            initials: initials,
            circleSize: 68,
            imageSize: 62
        )
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
        streetNumber: 122,
        streetName: "Calle Falsa",
        city: "Barcelona",
        state: "Catalonia",
        latitude: "41.38879",
        longitude: "2.15899",
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
        streetNumber: 122,
        streetName: "Calle Falsa",
        city: "Madrid",
        state: "Madrid",
        latitude: "41.38879",
        longitude: "2.15899",
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
