//
//  SettingsView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//
//
//  SettingsView.swift
//  Lush
//
//  Tela "Configurações": foto, nome, termos e privacidade.
//  O ✎ entra no modo de edição (foto e nome) e vira ✓ para salvar.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var name = "Priscila"
    @State private var isEditing = false
    @State private var photoItem: PhotosPickerItem?
    @State private var pickedPhoto: UIImage?
    @FocusState private var isNameFocused: Bool

    let photoName: String? = "userTest"   // foto de teste (Assets)

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {

                // Foto e nome
                VStack(spacing: 16) {
                    photo
                    nameField

                    if isEditing {
                        Text("Toque na foto ou no nome para editar")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .transition(.opacity)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

                // Mais informações
                VStack(alignment: .leading, spacing: 12) {
                    Text("Mais informações")
                        .font(.AppTypography.title3)

                    VStack(spacing: 0) {
                        NavigationLink {
                            // TODO: tela de termos de uso
                            Text("Termos de Uso")
                        } label: {
                            settingsRow(icon: "doc.text.fill", title: "Termos de Uso")
                        }

                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 0.5)
                    
                        NavigationLink {
                            // TODO: tela de política de privacidade
                            Text("Política de Privacidade")
                        } label: {
                            settingsRow(icon: "lock.shield.fill", title: "Política de Privacidade")
                        }
                    }
                    .buttonStyle(.plain)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.white))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .animation(.easeInOut, value: isEditing)
        }
        .scrollIndicators(.hidden)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .toolbar {
            Toolbar(
                title: "Configurações",
                action: isEditing ? .confirm : .edit,
                isActionEnabled: !name.trimmingCharacters(in: .whitespaces).isEmpty,
                onBackClick: { dismiss() },
                onActionClick: {
                    // TODO: ao confirmar, salvar nome e foto no UserModel
                    isNameFocused = false
                    isEditing.toggle()
                }
            )
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        // Carrega a foto escolhida na galeria
        .onChange(of: photoItem) {
            Task {
                if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                    pickedPhoto = UIImage(data: data)
                }
            }
        }
    }

    // Foto: no modo edição ganha o selo de câmera e abre a galeria
    var photo: some View {
        PhotosPicker(selection: $photoItem, matching: .images) {
            UserPhoto(
                imageName: "user",
                image: pickedPhoto,
                size: 160,
                borderColor: isEditing ? Color("button") : Color("tertiary").opacity(0.75)
            )
            .overlay(alignment: .bottomTrailing) {
                if isEditing {
                    Image(systemName: "camera.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Color("button")))
                        .overlay(Circle().stroke(.white, lineWidth: 3))
                        .transition(.scale)
                }
            }
        }
        .disabled(!isEditing)
        .accessibilityLabel(isEditing ? "Trocar foto" : "Sua foto")
    }

    // Nome: no modo edição vira campo com lápis e borda rosa
    var nameField: some View {
        Group {
            if isEditing {
                TextField("Seu nome", text: $name)
                    .multilineTextAlignment(.center)
                    .focused($isNameFocused)
                    .submitLabel(.done)
                    .padding(.horizontal, 28)   // espaço pro lápis sem empurrar o nome
                    .overlay(alignment: .trailing) {
                        Image(systemName: "pencil")
                            .foregroundStyle(Color("button"))
                    }
            } else {
                Text(name)
            }
        }
        .font(.AppTypography.title2)
        .padding(.horizontal, 32)
        .frame(height: 56)
        .frame(maxWidth: isEditing ? .infinity : nil)
        .background(Capsule().fill(.white))
        .overlay(
            Capsule().stroke(
                isEditing ? Color("button") : Color.gray.opacity(0.3),
                lineWidth: isEditing ? 2 : 1
            )
        )
        .contentShape(Capsule())
        .onTapGesture {
            if isEditing { isNameFocused = true }
        }
    }

    func settingsRow(icon: String, title: String) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color("button")))
            Text(title)
                .foregroundStyle(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color("borderLines"))
                .padding(.horizontal, 10)
        }
        .padding(16)
        .contentShape(Rectangle())
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
