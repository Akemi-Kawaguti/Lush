//
//  AddClothingView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

import SwiftUI

struct AddClothingView: View {

    @Environment(\.dismiss) private var dismiss

    private let positions = GarmentPosition.allCases

    @State private var image: UIImage?
    @State private var name = ""
    @State private var position: GarmentPosition?
    @State private var category: GarmentCategory?

    /// Categorias compatíveis com o tipo escolhido no primeiro picker
    private var categories: [GarmentCategory] {
        guard let position else { return [] }
        return GarmentCategory.allCases.filter { $0.position == position }
    }

    /// O ✓ só fica ativo com tudo preenchido
    private var isFormComplete: Bool {
        image != nil
            && !name.trimmingCharacters(in: .whitespaces).isEmpty
            && category != nil
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Título + subtítulo
                    ScreenHeader(
                        title: "Cadastrar roupa",
                        subtitle: "O Lush analisará as cores e modelagem para você!"
                    )
                    .padding(.bottom, 10)

                    // Foto (câmera ou galeria — componente PhotoPicker + CameraView)
                    PhotoPicker(
                        image: $image,
                        title: "Adicione uma foto da sua\npeça de roupa",
                        width: 345,
                        height: 360
                    )
                    .frame(maxWidth: .infinity)

                    // Nome
                    LushTextField(
                        title: "Nome da roupa",
                        placeholder: "Adicione o nome para a sua roupa",
                        text: $name
                    )

                    // Tipo de peça
                    LushPickerField(
                        title: "Tipo de peça",
                        placeholder: "Parte de cima, de baixo ou peça única",
                        options: positions,
                        selection: $position
                    )

                    // Categoria (só as compatíveis com o tipo escolhido)
                    LushPickerField(
                        title: "Categoria",
                        placeholder: position == nil
                            ? "Escolha o tipo de peça primeiro"
                            : "Selecione uma categoria",
                        options: categories,
                        selection: $category
                    )
                    .disabled(position == nil)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .background {
                Image("backgroundLush")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            .toolbar {
                Toolbar(
                    action: .confirm,
                    isActionEnabled: isFormComplete,
                    onBackClick: { dismiss() },
                    onActionClick: {
                        // TODO: salvar a peça e rodar a análise (GarmentAnalysisService)
                    }
                )
            }
            .navigationBarBackButtonHidden(true)
            // Trocou o tipo → limpa a categoria (ela pode não existir no novo tipo)
            .onChange(of: position) {
                category = nil
            }
        }
    }
}

#Preview {
    AddClothingView()
}
