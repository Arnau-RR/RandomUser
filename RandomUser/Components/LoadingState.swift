//
//  LoadingState.swift
//  RandomUser
//
//  Created by Arnau on 10/06/2026.
//

import SwiftUI

// MARK: - Loading State
enum LoadingState {
    case loading(message: String)
    case success(message: String)
    case failure(message: String)

    var title: String {
        switch self {
        case .loading(let msg), .success(let msg), .failure(let msg): return msg
        }
    }

    var subtitle: String {
        switch self {
        case .loading:  return String(localized: "please_wait")
        case .success:  return String(localized: "operation_completed")
        case .failure:  return String(localized: "error_ocurred")
        }
    }
}

// MARK: - Public extension (entry point, funciona en cualquier iOS)
extension View {
    func liquidGlassLoading(
        isPresented: Binding<Bool>,
        state: LoadingState = .loading(message: String(localized: "loading"))
    ) -> some View {
        modifier(LoadingPopupModifier(isPresented: isPresented, state: state))
    }
}

// MARK: - Modifier router
private struct LoadingPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    let state: LoadingState

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .fullScreenCover(isPresented: $isPresented) {
                    LiquidGlassLoadingScreen(state: state) {
                        isPresented = false
                    }
                    .presentationBackground(.clear)
                }
        } else {
            content
                .fullScreenCover(isPresented: $isPresented) {
                    FallbackLoadingScreen(state: state) {
                        isPresented = false
                    }
                    .presentationBackground(.ultraThinMaterial)
                }
        }
    }
}

// MARK: ─────────────────────────────────────────
// MARK: iOS 26+  →  Liquid Glass
// MARK: ─────────────────────────────────────────

@available(iOS 26.0, *)
private struct LiquidGlassLoadingScreen: View {
    let state: LoadingState
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            LiquidGlassPopupCard(state: state, onDismiss: onDismiss)
        }
    }
}

@available(iOS 26.0, *)
private struct LiquidGlassPopupCard: View {
    let state: LoadingState
    let onDismiss: () -> Void

    @State private var rotationAngle: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var appear = false

    var body: some View {
        GlassEffectContainer {
            VStack(spacing: 20) {
                // Icono / Spinner
                ZStack {
                    switch state {
                    case .loading:
                        glassSpinner
                    case .success:
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 44, weight: .medium))
                            .foregroundStyle(.green)
                            .symbolEffect(.bounce, value: appear)
                    case .failure:
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 44, weight: .medium))
                            .foregroundStyle(.red)
                            .symbolEffect(.bounce, value: appear)
                    }
                }
                .frame(width: 60, height: 60)

                // Texto
                VStack(spacing: 6) {
                    Text(state.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(state.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Botón cerrar (solo en estados finales)
                if case .loading = state { } else {
                    Button(String(localized: "button.close"), action: onDismiss)
                        .buttonStyle(.glass)
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 32)
            .frame(width: 260)
            .glassEffect(.regular, in: .rect(cornerRadius: 28))
        }
        .scaleEffect(appear ? 1.0 : 0.85)
        .opacity(appear ? 1.0 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) { appear = true }
            withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) { rotationAngle = 360 }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) { pulseScale = 1.3 }
        }
    }

    private var glassSpinner: some View {
        ZStack {
            Circle()
                .trim(from: 0.15, to: 1.0)
                .stroke(
                    AngularGradient(
                        colors: [.clear, .white.opacity(0.9)],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .rotationEffect(.degrees(rotationAngle))
                .frame(width: 52, height: 52)

            Circle()
                .fill(.white.opacity(0.15))
                .frame(width: 28, height: 28)
                .scaleEffect(pulseScale)

            Circle()
                .fill(.white.opacity(0.7))
                .frame(width: 8, height: 8)
        }
    }
}

// MARK: ─────────────────────────────────────────
// MARK: iOS 15–25  →  Fallback (ultraThinMaterial)
// MARK: ─────────────────────────────────────────

private struct FallbackLoadingScreen: View {
    let state: LoadingState
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            FallbackPopupCard(state: state, onDismiss: onDismiss)
        }
    }
}

private struct FallbackPopupCard: View {
    let state: LoadingState
    let onDismiss: () -> Void

    @State private var rotationAngle: Double = 0
    @State private var appear = false

    var body: some View {
        VStack(spacing: 20) {
            // Icono / Spinner
            ZStack {
                switch state {
                case .loading:
                    fallbackSpinner
                case .success:
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(.green)
                case .failure:
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(.red)
                }
            }
            .frame(width: 60, height: 60)

            // Texto
            VStack(spacing: 6) {
                Text(state.title)
                    .font(.headline)
                    .lineLimit(1)

                Text(state.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Botón cerrar
            if case .loading = state { } else {
                Button(String(localized: "button.close"), action: onDismiss)
                    .buttonStyle(.bordered)
            }
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 32)
        .frame(width: 260)
        // Frosted glass clásico con ultraThinMaterial
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
            withAnimation(.linear(duration: 1.1).repeatForever(autoreverses: false)) { rotationAngle = 360 }
        }
    }

    private var fallbackSpinner: some View {
        ZStack {
            Circle()
                .trim(from: 0.15, to: 1.0)
                .stroke(
                    AngularGradient(
                        colors: [.clear, Color.accentColor],
                        center: .center
                    ),
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .rotationEffect(.degrees(rotationAngle))
                .frame(width: 52, height: 52)

            Circle()
                .fill(Color.accentColor.opacity(0.1))
                .frame(width: 28, height: 28)

            Circle()
                .fill(Color.accentColor.opacity(0.7))
                .frame(width: 8, height: 8)
        }
    }
}
