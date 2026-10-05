//
//  MyAreaView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

import SwiftUI

struct MyAreaView: View {

    // Dados de exemplo (depois virão do UserModel)
    let name = "Priscila"
    let photoName: String? = "userTest"   // foto de teste (Assets)
    let bodyShape: BodyShape = .hourglass
    let palette = "Outono Profundo"
    let paletteColors: [Color] = [
        Color(red: 0.49, green: 0.13, blue: 0.16),
        Color(red: 0.98, green: 0.52, blue: 0.08),
        Color(red: 0.36, green: 0.26, blue: 0.14),
        Color(red: 0.0, green: 0.52, blue: 0.62),
        Color(red: 0.05, green: 0.36, blue: 0.29),
        Color(red: 0.53, green: 0.08, blue: 0.36)
    ]

    @State private var showAnalysis = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {

                    Text("Minha área")
                        .font(.AppTypography.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    VStack(spacing: 12) {
                        UserPhoto(imageName: "user", size: 160)
                        Text(name)
                            .font(.AppTypography.title)
                    }

                    // Cards da paleta e do biotipo
                    HStack(spacing: 12) {
                        NavigationLink {
                            PaletteDetailView()
                        } label: {
                            paletteCard
                        }

                        NavigationLink {
                            BodyShapeDetailView()
                        } label: {
                            bodyShapeCard
                        }
                    }
                    .buttonStyle(.plain)
                    .fixedSize(horizontal: false, vertical: true)

                    PrimaryButton(title: "Refazer análise") {
                        showAnalysis = true
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .background {
                Image("backgroundLush")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 16))
                    }
                    .buttonStyle(.glassProminent)
                    .tint(Color("button"))
                    .buttonBorderShape(.circle)
                    .accessibilityLabel("Configurações")
                }
            }
            // Refazer análise: abre o fluxo por cima e fecha no final
            .fullScreenCover(isPresented: $showAnalysis) {
                NavigationStack {
                    ColorimetryPhotoView()
                }
                .environment(\.finishAnalysis) {
                    showAnalysis = false
                }
            }
        }
    }

    // Card da paleta
    var paletteCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sua paleta")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(palette)
                .font(.AppTypography.title3)

            // Cores em 2 linhas de 3
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                ForEach(paletteColors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 36, height: 36)
                }
            }
            .padding(.vertical, 8)

            Spacer(minLength: 0)
            seeDetails
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.gray.opacity(0.3), lineWidth: 1))
    }

    // Card do biotipo
    var bodyShapeCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Seu biotipo")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(bodyShape.rawValue)
                .font(.AppTypography.title3)

            Image(bodyShape.imageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 100)

            Spacer(minLength: 0)
            seeDetails
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.gray.opacity(0.3), lineWidth: 1))
    }

    var seeDetails: some View {
        HStack(spacing: 4) {
            Text("Ver detalhes")
            Image(systemName: "chevron.right")
        }
        .font(.footnote.weight(.semibold))
        .foregroundStyle(Color("button"))
    }
}

#Preview {
    MyAreaView()
}
