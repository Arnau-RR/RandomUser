//
//  PopupButton.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import SwiftUI

// MARK: - Popup Button Model
struct PopupButton {
    let title: String
    let role: Role
    let action: () -> Void

    enum Role {
        case primary      // Azul / accentColor – acción principal
        case destructive  // Rojo – acción peligrosa
        case cancel       // Neutro – cerrar / cancelar
    }

    static func primary(_ title: String, action: @escaping () -> Void) -> PopupButton {
        PopupButton(title: title, role: .primary, action: action)
    }
    static func destructive(_ title: String, action: @escaping () -> Void) -> PopupButton {
        PopupButton(title: title, role: .destructive, action: action)
    }
    static func cancel(_ title: String = String(localized: "button.close"), action: @escaping () -> Void = {}) -> PopupButton {
        PopupButton(title: title, role: .cancel, action: action)
    }
}

// MARK: - Public View extension (entry point)
extension View {

    func popupAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String? = nil,
        icon: String? = nil,
        iconColor: Color = .accentColor,
        textFieldText: Binding<String>? = nil,
        textFieldPlaceholder: String = "",
        buttons: [PopupButton]
    ) -> some View {
        modifier(PopupAlertModifier(
            isPresented: isPresented,
            title: title,
            message: message,
            icon: icon,
            iconColor: iconColor,
            textFieldText: textFieldText,
            textFieldPlaceholder: textFieldPlaceholder,
            buttons: buttons
        ))
    }
}

// MARK: - Modifier router
private struct PopupAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String?
    let icon: String?
    let iconColor: Color
    let textFieldText: Binding<String>?
    let textFieldPlaceholder: String
    let buttons: [PopupButton]

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .fullScreenCover(isPresented: $isPresented) {
                    LiquidGlassAlertScreen(
                        title: title, message: message,
                        icon: icon, iconColor: iconColor,
                        textFieldText: textFieldText,
                        textFieldPlaceholder: textFieldPlaceholder,
                        buttons: buttons,
                        onDismiss: { isPresented = false }
                    )
                    .presentationBackground(.clear)
                }
        } else {
            content
                .fullScreenCover(isPresented: $isPresented) {
                    FallbackAlertScreen(
                        title: title, message: message,
                        icon: icon, iconColor: iconColor,
                        textFieldText: textFieldText,
                        textFieldPlaceholder: textFieldPlaceholder,
                        buttons: buttons,
                        onDismiss: { isPresented = false }
                    )
                    .presentationBackground(.ultraThinMaterial)
                }
        }
    }
}

// MARK: ─────────────────────────────────────────
// MARK: iOS 26+  →  Liquid Glass
// MARK: ─────────────────────────────────────────

@available(iOS 26.0, *)
private struct LiquidGlassAlertScreen: View {
    let title: String
    let message: String?
    let icon: String?
    let iconColor: Color
    let textFieldText: Binding<String>?
    let textFieldPlaceholder: String
    let buttons: [PopupButton]
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            LiquidGlassAlertCard(
                title: title, message: message,
                icon: icon, iconColor: iconColor,
                textFieldText: textFieldText,
                textFieldPlaceholder: textFieldPlaceholder,
                buttons: buttons, onDismiss: onDismiss
            )
        }
    }
}

@available(iOS 26.0, *)
private struct LiquidGlassAlertCard: View {
    let title: String
    let message: String?
    let icon: String?
    let iconColor: Color
    let textFieldText: Binding<String>?
    let textFieldPlaceholder: String
    let buttons: [PopupButton]
    let onDismiss: () -> Void

    @State private var appear = false

