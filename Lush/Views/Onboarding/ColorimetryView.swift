//
//  ColorimetryView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 02/10/26.
//

import SwiftUI
import SwiftData

struct ColorimetryView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel: ColorimetryViewModel
    
    init(image: UIImage?, user: UserModel? = nil) {
        _viewModel = State(initialValue: ColorimetryViewModel(image: image, user: user))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            ProgressBar( currentStep: 2, totalSteps: 4)
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
                image: viewModel.image,
                skinColor: $viewModel.skinColor,
                hairColor: $viewModel.hairColor,
                eyeColor: $viewModel.eyeColor
            )
            .padding(.top, 16)
            
            Spacer()
            
            
            PrimaryButton(title: "Continuar") {viewModel.saveAnalysisAndProceed(modelContext: modelContext)}
            .disabled(!viewModel.hasAllColors)
            .opacity(viewModel.hasAllColors ? 1 : 0.5)
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
        .navigationDestination(isPresented: $viewModel.showBiotypeMethod) {
            BiotypeMethodView()
        }
        .navigationBarBackButtonHidden(true)
        
    }
    
}

#Preview {
    NavigationStack {
        ColorimetryView(image: UIImage(named: "teste")
        )
    }
}

