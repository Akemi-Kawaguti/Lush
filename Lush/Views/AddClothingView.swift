//
//  AddClothingView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//


//  Tela "Cadastrar roupa" e "Editar roupa" 


import SwiftUI

struct AddClothingView: View {

    @Environment(\.dismiss) private var dismiss

    // Parte de cima, de baixo e peça única
    private let positions = GarmentPosition.allCases
    private let isEditMode: Bool

    @State private var image: UIImage?
    @State private var name: String
    @State private var position: GarmentPosition?
    @State private var category: GarmentCategory?

    init(
        isEditMode: Bool = false,
        name: String = "",
        category: GarmentCategory? = nil,
        photo: UIImage? = nil
    ) {
        self.isEditMode = isEditMode
        _name = State(initialValue: name)
        _category = State(initialValue: category)
        _position = State(initialValue: category?.position)
        _image = State(initialValue: photo)
    }

    // Categorias compatíveis com o tipo escolhido no primeiro picker
    private var categories: [GarmentCategory] {
        guard let position else { return [] }
        return GarmentCategory.allCases.filter { $0.position == position }
    }

    // O check só fica ativo com tudo preenchido
    private var isFormComplete: Bool {
        image != nil
            && !name.trimmingCharacters(in: .whitespaces).isEmpty
            && category != nil
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // No modo edição o título fica na toolbar da sheet
                    if !isEditMode {
                        ScreenHeader(
                            title: "Cadastrar roupa",
                            subtitle: "O Lush analisará as cores e modelagem para você!"
                        )
                        .padding(.bottom, 10)
                    }

                    // Foto (câmera ou galeria — componente PhotoPicker + CameraView)
                    PhotoPicker(
                        image: $image,
                        title: "Adicione uma foto da sua\npeça de roupa",
                        width: 345,
                        height: 360
                    )
                    .frame(maxWidth: .infinity)

                    LushTextField(
                        title: "Nome da roupa",
                        placeholder: "Adicione o nome para a sua roupa",
                        text: $name
                    )

                    LushPickerField(
                        title: "Tipo de peça",
                        placeholder: "Parte de cima, de baixo ou peça única",
                        options: positions,
                        selection: $position
                    )

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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isEditMode {
                    // Sheet de edição
                    SheetToolbar(
                        title: "Editar roupa",
                        isConfirmEnabled: isFormComplete,
                        onClose: { dismiss() },
                        onConfirm: {
                            // TODO: salvar a edição e refazer a análise
                            dismiss()
                        }
                    )
                } else {
                    // Cadastro
                    Toolbar(
                        action: .confirm,
                        isActionEnabled: isFormComplete,
                        onBackClick: { dismiss() },
                        onActionClick: {
                            // TODO: salvar a peça e rodar a análise (GarmentAnalysisService)
                            dismiss()
                        }
                    )
                }
            }
            .navigationBarBackButtonHidden(true)
            // Trocou o tipo → limpa a categoria se ela não pertence ao novo tipo
            .onChange(of: position) {
                if category?.position != position {
                    category = nil
                }
            }
        }
    }
}

#Preview("Cadastro") {
    AddClothingView()
}

#Preview("Edição") {
    AddClothingView(isEditMode: true, name: "Vestido longo", category: .dress)
}
