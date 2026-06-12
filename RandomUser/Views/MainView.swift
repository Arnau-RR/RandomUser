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
    @FocusState private var isSearching: Bool
    
    var body: some View {
        NavigationStack {
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
//                                addMoreRandomUsers
//                                    .offset(y: 8)
//                                    .opacity(viewModel.userWantsDeleteUsers ? 0 : 1)
                                
                                deleteButton
                                    .opacity(viewModel.userWantsDeleteUsers ? 1 : 0)
                            }
                        }
                    }
                }
            }
            .navigationDestination(for: UserEntity.self) { user in
                ProfileView(user: user)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .searchable(text: $viewModel.searchText)
        .liquidGlassLoading(isPresented: $viewModel.isLoading, state: .loading(message: String(localized: "fetching_users")))
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
        .popupAlert(
            isPresented: $viewModel.userWantsMoreUsers,
            title: String(localized: "add_more_users"),
            message: String(localized: "how_many_users_want"),
            icon: "person.3.fill",
            textFieldText: $viewModel.userWantsToAddThisNumberOfUsers,
            textFieldPlaceholder: String(localized: "number_users"),
            buttons: [
                .cancel(),
                .primary(String(localized: "accept_button")) {
                    Task {
                        await viewModel.fetchUsers(userWantsMoreUsers: true)
                    }
                }
            ]
        )
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
            
            if !viewModel.userWantsDeleteUsers {
                GlassButtonComponent(padding: 10) {
                    viewModel.userWantsMoreUsers.toggle()
                } content: {
                    Image(systemName: "arrow.down" )
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.85))
                        .frame(height: 20)
                }
            }
            
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
                    ForEach(viewModel.filteredUsers) { result in
                        NavigationLink(value: result) {
                            UserListCell(
                                userEntity: result,
                                showCheckBoxButton: viewModel.userWantsDeleteUsers,
                                onCheckBoxTapped: { userSelected in
                                    viewModel.userCellCheckBoxPressed(userSelected)
                                }
                            )
                        }
                    }
                }
            }
            Spacer(minLength: 75)
        }
        .padding()
        .ignoresSafeArea()
    }
    
    var deleteButton: some View {
        
        HStack {
            GlassButtonComponent(padding: 10) {
                viewModel.userConfirmsToDeleteTherUsers = true
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
    
//    var addMoreRandomUsers: some View {
//        
//        HStack {
//            GlassButtonComponent(padding: 10) {
//                viewModel.userWantsMoreUsers = true
//            } content: {
//                HStack {
//                    Image(systemName: "arrow.down" )
//                        .font(.system(size: 15, weight: .semibold))
//                        .foregroundStyle(.blue.opacity(0.85))
//                        .frame(height: 20)
//                    
//                    Text(String(localized: "add_more_users"))
//                        .font(.system(size: 15, weight: .semibold))
//                        .foregroundStyle(.blue.opacity(0.85))
//                }
//            }
//        }
//        .padding(.horizontal, 20)
//        .padding(.vertical, 16)
//    }
}

extension View {
    @ViewBuilder
    func searchableIf(
        _ enabled: Bool,
        text: Binding<String>
    ) -> some View {
        if enabled {
            self.searchable(text: text)
        } else {
            self
        }
    }
}

#Preview {
    MainView()
}


