//
//  BiotypeMethodView.swift
//  Lush
//

import SwiftUI
import SwiftData

struct BiotypeMethodView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Query private var users: [UserModel]

    @State private var selectedMethod: BiotypeMethod? = nil
    @State private var showBiotypePhoto = false
    @State private var showMeasurements = false
    

    var body: some View {

        VStack(spacing: 0) {

            ProgressBar(
                currentStep: 3,
                totalSteps: 4
            )
            .padding(.horizontal, 32)
            .padding(.top, 20)

            VStack(alignment: .leading, spacing: 10) {

                Text("Como quer identificar o seu biotipo?")
                    .fontWeight(.bold)
                    .foregroundStyle(Color("textAttention"))

                Text("Analisamos as proporções dos seus ombros, cintura e quadril para calcular a sua silhueta.")
                    .lineSpacing(6)
                    .foregroundStyle(Color("quartenary"))

                Text("Escolha como prefere informar:")
                    .foregroundStyle(Color("quartenary"))
            }
            .font(.callout)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.horizontal, 32)
            .padding(.top, 20)


            VStack(spacing: 20) {

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
                    showMeasurements = true

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
        .toolbar {
            Toolbar(title: "Biotipo de Silhueta", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showBiotypePhoto) {
            BiotypePhotoView()
        }
        .navigationDestination(isPresented: $showMeasurements) {
            BiotypeMeasurementsView()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        BiotypeMethodView()
    }
}
