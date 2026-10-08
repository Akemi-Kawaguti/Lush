//
//  BiotypeMeasurementsView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//
//  Passo 4 (opção "Digitar minhas medidas"): a usuária informa
//  ombros, cintura e quadril em centímetros e o biotipo é calculado.
//

import SwiftUI
import SwiftData

struct BiotypeMeasurementsView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // Query para buscar a usuária
    @Query private var users: [UserModel]

    // Instância do ViewModel
    @StateObject private var viewModel = BiotypeMeasurementsViewModel()
    @FocusState private var isKeyboardOpen: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                ProgressBar(currentStep: 4, totalSteps: 4)
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Envie suas medidas")
                        .fontWeight(.bold)
                        .foregroundStyle(Color("textAttention"))

                    Text("Informe sua medida em centímetros")
                        .foregroundStyle(Color("quartenary"))
                }
                .font(.callout)

                tipCard

                VStack(spacing: 20) {
                    MeasurementField(
                        imageName: "ombros",
                        title: "Ombros",
                        description: "Meça o contorno na altura dos ombros",
                        value: $viewModel.shoulder
                    )
                    MeasurementField(
                        imageName: "cintura",
                        title: "Cintura",
                        description: "Meça o contorno da parte mais fina da cintura",
                        value: $viewModel.waist
                    )
                    MeasurementField(
                        imageName: "quadril",
                        title: "Quadril",
                        description: "Meça o contorno da parte mais larga do quadril",
                        value: $viewModel.hip
                    )
                }
                .focused($isKeyboardOpen)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
            .contentShape(Rectangle())
            .onTapGesture {
                isKeyboardOpen = false
            }
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(title: "Ver resultado") {
                isKeyboardOpen = false
                viewModel.saveAndAnalyze(using: modelContext, users: users)
            }
            .disabled(!viewModel.isFormValid)
            .opacity(viewModel.isFormValid ? 1 : 0.5)
            .padding(.top, 12)
            .padding(.bottom, 16)
        }
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar {
            Toolbar(title: "Biotipo de Silhueta", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $viewModel.showResult) {
            if let analysis = viewModel.currentAnalysis {
                ResultView(analysis: analysis)
            }
        }
    }

    // Card de dica
    private var tipCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Dica")
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(Color("labels"))
                Image(systemName: "lightbulb.max")
                    .foregroundStyle(Color("button"))
            }
            Text("Utilize uma fita métrica e evite esticar a fita")
                .font(.subheadline)
                .foregroundStyle(Color("quartenary"))
        }
        .padding(17)
        .padding(.vertical, 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(Color.gray.opacity(0.3), lineWidth: 1))
    }
}

#Preview {
    NavigationStack {
        BiotypeMeasurementsView()
            .modelContainer(for: [UserModel.self, AnalysisModel.self, SizeSpecifications.self], inMemory: true)
    }
}

