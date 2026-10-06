//
//  UserIntroView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 05/10/26.
//

import SwiftUI
import PhotosUI

struct UserIntroView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var photo: UIImage?
    @FocusState private var isKeyboardOpen: Bool

    // Chamado ao continuar ou pular (nome e foto podem vir vazios)
    var onFinish: (_ name: String?, _ photo: UIImage?) -> Void = { _, _ in }

    var hasName: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

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
                PhotosPicker(selection: $photoItem, matching: .images) {
                    UserPhoto(image: photo, size: 160)
                        .overlay(alignment: .bottomTrailing) {
                            Image(systemName: photo == nil ? "camera.fill" : "pencil")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(Circle().fill(Color("button")))
                                .overlay(Circle().stroke(.white, lineWidth: 3))
                        }
                }
                .frame(maxWidth: .infinity)
                .accessibilityLabel(photo == nil ? "Adicionar foto" : "Trocar foto")

                LushTextField(
                    title: "Seu nome",
                    placeholder: "Digite seu nome",
                    text: $name
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
                    onFinish(name.trimmingCharacters(in: .whitespaces), photo)
                }
                .disabled(!hasName)
                .opacity(hasName ? 1 : 0.5)

                Button("Pular por enquanto") {
                    isKeyboardOpen = false
                    onFinish(nil, nil)
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
        .onChange(of: photoItem) {
            Task {
                if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                    photo = UIImage(data: data)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        UserIntroView()
    }
}