    var body: some View {
        GlassEffectContainer {
            VStack(spacing: 20) {

                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(iconColor)
                        .symbolEffect(.bounce, value: appear)
                        .frame(width: 60, height: 60)
                }

                VStack(spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)

                    if let message {
                        Text(message)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    if let textFieldText {
                        TextField(textFieldPlaceholder, text: textFieldText)
                            .textFieldStyle(.roundedBorder)
                    }
                }

                glassButtonStack
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 28)
            .frame(width: 280)
            .glassEffect(.regular, in: .rect(cornerRadius: 28))
        }
        .scaleEffect(appear ? 1.0 : 0.85)
        .opacity(appear ? 1.0 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) { appear = true }
        }
    }

    // Renderiza cada botón directamente con @ViewBuilder — evita type-erase de ButtonStyle
    @ViewBuilder
    private var glassButtonStack: some View {
        if buttons.count == 2 {
            HStack(spacing: 10) {
                ForEach(Array(buttons.enumerated()), id: \.offset) { _, btn in
                    glassButton(btn)
                }
            }
        } else {
            VStack(spacing: 10) {
                ForEach(Array(buttons.enumerated()), id: \.offset) { _, btn in
                    glassButton(btn)
                }
            }
        }
    }

    @ViewBuilder
    private func glassButton(_ btn: PopupButton) -> some View {
        let label = btn.title
        let handler = { btn.action(); onDismiss() }

        switch btn.role {
        case .primary:
            Button(label, action: handler)
                .buttonStyle(.glassProminent)
                .frame(maxWidth: .infinity)

        case .destructive:
            Button(label, action: handler)
                .buttonStyle(.glassProminent)
                .tint(.red)
                .frame(maxWidth: .infinity)

        case .cancel:
            Button(label, action: handler)
                .buttonStyle(.glass)
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: ─────────────────────────────────────────
// MARK: iOS 15–25  →  Fallback (ultraThinMaterial)
// MARK: ─────────────────────────────────────────

private struct FallbackAlertScreen: View {
    let title: String
    let message: String?
    let icon: String?
    let iconColor: Color
    let textFieldText: Binding<String>?
    let textFieldPlaceholder: String
    let buttons: [PopupButton]
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            FallbackAlertCard(
                title: title, message: message,
                icon: icon, iconColor: iconColor,
                textFieldText: textFieldText,
                textFieldPlaceholder: textFieldPlaceholder,
                buttons: buttons, onDismiss: onDismiss
            )
        }
    }
}

private struct FallbackAlertCard: View {
    let title: String
    let message: String?
    let icon: String?
    let iconColor: Color
    let textFieldText: Binding<String>?
    let textFieldPlaceholder: String
    let buttons: [PopupButton]
    let onDismiss: () -> Void

    @State private var appear = false

    var body: some View {
        VStack(spacing: 20) {

            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 44, weight: .medium))
                    .foregroundStyle(iconColor)
                    .frame(width: 60, height: 60)
            }

            VStack(spacing: 6) {
                Text(title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                if let message {
                    Text(message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                if let textFieldText {
                    TextField(textFieldPlaceholder, text: textFieldText)
                        .textFieldStyle(.roundedBorder)
                }
            }

            fallbackButtonStack
        }
        .padding(.horizontal, 28)
        .padding(.vertical, 28)
        .frame(width: 280)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(.white.opacity(0.25), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.2), radius: 24, x: 0, y: 8)
        .scaleEffect(appear ? 1.0 : 0.85)
        .opacity(appear ? 1.0 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) { appear = true }
        }
    }

    @ViewBuilder
    private var fallbackButtonStack: some View {
        if buttons.count == 2 {
            HStack(spacing: 10) {
                ForEach(Array(buttons.enumerated()), id: \.offset) { _, btn in
                    fallbackButton(btn)
                }
            }
        } else {
            VStack(spacing: 10) {
                ForEach(Array(buttons.enumerated()), id: \.offset) { _, btn in
                    fallbackButton(btn)
                }
            }
        }
    }

    @ViewBuilder
    private func fallbackButton(_ btn: PopupButton) -> some View {
        let label = btn.title
        let handler = { btn.action(); onDismiss() }

        switch btn.role {
        case .primary:
            Button(label, action: handler)
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .frame(maxWidth: .infinity)

        case .destructive:
            Button(label, action: handler)
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .frame(maxWidth: .infinity)

        case .cancel:
            Button(label, action: handler)
                .buttonStyle(.bordered)
                .tint(.secondary)
                .frame(maxWidth: .infinity)
        }
    }
}
