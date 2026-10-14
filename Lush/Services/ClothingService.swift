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

    //MARK: Adicionar
    @discardableResult
    static func addClothing(
        name: String,
        image: UIImage?,
        category: GarmentCategory,
        position: GarmentPosition,
        cutTop: GarmentCutTop? = nil,
        cutBottom: GarmentCutBottom? = nil,
        cutOnePiece: GarmentCutOnePiece? = nil,
        predominantColors: [String] = [],
        
        in context: ModelContext ) -> ClothesModel { let user = UserModel.current(in: context)

        let newClothing = ClothesModel(
            id: UUID(),
            name: name.trimmingCharacters(in: .whitespaces),
            photo: image.flatMap(photoData(from:)),
            garmentCategory: category,
            garmentPosition: position,
            cutTop: cutTop,
            cutBottom: cutBottom,
            cutOnePiece: cutOnePiece,
            predominantColors: predominantColors
        )

        context.insert(newClothing)
        user.userClothes.append(newClothing)

        do { try context.save()
        } catch { #if DEBUG
            print("Erro ao adicionar roupa: \(error.localizedDescription)") #endif
            }
        return newClothing
    }

    //MARK: Atualizar
    static func updateClothing(
        _ clothing: ClothesModel,
        name: String,
        image: UIImage?,
        category: GarmentCategory,
        position: GarmentPosition,
        cutTop: GarmentCutTop?,
        cutBottom: GarmentCutBottom?,
        cutOnePiece: GarmentCutOnePiece?,
        predominantColors: [String],
        in modelContext: ModelContext
    ) {
        clothing.name = name.trimmingCharacters(in: .whitespaces)
        clothing.photo = image.flatMap(photoData(from:))
        clothing.garmentCategory = category
        clothing.garmentPosition = position
        clothing.cutTop = cutTop
        clothing.cutBottom = cutBottom
        clothing.cutOnePiece = cutOnePiece
        clothing.predominantColors = predominantColors

        do { try modelContext.save()
        } catch { #if DEBUG
            print("Erro ao atualizar roupa: \(error.localizedDescription)") #endif
        }
    }

    //MARK: Renomear
    static func renameClothing( _ clothing: ClothesModel, name: String, in modelContext: ModelContext ) {
        clothing.name = name.trimmingCharacters(in: .whitespaces)

        do { try modelContext.save()
        } catch { #if DEBUG
            print("Erro ao renomear roupa: \(error.localizedDescription)") #endif
        }
    }

    //MARK: Deleta
    static func deleteClothing( _ clothing: ClothesModel,  in context: ModelContext ) {
        // Tira da lista da usuária antes de apagar, para a lista não ficar com uma peça "fantasma"
        let user = UserModel.current(in: context)
        user.userClothes.removeAll { $0.id == clothing.id }

        context.delete(clothing)

        do { try context.save()
        } catch { #if DEBUG
            print("Erro ao deletar roupa: \(error.localizedDescription)") #endif
        }
    }

    //MARK: Foto salva da peça: fundo branco (a foto sem fundo vira preto no JPEG) e no máximo 1200 px
    static func photoData(from image: UIImage) -> Data? {
        let maxSide: CGFloat = 1200
        let scale = min(1, maxSide / max(image.size.width, image.size.height))
        let newSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true

        let flattened = UIGraphicsImageRenderer(size: newSize, format: format).image { context in
            UIColor.white.setFill()
            context.fill(CGRect(origin: .zero, size: newSize))
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return flattened.jpegData(compressionQuality: 0.85)
    }
}
