//
//  SettingsView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 03/10/26.
//
//

import SwiftUI
import SwiftData
import PhotosUI

struct SettingsView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Query private var users: [UserModel]
    var currentUser: UserModel? { users.first }

    @State private var name = ""
    @State private var isEditing = false
    @State private var photoItem: PhotosPickerItem?
    @State private var pickedPhoto: UIImage?
    @FocusState private var isNameFocused: Bool

    // Foto salva no UserModel
    var savedPhoto: UIImage? {
        guard let data = currentUser?.photoData else { return nil }
        return UIImage(data: data)
    }

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
                            .foregroundStyle(Color("quartenary"))
                            .transition(.opacity)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

                // Mais informações
                VStack(alignment: .leading, spacing: 12) {
                    Text("Mais informações")
                        .font(.AppTypography.title3)
                        .foregroundStyle(Color("titles"))

                    VStack(spacing: 0) {
                        NavigationLink {
                            LegalDocumentView(
                                title: "Termos de Uso",
                                lastUpdated: TermsOfUse.lastUpdated,
                                content: TermsOfUse.content
                            )
                        } label: {
                            settingsRow(icon: "doc.text.fill", title: "Termos de Uso")
                        }

                        Rectangle()
                            .fill(Color("borderLines"))
                            .frame(height: 0.5)

                        NavigationLink {
                            LegalDocumentView(
                                title: "Política de Privacidade",
                                lastUpdated: PrivacyPolicy.lastUpdated,
                                content: PrivacyPolicy.content
                            )
                        } label: {
                            settingsRow(icon: "lock.shield.fill", title: "Política de Privacidade")
                        }
                    }
                    .buttonStyle(.plain)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.white))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color("borderLines"), lineWidth: 0.5))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .animation(.easeInOut, value: isEditing)
        }
        .scrollIndicators(.hidden)
        .lushBackground()
        .toolbar {
            Toolbar(
                title: "Configurações",
                action: isEditing ? .confirm : .edit,
                isActionEnabled: true,
                onBackClick: { dismiss() },
                onActionClick: {
                    isNameFocused = false
                    if isEditing { saveChanges() }
                    isEditing.toggle()
                }
            )
        }

        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        // Ao abrir a tela, mostra o nome salvo
        .onAppear {
            name = currentUser?.name ?? ""
        }
        // Carrega a foto escolhida na galeria (só aparece; é salva ao confirmar)
        .onChange(of: photoItem) {
            Task {
                if let data = try? await photoItem?.loadTransferable(type: Data.self) {
                    pickedPhoto = UIImage(data: data)
                }
            }
        }
    }

    // Salva nome e foto no UserModel
    func saveChanges() {
        let user = UserModel.current(in: modelContext)
        user.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if let pickedPhoto, let data = compressedPhotoData(pickedPhoto) {
            user.photoData = data
        }

        try? modelContext.save()
        pickedPhoto = nil
        photoItem = nil
    }

    // Diminui a foto antes de salvar (foto da câmera tem vários MB)
    func compressedPhotoData(_ image: UIImage) -> Data? {
        let maxSide: CGFloat = 800
        let largestSide = max(image.size.width, image.size.height)
        let scale = min(1, maxSide / largestSide)
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        let resized = UIGraphicsImageRenderer(size: newSize).image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return resized.jpegData(compressionQuality: 0.8)
    }

    // Foto: no modo edição ganha o selo de câmera e abre a galeria
    var photo: some View {
        PhotosPicker(selection: $photoItem, matching: .images) {
            UserPhoto(
                image: pickedPhoto ?? savedPhoto,
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
                Text(name.isEmpty ? "Convidado(a)" : name)
            }
        }
        .foregroundStyle(Color("textAttention"))
        .font(.AppTypography.title2)
        .padding(.horizontal, 32)
        .frame(height: 56)
        .frame(maxWidth: isEditing ? .infinity : nil)
        .background(Capsule().fill(.white))
        .overlay(
            Capsule().stroke(
                isEditing ? Color("button") : Color("borderLines"),
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
                .foregroundStyle(Color("quartenary").opacity(0.70))
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
    .modelContainer(for: UserModel.self, inMemory: true)
}
