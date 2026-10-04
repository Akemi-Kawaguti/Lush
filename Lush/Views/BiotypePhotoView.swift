//
//  BiotypePhotoView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 02/10/26.
//

import SwiftUI
import UIKit

struct BiotypePhotoView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var image: UIImage?
    
    @State private var showResult = false

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
                currentStep: 4,
                totalSteps: 4
            )
            .padding(.horizontal, 32)
            .padding(.top, 32)


            VStack(alignment: .leading, spacing: 12) {

                Text("Adicione uma foto do seu corpo")
                    .font(.system(size: 16,weight: .bold))
                    .foregroundStyle(.black)

                Text("Para uma análise mais precisa:")

                Text("• Prefira uma foto de frente, com corpo visível e sem roupas muito largas")
                    .padding(.leading, 8)
            }
            .font(
                .system(
                    size: 14,
                    weight: .regular
                )
            )
            .foregroundStyle(.quartenary)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.horizontal, 32)
            .padding(.top, 20)


            PhotoPicker(
                image: $image,
                title: "Adicione uma foto",
                width: 320,
                height: 410
            )
            .padding(.top, 24)

            Spacer()

            PrimaryButton(title: "Ver resultados") {
                showResult = true
            }
            .disabled(image == nil)
            .opacity(image == nil ? 0.5 : 1)
            .padding(.horizontal, 32)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showResult) {
            // TODO: usar o resultado real da análise
            ResultView(palette: .autumnDeep, bodyShape: .hourglass)
        }
    }
}

#Preview {
    NavigationStack {
        BiotypePhotoView()
    }
}
