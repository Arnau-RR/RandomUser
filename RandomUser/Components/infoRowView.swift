//
//  infoRowView.swift
//  RandomUser
//
//  Created by Arnau on 11/06/2026.
//

import SwiftUI

func infoRowView(
    icon: String,
    title: String,
    value: String
) -> some View {
    HStack {
        Image(systemName: icon)
            .foregroundColor(.purple.opacity(0.8))
        
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
            
            Text("• \(value)")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.75))
        }
        
        Spacer()
    }
}
