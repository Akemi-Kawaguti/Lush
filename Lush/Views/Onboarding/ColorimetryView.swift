//
//  ColorimetryView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 02/10/26.
//

import SwiftUI
import UIKit

struct ColorimetryView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let image: UIImage?

    @State private var showBiotypeMethod = false
    
    @State private var skinColor: Color?
    @State private var hairColor: Color?
    @State private var eyeColor: Color?

    var body: some View {
        VStack(spacing: 0) {

            ProgressBar(
                currentStep: 2,
                totalSteps: 4
            )
            .padding(.horizontal, 32)
            .padding(.top, 20)

            VStack(alignment: .leading, spacing: 10) {

                Text("Selecione suas cores")
                    .fontWeight(.bold)
                    .foregroundStyle(Color("textAttention"))

                VStack(alignment: .leading, spacing: 12) {
                    Text("Use o conta-gotas para selecionar uma cor de cada vez:")
                        .foregroundStyle(Color("quartenary"))
                        .fixedSize(horizontal: false, vertical: true)
                    BulletText(title: "Pele:", text: "posicione sobre a pele do rosto")
                    BulletText(title: "Cabelo:", text: "posicione sobre o cabelo")
                    BulletText(title: "Olhos:", text: "posicione sobre a íris")
                }
                .font(.callout)
                .lineSpacing(2)
            }
            .font(.callout)
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.top, 20)

            ColorSelectionCard(
                image: image,
                skinColor: $skinColor,
                hairColor: $hairColor,
                eyeColor: $eyeColor
            )
            .padding(.top, 16)

            Spacer()


            PrimaryButton(title: "Continuar") {
                showBiotypeMethod = true
            }
            .disabled(!hasAllColors)
            .opacity(hasAllColors ? 1 : 0.5)
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
        .toolbar {
            Toolbar(title: "Paleta de Cores", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showBiotypeMethod) {
            BiotypeMethodView()
        }
        .navigationBarBackButtonHidden(true)

    }

    private var hasAllColors: Bool {
        skinColor != nil && hairColor != nil && eyeColor != nil
    }
    
}

#Preview {
    NavigationStack {
        ColorimetryView(
            image: UIImage(named: "teste")
        )
    }
}
