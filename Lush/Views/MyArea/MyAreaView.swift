//
//  MyAreaView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

import SwiftUI
import SwiftData

struct MyAreaView: View {

    @Environment(\.modelContext) private var modelContext

    // Usuária do app (o app tem uma usuária só)
    @Query private var users: [UserModel]

    @State private var showAnalysis = false
    @State private var showAnalysisHistory = false
    @State private var startNewAnalysisAfterHistory = false   // "Refazer análise" tocado na sheet

    private var currentUser: UserModel? {
        users.first
    }

    // Análise escolhida em "Minhas avaliações" (ou a mais recente)
    private var latestAnalysis: AnalysisModel? {
        currentUser?.currentAnalysis
    }

    private var bodyShape: BodyShape {
        currentUser?.currentBodyShape ?? .hourglass
    }

    private var palette: PaleteSeason {
        currentUser?.currentPalette ?? .autumnDeep
    }

    // Nome salvo ou "Convidado(a)" se a usuária pulou essa etapa
    private var userName: String {
        if let name = currentUser?.name, !name.trimmingCharacters(in: .whitespaces).isEmpty {
            return name
        }
        return "Convidado(a)"
    }

    // Nome da paleta ou "Não definida" se ainda não houver análise
    private var paletteName: String {
        latestAnalysis == nil ? "Não definida" : palette.rawValue
    }

    private var paletteColors: [Color] {
        palette.colorPaletes.map { Color($0) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // Título e botão de configurações na mesma linha
                    HStack {
                        Text("Minha área")
                            .font(.AppTypography.largeTitle)
                            .foregroundStyle(Color("titles"))
                            .padding(.horizontal, 24)

                        Spacer()

                        NavigationLink {
                            SettingsView()
                        } label: {
                            // O estilo do botão acrescenta margem em volta do ícone
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .frame(width: 30, height: 30)   // largura = altura: círculo perfeito
                        }
                        .buttonStyle(.glassProminent)
                        .buttonBorderShape(.circle)
                        .tint(Color("button"))
                        .accessibilityLabel("Configurações")
                        .padding(.horizontal, 18)
                    }
                    .padding(.top, 20)
                    

                    // Foto e nome
                    VStack(spacing: 8) {
                        if let data = currentUser?.photoData, let uiImage = UIImage(data: data) {
                            UserPhoto(image: uiImage, size: 160)
                        } else {
                            UserPhoto(size: 160)
                        }

                        Text(userName)
                            .font(.AppTypography.title2)
                            .foregroundStyle(Color("titles"))
                    }

                    // Cards da paleta e do biotipo (mesma altura)
                    HStack(spacing: 12) {
                        NavigationLink {
                            PaletteDetailView()
                        } label: {
                            paletteCard
                        }

                        NavigationLink {
                            if let analysis = latestAnalysis {
                                BodyShapeDetailView(analysis: analysis)
                            } else {
                                BodyShapeDetailView(analysis: AnalysisModel(userSilhouette: bodyShape.rawValue, userPalette: [palette.rawValue]))
                            }
                        } label: {
                            bodyShapeCard
                        }
                    }
                    .padding(.horizontal, 24)
                    .buttonStyle(.plain)
                    .fixedSize(horizontal: false, vertical: true)

                    // Ações
                    VStack(spacing: 12) {
                        PrimaryButton(title: "Fazer uma nova avaliação") {
                            showAnalysis = true
                        }
                        .padding(.top, 8)

                        Button {
                            showAnalysisHistory = true
                        } label: {
                            HStack(spacing: 4) {
                                Text("Ver minhas avaliações")
                                Image(systemName: "chevron.right")
                                    .imageScale(.small)
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(Color("button"))
                            .padding(.top, 10)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)   // só rola se não couber na tela
            .lushBackground()
            // O título e o botão de configurações ficam no conteúdo, não na barra de navegação
            .toolbar(.hidden, for: .navigationBar)
            // Nova avaliação: abre o fluxo por cima e fecha no final
            .fullScreenCover(isPresented: $showAnalysis) {
                NavigationStack {
                    ColorimetryPhotoView()
                }
                .environment(\.finishAnalysis) {
                    showAnalysis = false
                }
            }
            // Histórico de avaliações (mesmo esquema das outras sheets: NavigationStack + SheetToolbar)
            .sheet(isPresented: $showAnalysisHistory, onDismiss: {
                // "Refazer análise" na sheet: abre o fluxo depois que a sheet terminar de fechar
                if startNewAnalysisAfterHistory {
                    startNewAnalysisAfterHistory = false
                    showAnalysis = true
                }
            }) {
                NavigationStack {
                    AnalysisHistoryView(onNewAnalysis: {
                        startNewAnalysisAfterHistory = true
                    })
                }
            }
        }
    }

    // MARK: - Card da paleta

    var paletteCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Sua paleta:")
                .font(.subheadline)
                .foregroundStyle(Color("quartenary"))

            Text(paletteName)
                .font(.AppTypography.title3)
                .foregroundStyle(Color("titles"))
                .fixedSize(horizontal: false, vertical: true)

            paletteRing
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)

            Spacer(minLength: 0)
            seeDetails
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 28).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color("borderLines"), lineWidth: 0.5))
    }

    // Anel com as cores da paleta (uma fatia por cor)
    var paletteRing: some View {
        let lineWidth: CGFloat = 20

        return ZStack {
            ForEach(paletteColors.indices, id: \.self) { index in
                Circle()
                    .trim(
                        from: CGFloat(index) / CGFloat(paletteColors.count),
                        to: CGFloat(index + 1) / CGFloat(paletteColors.count)
                    )
                    .stroke(paletteColors[index], lineWidth: lineWidth)
            }
        }
        .rotationEffect(.degrees(-90))
        .frame(width: 92, height: 92)
        .padding(lineWidth / 2)   // a borda do anel fica metade para fora do círculo
        .accessibilityLabel("Cores da paleta \(paletteName)")
    }

    // MARK: - Card do biotipo

    var bodyShapeCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Seu biotipo:")
                .font(.subheadline)
                .foregroundStyle(Color("quartenary"))

            Text(bodyShape.rawValue)
                .font(.AppTypography.title3)
                .foregroundStyle(Color("titles"))
                .fixedSize(horizontal: false, vertical: true)

            Image(bodyShape.resultImageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 128)
                .padding(.vertical, 10)
                .accessibilityHidden(true)

            Spacer(minLength: 0)
            seeDetails
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 28).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color("borderLines"), lineWidth: 0.5))
    }

    // MARK: - "Ver detalhes >"

    var seeDetails: some View {
        HStack(spacing: 4) {
            Text("Ver detalhes")
            Image(systemName: "chevron.right")
                .imageScale(.small)
        }
        .font(.footnote)
        .fontWeight(.regular)
        .foregroundStyle(Color("button"))
    }
}

#Preview {
    MyAreaView()
        .modelContainer(for: [UserModel.self, AnalysisModel.self], inMemory: true)
}
