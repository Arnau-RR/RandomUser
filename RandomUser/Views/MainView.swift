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
        ZStack {
            VStack {
                Spacer()
                Text("Random Users")
                Spacer()
            }
        }
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
    
}

#Preview {
    MainView()
}
