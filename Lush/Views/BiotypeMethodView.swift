//
//  BiotypeMethodView.swift
//  Lush
//

import SwiftUI

struct BiotypeMethodView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedMethod: BiotypeMethod? = nil
    @State private var showBiotypePhoto = false

    var body: some View {

        VStack(spacing: 0) {


            HStack {

                BackButton {
                    dismiss()
                }

                Spacer()

                Text("Biotipo de Silhueta")
                    .font(.AppTypography.title3)

                Spacer()

                Color.clear
                    .frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)


            ProgressBar(
                currentStep: 3,
                totalSteps: 4
            )
            .padding(.horizontal, 32)
            .padding(.top, 32)


            VStack(alignment: .leading, spacing: 16) {

                Text("Como quer identificar o seu biotipo?")
                    .font(.system(size: 16,weight: .bold))
                    .foregroundStyle(.black)

                Text("Analisamos as proporções dos seus ombros, cintura e quadril para calcular a sua silhueta.")

                Text("Escolha como prefere informar:")
            }
            .font(.system(size: 14,weight: .regular))
            .foregroundStyle(.quartenary)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.horizontal, 32)
            .padding(.top, 28)


            VStack(spacing: 40) {

                BiotypeMethodCard(
                    title: "Análise por foto",
                    subtitle: "Análise automática e com maior precisão",
                    isSelected: selectedMethod == .photo
                ) {
                    selectedMethod = .photo
                }

                BiotypeMethodCard(
                    title: "Digitar minhas medidas",
                    subtitle: "Análise com menor precisão",
                    isSelected: selectedMethod == .measurements
                ) {
                    selectedMethod = .measurements
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)

            Spacer()


            PrimaryButton(title: "Continuar") {

                switch selectedMethod {

                case .photo:
                    showBiotypePhoto = true

                case .measurements:
                    print("Ir para tela de medidas")

                case .none:
                    break
                }
            }
            .disabled(selectedMethod == nil)
            .opacity(selectedMethod == nil ? 0.5 : 1)
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .navigationDestination(isPresented: $showBiotypePhoto) {
            BiotypePhotoView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    BiotypeMethodView()
}
