//
//  CGImagePropertyOrientation+UIImage.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 02/10/26.
//

//  Converte a orientação do UIImage para o formato que o Vision usa.
//  Sem isso, fotos tiradas com o iPhone em pé chegam "deitadas" para o modelo.
//

import ImageIO
import UIKit

extension CGImagePropertyOrientation {
    nonisolated init(_ orientation: UIImage.Orientation) {
        switch orientation {
        case .up: self = .up
        case .down: self = .down
        case .left: self = .left
        case .right: self = .right
        case .upMirrored: self = .upMirrored
        case .downMirrored: self = .downMirrored
        case .leftMirrored: self = .leftMirrored
        case .rightMirrored: self = .rightMirrored
        @unknown default: self = .up
        }
    }
}
