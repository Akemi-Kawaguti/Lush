//
//  PresentationView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//
import SwiftUI

struct TermsView: View {

    @State private var viewModel = TermsViewModel()

    var body: some View {

        VStack(spacing: 0) {
            HStack {

                BackButton {
                    print("Voltar")
                }

                Spacer()

                Text("Termo de Uso")
                .font(.AppTypography.title3)

                Spacer()

         
                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)


            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    Text(TermsOfUse.content)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.gray)
                        .lineSpacing(6)
                }
                .padding(32)
                .frame(maxWidth: .infinity,alignment: .leading)
            }
            .onScrollGeometryChange(for: Bool.self) { geometry in

                let distanceFromBottom = geometry.contentSize.height - geometry.contentOffset.y - geometry.containerSize.height

                return distanceFromBottom <= 20

            } action: { _, reachedBottom in

                if reachedBottom {
                    viewModel.reachedEndOfTerms()
                }
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay {
                RoundedRectangle(cornerRadius: 24).stroke(Color.gray.opacity(0.25),lineWidth: 1)
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 16)


            HStack {

                Text("Li e aceito os termos de uso")
                    .font(.system(size: 14, weight: .regular))

                Spacer()

                Toggle("",isOn: $viewModel.hasAcceptedTerms)
                .labelsHidden()
                .tint(Color("assistantTertiary"))
                .disabled(!viewModel.hasReachedEnd)
            }
            .padding(.horizontal, 35)
            .padding(.vertical, 20)

      

            PrimaryButton(title: "Continuar") {
                print("Continuar")
            }
            .disabled(!viewModel.canContinue)
            .opacity(viewModel.canContinue ? 1 : 0.5)
            .padding(.horizontal, 32)
            .padding(.top, 20)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    TermsView()
}
