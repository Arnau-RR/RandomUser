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
            .overlay {
                ZStack {
                    VStack {
                        Spacer()
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.clear,
                                Color.black
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 50)
                        .overlay {
                            deleteButton
                                .offset(y: 8)
                        }
                    }
                }
                .opacity(viewModel.userWantsDeleteUsers ? 1 : 0)
                
            }
        }
        .liquidGlassLoading(isPresented: $viewModel.isLoading, state: .loading(message: String(localized: "fetching_users")))
        
        .task {
            viewModel.configure(modelContext: modelContext)
            await viewModel.checkUsersStored()
            await viewModel.fetchUsers()
        }
        
        .popupAlert(
            isPresented: $viewModel.userConfirmsToDeleteTherUsers,
            title: String(localized: "title_delete_users"),
            message: String(localized: "subtitle_delete_secure"),
            icon: "trash.fill",
            iconColor: .red,
            buttons: [
                .destructive(String(localized: "delete")) {viewModel.checkUsersAsDeleted()},
                .cancel()
            ]
        )
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
                viewModel.userWantsDeleteUsers.toggle()
            } content: {
                Image(systemName: viewModel.userWantsDeleteUsers ? "xmark" : "trash" )
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(viewModel.userWantsDeleteUsers ? .white.opacity(0.85) : .red.opacity(0.85))
                    .frame(height: 20)
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
                        UserListCell(
                            userEntity: result,
                            showCheckBoxButton: viewModel.userWantsDeleteUsers,
                            onTap: { userSelected in
                                //viewModel.userCellPressed(uuid: uuid, action: .tap)
                            },
                            onCheckBoxTapped: { userSelected in
                                viewModel.userCellCheckBoxPressed(userSelected)
                            }
                        )
                    }
                    
                }
            }
        }
        .padding()
        .ignoresSafeArea()
    }
    
    var deleteButton: some View {
        
        HStack {
            GlassButtonComponent(padding: 10) {
                viewModel.userConfirmsToDeleteTherUsers = true
                //viewModel.userWantsDeleteUsers.toggle()
            } content: {
                HStack {
                    Text(
                        viewModel.selectedDeletedUsers.isEmpty
                        ? String(localized: "delete_user")
                        : "\(String(localized: "delete_users")) \(viewModel.selectedDeletedUsers.count)"
                    )                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.red.opacity(0.85))
                    
                    Image(systemName: "trash" )
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.red.opacity(0.85))
                        .frame(height: 20)
                }
            }
            .disabled(viewModel.selectedDeletedUsers.isEmpty)
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

#Preview {
    MainView()
}


