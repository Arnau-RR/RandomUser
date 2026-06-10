//
//  GlassCardComponent.swift
//  AtmosSky
//
//  Created by Arnau on 15/05/2026.
//

import SwiftUI

struct GlassCardComponent<Content: View>: View {
    let width: CGFloat?
    let height: CGFloat?
    let cornerRadius: CGFloat
    let padding: CGFloat
    @ViewBuilder let content: Content

    init(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 28,
        padding: CGFloat = 20,
        @ViewBuilder content: () -> Content
    ) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        let shape = RoundedRectangle(
            cornerRadius: cornerRadius,
            style: .continuous
        )

        content
            .padding(padding)
            .frame(width: width, height: height)
            .background {
                ZStack {
                    shape
                        .fill(.ultraThinMaterial)
                        .opacity(0.20)

                    shape
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.08),
                                    Color.purple.opacity(0.04),
                                    Color.blue.opacity(0.02)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    shape
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.12),
                                    Color.white.opacity(0.02)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 0.8
                        )

                    shape
                        .stroke(
                            Color.white.opacity(0.02),
                            lineWidth: 2
                        )
                        .blur(radius: 3)
                        .clipShape(shape)
                }
            }
            .shadow(
                color: Color.black.opacity(0.12),
                radius: 16,
                x: 0,
                y: 8
            )
    }
}
