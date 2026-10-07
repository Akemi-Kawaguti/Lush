//
//  BiotypePhotoView.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 02/10/26.
//

import SwiftUI
import UIKit
import SwiftData

struct BiotypePhotoView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [UserModel]
    
    @State private var image: UIImage?
    @State private var viewModel = BiotypePhotoSave()
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ProgressBar(
                currentStep: 4,
                totalSteps: 4
            )
            .padding(.horizontal, 32)
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Adicione uma foto do seu corpo")
                    .fontWeight(.bold)
                    .foregroundStyle(Color("textAttention"))
                
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
            .padding(.top, 20)
            
            Spacer()
            
            PrimaryButton(title: viewModel.isLoading ? "Analisando..." : "Ver resultado") {
                Task {
                    await viewModel.processPhotoAndSave(
                        image: image,
                        modelContext: modelContext,
                        users: users
                    )                            }
            }
            .disabled(image == nil || viewModel.isLoading )
            .opacity(image == nil || viewModel.isLoading  ? 0.5 : 1)
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
        .navigationDestination(isPresented: $viewModel.showResult) {
            
            if let analysis = viewModel.createdAnalysis {
                ResultView(analysis: analysis)        }}
    }
}

#Preview {
    NavigationStack {
        BiotypePhotoView()
    }
}
