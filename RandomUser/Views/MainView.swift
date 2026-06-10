//
//  MainView.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.edgesIgnoringSafeArea(.all)
            
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.clear]), startPoint: .top, endPoint: .bottom)
                .frame(height: 200)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                titleAndDeleteButton
                userList
            }
        }
        .liquidGlassLoading(isPresented: $viewModel.isLoading, state: .loading(message: String(localized: "fetching_users")))
        
        .task {
            viewModel.configure(modelContext: modelContext)
            await viewModel.checkUsersStored()
            await viewModel.fetchUsers()
        }
    }
}

extension MainView {
    
    var titleAndDeleteButton: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text(String(localized: "find_your"))
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.5))
                    .kerning(2)
                
                Text(String(localized: "random_user"))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            GlassButtonComponent(padding: 10) {
                // viewModel.deleteUser()
            } content: {
                Image(systemName: "trash")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.red.opacity(0.85))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    
    private var userList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                if !viewModel.usersSavedInDB.isEmpty {
                    ForEach(viewModel.usersSavedInDB) { result in
                        UserListCell(userName: result.firstName, userSurname: result.lastName, userEmail: result.email, userPicture: result.pictureURL, userPhone: result.phone)
                    }
                    
                }
            }
        }
        .padding()
        .ignoresSafeArea()
    }
}

#Preview {
    MainView()
}


