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

            ProgressBar(
                currentStep: 4,
                totalSteps: 4
            )
            .padding(.horizontal, 32)
            .padding(.top, 20)

            VStack(alignment: .leading, spacing: 12) {

                Text("Adicione uma foto do seu corpo")
                    .fontWeight(.bold)
                    .foregroundStyle(.black)

                Text("Para uma análise mais precisa:")

                BulletText(text: "Prefira uma foto de frente, com corpo visível e sem roupas muito largas")
                    .lineSpacing(6)
                    
            }
            .font(.callout)
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
                width: 326,
                height: 410
            )
            .padding(.top, 28)

            Spacer()

            PrimaryButton(title: "Ver resultado") {
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
        .toolbar {
            Toolbar(title: "Biotipo de Silhueta", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarTitleDisplayMode(.inline)
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
