//
//  AddClothingView.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

//  Tela "Cadastrar roupa" e "Editar roupa"

import SwiftUI
import SwiftData

struct AddClothingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    
    var clothingToEdit: ClothesModel?
    
    // Parte de cima, de baixo e peça única
    private let positions = GarmentPosition.allCases
    private let isEditMode: Bool
    
    @StateObject private var viewModel = AddClothingViewModel()
    
    @State private var image: UIImage?
    @State private var name: String
    @State private var position: GarmentPosition?
    @State private var category: GarmentCategory?
    @State private var analyzedClothing: ClothesModel?
    
    
    init(
        isEditMode: Bool = false,
        clothingToEdit: ClothesModel? = nil,
        name: String = "",
        category: GarmentCategory? = nil,
        photo: UIImage? = nil
    ) {
        self.isEditMode = isEditMode
        self.clothingToEdit = clothingToEdit
        
        if let clothing = clothingToEdit {
            _name = State(initialValue: clothing.name)
            _category = State(initialValue: clothing.garmentCategory)
            _position = State(initialValue: clothing.garmentPosition)
            if let data = clothing.photo, let uiImage = UIImage(data: data) {
                _image = State(initialValue: uiImage)
            } else {
                _image = State(initialValue: photo)
            }
        } else {
            _name = State(initialValue: name)
            _category = State(initialValue: category)
            _position = State(initialValue: category?.position)
            _image = State(initialValue: photo)
        }
    }
    
    private var categories: [GarmentCategory] {
        guard let position else { return [] }
        return GarmentCategory.allCases.filter { $0.position == position }
    }
    
    private var isFormComplete: Bool {
        image != nil
        && !name.trimmingCharacters(in: .whitespaces).isEmpty
        && category != nil
        && position != nil
    }
    
    private var hasAnalysis: Bool {
        viewModel.analysis != nil
    }
    
    var body: some View {
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
                        if let clothing = clothingToEdit, let category, let position {
                            ClothingService.updateClothing(
                                clothing,
                                name: name,
                                image: image,
                                category: category,
                                position: position,
                                in: modelContext
                            )
                        }
                        dismiss()
                    }
                )
            } else {
                Toolbar(
                    action: .confirm,
                    isActionEnabled: isFormComplete,
                    onBackClick: { dismiss() },
                    onActionClick: {
                        analyzedClothing = nil
                        viewModel.analysis = nil
                        viewModel.processedImage = nil
                        guard let image,
                              let category else {
                            return
                        }
                        viewModel.analyzeClothing(
                            image: image,
                            category: category
                        )
                    }
                )
            
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: position) {
            if category?.position != position {
                category = nil
            }
        }
        
        .onChange(of: viewModel.analysis?.best?.label) {
            guard let image,
                  let category else {
                return
            }

            analyzedClothing = viewModel.makeAnalyzedClothing(
                name: name,
                image: image,
                category: category
            )
        }
        
        .navigationDestination(item: $analyzedClothing) { clothing in
            ClothingDetailView(
                clothingItem: clothing
            )
        }
    }
}

#Preview("Cadastro") {
    NavigationStack {
        AddClothingView()
    }
}

#Preview("Edição") {
    NavigationStack {
        AddClothingView(isEditMode: true, name: "Vestido longo", category: .dress)
    }
}
