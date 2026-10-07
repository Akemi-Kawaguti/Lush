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
import SwiftData

struct ColorimetryPhotoView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var image: UIImage?
    @State private var showColorimetry = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ProgressBar(currentStep: 1,totalSteps: 4)
                .padding(.horizontal, 32)
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Adicione uma foto do seu rosto")
                    .fontWeight(.bold)
                    .foregroundStyle(Color("textAttention"))
                
                VStack(alignment: .leading, spacing: 12) {
                    BulletText(text: "Use uma foto com boa iluminação")
                    BulletText(text: "Evite filtros, sombra fortes e luzes coloridas")
                    BulletText(text: "Mantenha pele, cabelo e olhos visíveis")
                }
            }
            .font(.callout)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 32)
            .padding(.top, 28)
            
            PhotoPicker(
                image: $image,
                title: "Adicione uma foto",
                width: 326,
                height: 370
            )
            .padding(.top, 20)
            
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
        .toolbar {
            Toolbar(title: "Paleta de Cores", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showColorimetry) {
            ColorimetryView(image: image)
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    NavigationStack {
        ColorimetryPhotoView()
    }
}
