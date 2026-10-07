//
//  ClothingService.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 07/10/26.
//


import Foundation
import SwiftData
import UIKit

@MainActor
struct ClothingService {
    
    /// Salva uma nova peça de roupa no banco de dados
    static func saveClothing(
        name: String,
        image: UIImage?,
        category: GarmentCategory,
        position: GarmentPosition,
        in modelContext: ModelContext
    ) {
        let photoData = image?.jpegData(compressionQuality: 0.8)

        let newClothing = ClothesModel(
            id: UUID(),
            name: name,
            photo: photoData,
            garmentCategory: category,
            garmentPosition: position
        )

        modelContext.insert(newClothing)

        do {
            try modelContext.save()
        } catch {
            print("Erro ao salvar nova roupa: \(error.localizedDescription)")
        }
    }

    /// Atualiza uma peça de roupa existente no banco de dados
    static func updateClothing(
        _ clothing: ClothesModel,
        name: String,
        image: UIImage?,
        category: GarmentCategory,
        position: GarmentPosition,
        in modelContext: ModelContext
    ) {
        clothing.name = name
        clothing.garmentCategory = category
        clothing.garmentPosition = position
        clothing.photo = image?.jpegData(compressionQuality: 0.8)

        do {
            try modelContext.save()
        } catch {
            print("Erro ao atualizar roupa: \(error.localizedDescription)")
        }
    }
}