//
//  ColorimetryView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 02/10/26.
//

import SwiftUI
import UIKit

struct ColorimetryView: View {
    
    let image: UIImage?


    var body: some View {
        VStack(spacing: 0) {


            HStack {

                BackButton {
                    print("Voltar")
                }

                Spacer()

                Text("Paleta de Cores")
                    .font(.AppTypography.title3)

                Spacer()

                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)


            ProgressBar(
                currentStep: 2,
                totalSteps: 4
            )
            .padding(.horizontal, 32)
            .padding(.top, 32)


            VStack(alignment: .leading, spacing: 16) {

                Text("Selecione suas cores")
                    .font(.system(size: 16,weight: .bold))

                VStack(alignment: .leading, spacing: 12) {

                    Text("Use o conta-gotas para selecionar uma cor de cada vez:")

                    Text("• Pele: posicione sobre a pele do rosto")

                    Text("• Cabelo: posicione sobre o cabelo")

                    Text("• Olhos: posicione sobre a íris")
                }
                .font(.system(size: 14,weight: .regular))
                .foregroundStyle(.quartenary)
                .lineSpacing(2)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.top, 20)


            ColorSelectionCard(
                image: image
            )
            .padding(.top, 32)

            Spacer()


            PrimaryButton(title: "Continuar") {
                print("Continuar")
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview {
    ColorimetryView(
        image: UIImage(named: "teste")
    )
}
