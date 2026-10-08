//
//  UserIntroView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 05/10/26.
//

import SwiftUI
import SwiftData
import _PhotosUI_SwiftUI

struct UserIntroView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var viewModel = UserIntroViewModel()
    @FocusState private var isKeyboardOpen: Bool
    
    // Chamado ao continuar ou pular (nome e foto podem vir vazios)
    var onFinish: (_ name: String?, _ photo: UIImage?) -> Void = { _, _ in }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Como podemos te chamar?")
                        .fontWeight(.bold)
                        .foregroundStyle(Color("textAttention"))
                    
                    Text("Adicione seu nome e, se preferir, uma foto. Eles ficam salvos só no seu iPhone e você pode mudar depois em Configurações.")
                        .foregroundStyle(Color("quartenary"))
                        .lineSpacing(6)
                }
                .font(.callout)
                .padding(.top, 20)
                
                // Foto (toque para escolher da galeria)
                PhotosPicker(selection: $viewModel.photoItem, matching: .images) {
                    UserPhoto(image: viewModel.photo, size: 160)
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: viewModel.photo == nil ? "camera.fill" : "pencil")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(Color("button")))
                                .overlay(Circle().stroke(.white, lineWidth: 3))
                        }
                }
                .frame(maxWidth: .infinity)
                .accessibilityLabel(viewModel.photo == nil ? "Adicionar foto" : "Trocar foto")
                
                LushTextField(
                    title: "Seu nome",
                    placeholder: "Digite seu nome",
                    text: $viewModel.name
                )
                .focused($isKeyboardOpen)
                .textInputAutocapitalization(.words)
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 40)
            // Tocar fora do campo fecha o teclado
            .contentShape(Rectangle())
            .onTapGesture {
                isKeyboardOpen = false
            }
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        // Botões fixos embaixo
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 8) {
                PrimaryButton(title: "Continuar") {
                    isKeyboardOpen = false
                    viewModel.saveUser(modelContext: modelContext, isSkipped: false, onFinish: onFinish)
                }
                .disabled(!viewModel.hasName)
                .opacity(viewModel.hasName ? 1 : 0.5)
                
                Button("Pular por enquanto") {
                    isKeyboardOpen = false
                    viewModel.saveUser(modelContext: modelContext, isSkipped: true, onFinish: onFinish)
                }
                .font(.callout.weight(.semibold))
                .foregroundStyle(Color("button"))
                .frame(height: 44)
            }
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar {
            Toolbar(title: "Sobre você", action: nil, onBackClick: { dismiss() })
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        // Carrega a foto escolhida na galeria
        .onChange(of: viewModel.photoItem) {
            Task {
                await viewModel.loadPhoto()
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserIntroView()
    }
}
