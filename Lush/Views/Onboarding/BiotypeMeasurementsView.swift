//
//  BiotypeMeasurementsView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 04/10/26.
//

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
    @Environment(\.modelContext) private var modelContext // 2. Contexto do banco de dados

    // Query para buscar a usuária (ajuste conforme a lógica de autenticação/perfil do seu app)
    @Query private var users: [UserModel]

    @State private var shoulder = ""
    @State private var waist = ""
    @State private var hip = ""

    @State private var showResult = false
    @FocusState private var isKeyboardOpen: Bool
    
    // Armazena a análise criada para passar para a tela de resultado se necessário
    @State private var currentAnalysis: AnalysisModel?

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
                        description: "Meça o comprimento dos ombros",
                        value: $shoulder
                    )
                    MeasurementField(
                        imageName: "cintura",
                        title: "Cintura",
                        description: "Meça o comprimento da cintura",
                        value: $waist
                    )
                    MeasurementField(
                        imageName: "quadril",
                        title: "Quadril",
                        description: "Meça o comprimento do quadril",
                        value: $hip
                    )
                }
                .focused($isKeyboardOpen)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
            // Tocar fora dos campos fecha o teclado
            .contentShape(Rectangle())
            .onTapGesture {
                isKeyboardOpen = false
            }
        }
        .scrollIndicators(.hidden)
        // Arrastar a tela para baixo também fecha o teclado
        .scrollDismissesKeyboard(.interactively)
        // Botão fixo embaixo
        .safeAreaInset(edge: .bottom) {
            PrimaryButton(title: "Ver resultado") {
                isKeyboardOpen = false
                saveAndAnalyze()
            }
            .disabled(!isFormValid)
            .opacity(isFormValid ? 1 : 0.5)
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
        .navigationDestination(isPresented: $showResult) {
            // TODO: usar a paleta real da análise de cores
            ResultView(palette: .autumnDeep, bodyShape: bodyShape)
        }
    }

    // Card de dica
    var tipCard: some View {
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

    // Converte o texto em número (aceita "48" ou "48,5")
    func number(_ text: String) -> Double? {
        Double(text.replacingOccurrences(of: ",", with: "."))
    }

    // Só libera o botão com as 3 medidas preenchidas e com valores possíveis
    var isFormValid: Bool {
        [shoulder, waist, hip].allSatisfy { text in
            guard let value = number(text) else { return false }
            return value >= 20 && value <= 250
        }
    }

    // Calcula o biotipo com as funções que já existem no projeto
    // (BodyConversion.swift e BodyMath.swift)
    var bodyShape: BodyShape {
        let measure = processBodyData(from: .manual(
            shoulderCm: number(shoulder) ?? 0,
            waistCm: number(waist) ?? 0,
            hipCm: number(hip) ?? 0
        ))
        return mathBodyShape(measurements: measure)
    }
    // MARK: - Integração com o Banco de Dados (SwiftData)
        private func saveAndAnalyze() {
            guard let sVal = number(shoulder),
                  let wVal = number(waist),
                  let hVal = number(hip) else { return }

            // 1. Recupera ou cria uma usuária padrão caso ainda não exista no banco
            let currentUser: UserModel
            if let existingUser = users.first {
                currentUser = existingUser
            } else {
                currentUser = UserModel(name: "Usuária Lush")
                modelContext.insert(currentUser)
            }

            // 2. Cria o objeto de especificações de tamanho
            let sizeSpecs = SizeSpecifications(
                shoulderSize: sVal,
                waistSize: wVal,
                hipSize: hVal,
                user: currentUser
            )
            modelContext.insert(sizeSpecs)

            // 3. Monta o BodyMeasure para o serviço de análise
            let measurements = BodyMeasure(shoulder: sVal, waist: wVal, hip: hVal)

            // 4. Executa o serviço de análise (gera o AnalysisModel integrando biotipo e cores)
            // Nota: se você tiver amostras de cores reais capturadas em outra tela, passe-as no dicionário.
            let newAnalysis = AnalysisService.performNewAnalysis(
                measurements: measurements,
                colorSamples: [:],
                user: currentUser
            )

            // Associa as especificações de tamanho à análise
            newAnalysis.sizeSpecifications = sizeSpecs

            // Salva a análise no contexto
            modelContext.insert(newAnalysis)

            do {
                try modelContext.save()
                self.currentAnalysis = newAnalysis
                self.showResult = true // Dispara a navegação
            } catch {
                print("Erro ao salvar dados no SwiftData: \(error.localizedDescription)")
            }
        }
    }

    #Preview {
        NavigationStack {
            BiotypeMeasurementsView()
                .modelContainer(for: [UserModel.self, AnalysisModel.self, SizeSpecifications.self], inMemory: true)
        }
    }
