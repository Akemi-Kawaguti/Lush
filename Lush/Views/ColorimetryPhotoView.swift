//
//  ColorimetryPhotoView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 30/09/26.
//
//
//  ColorimetryPhotoView.swift
//  Lush
//

import SwiftUI

struct ColorimetryPhotoView: View {
    
    @State private var image: UIImage?
    @State private var showColorimetry = false
    
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
            
            
            ProgressBar(currentStep: 1,totalSteps: 4)
            .padding(.horizontal, 32)
            .padding(.top, 32)
            
            
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Adicione uma foto do seu rosto")
                    .font(.system(size: 16, weight: .bold))
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text("• Use uma foto com boa iluminação.")
                    
                    Text("• Evite filtros, sombras fortes e luzes coloridas.")
                    
                    Text("• Mantenha pele, cabelo e olhos visíveis.")
                }
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.quartenary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.top, 28)
            
            
            PhotoPicker(
                image: $image,
                title: "Adicione uma foto",
                width: 318,
                height: 302)
            .padding(.top, 60)
            
            Spacer()
            
          
            
            PrimaryButton(title: "Continuar") {
                showColorimetry = true
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
        .navigationDestination(isPresented: $showColorimetry) {
            ColorimetryView(image: image)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ColorimetryPhotoView()
}
