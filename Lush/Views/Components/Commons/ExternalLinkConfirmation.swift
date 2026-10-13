//
//  ExternalLinkConfirmation.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 09/10/26.
//


import SwiftUI

struct ExternalLinkConfirmation: ViewModifier {
    @Environment(\.openURL) private var openURL

    @Binding var pendingURL: URL?
    let destinationName: String

    func body(content: Content) -> some View {
        content
            .alert(
                "Abrir link externo?",
                isPresented: Binding(
                    get: { pendingURL != nil },
                    set: { isPresented in
                        if !isPresented {
                            pendingURL = nil
                        }
                    }
                )
            ) {
                Button("Cancelar", role: .cancel) {
                    pendingURL = nil
                }

                Button("Continuar") {
                    guard let url = pendingURL else { return }
                    pendingURL = nil
                    openURL(url)
                }
            } message: {
                Text(
                    "Você sairá do Lush para abrir \(destinationName). Deseja continuar?"
                )
            }
    }
}

extension View {
    func confirmExternalLinks(
        pendingURL: Binding<URL?>,
        destinationName: String
    ) -> some View {
        modifier(
            ExternalLinkConfirmation(
                pendingURL: pendingURL,
                destinationName: destinationName
            )
        )
    }
}
