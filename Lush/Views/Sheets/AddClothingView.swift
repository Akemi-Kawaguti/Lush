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
    @State private var isShowingReanalysisWarning = false

    // Foto original da peça (edição): para saber se a usuária trocou a foto
    @State private var originalImage: UIImage?
    
    
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
            let savedImage = clothing.photo.flatMap { UIImage(data: $0) } ?? photo
            _image = State(initialValue: savedImage)
            _originalImage = State(initialValue: savedImage)
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

    /// Na edição: trocar a foto ou a categoria muda a análise da peça (o nome não)
    private var changesAnalysis: Bool {
        guard let clothingToEdit else { return false }
        return image !== originalImage || category != clothingToEdit.garmentCategory
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
        // Tela "Analisando…" enquanto a peça é analisada (cadastro e edição)
        .overlay {
            if viewModel.isAnalyzing {
                AnalyzingOverlay()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.isAnalyzing)
        .toolbar(viewModel.isAnalyzing ? .hidden : .visible, for: .navigationBar)
        .interactiveDismissDisabled(viewModel.isAnalyzing)
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
                        guard let clothing = clothingToEdit else { return }

                        if changesAnalysis {
                            // Avisa antes de refazer a análise
                            isShowingReanalysisWarning = true
                        } else {
                            ClothingService.renameClothing(clothing, name: name, in: modelContext)
                            dismiss()
                        }
                    }
                )
            } else {
                Toolbar(
                    action: .confirm,
                    isActionEnabled: isFormComplete,
                    onBackClick: { dismiss() },
                    onActionClick: {
                        analyzedClothing = nil
                        startAnalysis()
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
        
        // Análise pronta
        .onChange(of: viewModel.analysis?.best?.label) {
            guard viewModel.analysis != nil,
                  let image,
                  let category else {
                return
            }

            // Edição: atualiza a peça com a nova análise e fecha a sheet
            if isEditMode, let clothing = clothingToEdit {
                let updated = viewModel.updateAnalyzedClothing(
                    clothing,
                    name: name,
                    image: image,
                    category: category,
                    in: modelContext
                )
                if updated { dismiss() }
                return
            }

            // Cadastro: salva a peça e abre os detalhes
            analyzedClothing = viewModel.saveAnalyzedClothing(
                name: name,
                image: image,
                category: category,
                in: modelContext
            )
        }

        // A peça já está salva: voltar dos detalhes fecha o cadastro inteiro
        .navigationDestination(item: $analyzedClothing) { clothing in
            ClothingDetailView(
                clothingItem: clothing,
                onClose: { dismiss() }
            )
        }

        // Aviso antes de refazer a análise na edição
        .alert(
            "Refazer a análise da peça?",
            isPresented: $isShowingReanalysisWarning
        ) {
            Button("Cancelar", role: .cancel) {}
            Button("Continuar") {
                startAnalysis()
            }
        } message: {
            Text("Ao trocar a foto ou a categoria, o Lush analisa a peça de novo. A modelagem, as cores e a compatibilidade com você podem mudar.")
        }

        // Erro na análise (ex.: categoria sem modelo de análise)
        .alert(
            "Não foi possível analisar a peça",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

// MARK: - Carregamento da análise

/// Tela de "Analisando sua peça…".
/// Usa o vídeo `analyzing.mov` (estrelinha pulsando) quando ele estiver no projeto;
/// enquanto não estiver, mostra uma estrela do SF Symbols pulsando.
private struct AnalyzingOverlay: View {

    private let videoName = "analyzing"
    private var hasVideo: Bool {
        Bundle.main.url(forResource: videoName, withExtension: "mov") != nil
    }

    var body: some View {
        VStack(spacing: 20) {
            if hasVideo {
                VideoPlayerView(fileName: videoName, loops: true, rate: 1)
                    .frame(width: 140, height: 140)
            } else {
                Image(systemName: "sparkle")
                    .font(.system(size: 64))
                    .foregroundStyle(Color("button"))
                    .symbolEffect(.pulse)
                    .frame(width: 140, height: 140)
            }

            VStack(spacing: 8) {
                Text("Analisando sua peça…")
                    .font(.AppTypography.title3)
                    .foregroundStyle(Color("titles"))

                Text("Estamos identificando a modelagem e as cores")
                    .font(.footnote)
                    .foregroundStyle(Color("quartenary"))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Image("backgroundLush")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Analisando sua peça")
    }
}

extension AddClothingView {

    /// Analisa a foto (tira o fundo, modelagem e cores). O resultado chega no onChange acima.
    private func startAnalysis() {
        viewModel.analysis = nil
        viewModel.processedImage = nil
        guard let image, let category else { return }
        viewModel.analyzeClothing(image: image, category: category)
    }
}

#Preview("Cadastro") {
    NavigationStack {
        AddClothingView()
    }
}
