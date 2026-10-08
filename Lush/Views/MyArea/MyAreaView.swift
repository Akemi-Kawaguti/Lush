//
//  MyAreaView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

//
//  MyAreaView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//

import SwiftUI
import SwiftData

struct MyAreaView: View {

    // Injeta o contexto do SwiftData para buscar os dados salvos
        @Environment(\.modelContext) private var modelContext

        // Busca o UserModel cadastrado no banco (considerando que há um usuário principal)
        @Query private var users: [UserModel]

        @State private var showAnalysis = false
        @State private var showAnalysisHistory = false

        // Computa o usuário atual (pega o primeiro ou nulo se não houver)
        private var currentUser: UserModel? {
            users.first
        }

        // Computa a análise mais recente do usuário
        // Análise escolhida em "Minhas avaliações" (ou a mais recente)
        private var latestAnalysis: AnalysisModel? {
            currentUser?.currentAnalysis
        }

        // Converte a string do biotipo salva no banco para o enum BodyShape
        private var bodyShape: BodyShape {
            guard let silhouetteString = latestAnalysis?.userSilhouette else { return .hourglass }
            return BodyShape.allCases.first { $0.rawValue == silhouetteString } ?? .hourglass
        }

    // Nome do usuário salvo ou fallback dinâmico (se a string estiver vazia ou nula)
        private var userName: String {
            if let name = currentUser?.name, !name.trimmingCharacters(in: .whitespaces).isEmpty {
                return name
            }
            return "Convidado(a)" // Ou deixe vazio se preferir ocultar
        }

        // Nome da paleta salva (valida se o array existe e tem elementos válidos)
        private var paletteName: String {
            if let firstPalette = latestAnalysis?.userPalette.first, !firstPalette.isEmpty {
                return firstPalette
            }
            return "Não definida"
        }

        // Cores da paleta com base na estação detectada
        private var paletteColors: [Color] {
            guard let seasonName = latestAnalysis?.userPalette.first,
                  let seasonEnum = PaleteSeason.allCases.first(where: { $0.rawValue == seasonName }) else {
                // Fallback de cores caso não encontre
                return PaleteSeason.autumnDeep.colorPaletes.map { Color($0) }
            }
            
            // Mapeia os nomes dos assets da paleta para Cores do SwiftUI (ou Assets)
            return seasonEnum.colorPaletes.map { Color($0) }
        }

    var body: some View {
        NavigationStack {
                VStack(spacing: 30) {

                    Text("Minha área")
                        .font(.AppTypography.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color("titles"))

                    VStack(spacing: 12) {
                        // Se o usuário tiver foto em Data, converte para Image, senão usa o padrão
                                                if let photoData = currentUser?.photoData, let uiImage = UIImage(data: photoData) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 160, height: 160)
                                                        .clipShape(Circle())
                                                } else {
                                                    UserPhoto(imageName: "user", size: 160)
                                                }
                                                
                                                Text(userName)
                                                    .font(.AppTypography.title)
                                                    .foregroundStyle(Color("titles"))
                                            }

                    // Cards da paleta e do biotipo
                    HStack(spacing: 12) {
                        NavigationLink {
                            PaletteDetailView()
                        } label: {
                            paletteCard
                        }

                        NavigationLink {
                            // Passa a análise real encontrada no banco para a tela de detalhes do biotipo
                            if let analysis = latestAnalysis {
                                BodyShapeDetailView(analysis: analysis)
                            } else {
                                // Fallback caso não tenha análise salva ainda
                                BodyShapeDetailView(analysis: AnalysisModel(userSilhouette: "Ampulheta", userPalette: ["Outono Profundo"]))
                            }
                        } label: {
                            bodyShapeCard
                        }
                    }
                    .buttonStyle(.plain)
                    .fixedSize(horizontal: false, vertical: true)

                    PrimaryButton(title: "Refazer análise") {
                        showAnalysis = true
                    }
                    
                    Button {
                        showAnalysisHistory = true
                    } label: {
                        HStack(spacing: 4) {
                            Text("Ver minhas avaliações")

                            Image(systemName: "chevron.right")
                        }
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(Color("button"))
                    }
                    .buttonStyle(.plain)
                    .padding(.top, -8)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            
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
            
            .sheet(isPresented: $showAnalysisHistory) {
                AnalysisHistoryView()
                    .presentationDetents([.fraction(0.88)])
                    .presentationDragIndicator(.hidden)
                    .presentationCornerRadius(32)
            }
        }
    }

    // Card da paleta
    var paletteCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sua paleta")
                .font(.subheadline)
                .foregroundStyle(Color("textAttention").opacity(0.7))
            Text(paletteName)
                .font(.AppTypography.title3)
                .foregroundStyle(Color("titles"))

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
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color("borderLines"), lineWidth: 0.5))
    }

    // Card do biotipo
    var bodyShapeCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Seu biotipo")
                .font(.subheadline)
                .foregroundStyle(Color("textAttention").opacity(0.7))
            Text(bodyShape.rawValue)
                .font(.AppTypography.title3)
                .foregroundStyle(Color("titles"))

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
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color("borderLines"), lineWidth: 0.5))
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
