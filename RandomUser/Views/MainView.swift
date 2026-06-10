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
                Spacer()
                userList
            }
        }
        .liquidGlassLoading(isPresented: $viewModel.isLoading, state: .loading(message: String(localized: "fetching_users")))
        
        .onAppear() {
            viewModel.configure(modelContext: modelContext)
        }
        .task {
            await viewModel.checkUsersStored()
            await viewModel.fetchUsers()
        }
    }
}

extension MainView {
    
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


