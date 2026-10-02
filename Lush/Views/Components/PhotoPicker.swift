//
//  LushPhotoPicker.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 29/09/26.
//

import SwiftUI
import PhotosUI
import UIKit

struct PhotoPicker: View {
    
    @Binding var image: UIImage?
    
    let title: String
    let width: CGFloat
    let height: CGFloat
    
    @State private var showingPhotoMenu = false
    @State private var showingCamera = false
    @State private var showingGallery = false
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        
        Button {
            showingPhotoMenu = true
        } label: {
            
            ZStack {
                
                if let image {
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: width,height: height)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                    
                } else {
                    
                    VStack(spacing: 12) {
                        
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 42))
                            .foregroundStyle(.quartenary.opacity(0.8))
                        
                        Text(title)
                            .font(.system(size: 16,weight: .regular))
                            .foregroundStyle(.quartenary.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: width,height: height)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 24)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray,style: StrokeStyle(lineWidth: 0.8,dash: [4, 4]))
                    }
                }
            }
            .frame(
                width: width,
                height: height
            )
        }
        .buttonStyle(.plain)
        
        
        .confirmationDialog("Adicionar foto", isPresented: $showingPhotoMenu,titleVisibility: .visible) {
            
            Button {
                showingCamera = true
            } label: {
                Label("Tirar foto",systemImage: "camera")
            }
            
            Button {
                showingGallery = true
            } label: {
                Label(
                    "Escolher foto",
                    systemImage: "photo.on.rectangle"
                )
            }
            
            Button(
                "Cancelar",
                role: .cancel
            ) { }
        }
        
        
        .fullScreenCover(
            isPresented: $showingCamera
        ) {
            
            CameraView(
                onImageCaptured: { capturedImage in
                    
                    image = capturedImage
                    showingCamera = false
                },
                onCancel: {
                    showingCamera = false
                }
            )
        }
        
        
        .photosPicker(
            isPresented: $showingGallery,
            selection: $selectedPhoto,
            matching: .images
        )
        .onChange(of: selectedPhoto) {
            loadImageFromGallery()
        }
    }
    
    
    private func loadImageFromGallery() {
        
        guard let selectedPhoto else {
            return
        }
        
        Task {
            do {
                
                guard let data = try await selectedPhoto.loadTransferable(type: Data.self),
                let image = UIImage(data: data)
                else {
                    return
                }
                
                await MainActor.run {
                    self.image = image
                    self.selectedPhoto = nil
                }
                
            } catch {
                
                print("Erro ao carregar imagem: \(error)")
            }
        }
    }
}

#Preview {
    @Previewable @State var image: UIImage? = nil
    
    PhotoPicker(
        image: $image,
        title: "Adicione uma foto",
        width: 321,
        height: 410
    )
}
