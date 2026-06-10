//
//  MainView.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Random Users")
                Spacer()
            }
        }
        .task {
            await viewModel.fetchUsers()
        }
    }
}

extension MainView {
    
}

#Preview {
    MainView()
}
