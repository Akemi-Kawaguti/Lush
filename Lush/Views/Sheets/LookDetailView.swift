//
//  LookDetailView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

//  Detalhes do look (abre em sheet): foto inteira, favoritar,

import SwiftUI

struct LookDetailView: View {

    @Environment(\.dismiss) private var dismiss
    
    @State private var pendingURL: URL?

    let look: Look
    let isFavorite: Bool
    let onFavorite: () -> Void

    var body: some View {
        NavigationStack {
            Color.clear
                
                // Card de informações
                .overlay(alignment: .bottom) {
                    infoCard
                        .padding(24)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color("titles"))
                                .frame(width: 32, height: 32)
                                .contentShape(Circle())
                        }
                        // Círculo branco: aparece bem em fotos escuras e claras
                        .buttonStyle(.glassProminent)
                        .buttonBorderShape(.circle)
                        .tint(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
                        .accessibilityLabel("Fechar")
                    }

                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: onFavorite) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .fontWeight(.semibold)
                                .foregroundStyle(isFavorite ? Color("button") : Color("titles"))
                                .frame(width: 32, height: 32)
                                .contentShape(Circle())
                        }
                        // Mesmo círculo branco do fechar; coração rosa quando favoritado
                        .buttonStyle(.glassProminent)
                        .buttonBorderShape(.circle)
                        .tint(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.15), radius: 6, y: 2)
                        .accessibilityLabel(isFavorite ? "Remover dos favoritos" : "Favoritar")
                    }
                }
        }
        .presentationBackground {
            LookImage(imageName: look.imageName, url: look.highResImageURL, fallbackURL: look.largeImageURL)
        }
        .presentationDragIndicator(.visible)
        .confirmExternalLinks(
            pendingURL: $pendingURL,
            destinationName: "o site do Pexels"
        )
    }

    var infoCard: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Por que combina com você")
                    .font(.subheadline)
                Text(look.reason)
                    .font(.AppTypography.title2)
                    .multilineTextAlignment(.center)
            }
            .shadow(color: .black.opacity(0.3), radius: 4, y: 2)

            Rectangle()
                .fill(.white.opacity(0.8))
                .frame(height: 1)

            // Crédito da foto
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("foto por")
                        .font(.caption)
                    Text(look.photographer)
                        .font(.subheadline)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Foto fornecida pelo Pexels")
                        .font(.caption)
                    if let url = look.pexelsURL {
                        Button {
                            pendingURL = url
                        } label: {
                            Text("Ver no Pexels")
                                .font(.caption)
                                .underline()
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
        }
        .foregroundStyle(.white)
        .padding(24)
        .glassEffect(.regular.tint(.black.opacity(0.6)), in: RoundedRectangle(cornerRadius: 32))
    }
}

#Preview {
    Text("Tela de fundo")
        .sheet(isPresented: .constant(true)) {
            LookDetailView(look: Look.samples[0], isFavorite: false, onFavorite: {})
        }
}
