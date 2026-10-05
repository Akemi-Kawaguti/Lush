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

struct BiotypeMeasurementsView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var shoulder = ""
    @State private var waist = ""
    @State private var hip = ""

    @State private var showResult = false
    @FocusState private var isKeyboardOpen: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

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

                VStack(spacing: 28) {
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
                showResult = true
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
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 24).fill(.white))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(Color.gray.opacity(0.3), lineWidth: 1))
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
}

#Preview {
    NavigationStack {
        BiotypeMeasurementsView()
    }
}
