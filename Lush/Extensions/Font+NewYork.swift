//
//  Font+NewYork.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 28/09/26.
//

import SwiftUI

extension Font {
    /// Helper para carregar a New York Large Bold vinculada a um TextStyle do sistema para Dynamic Type
    static func newYorkBold(_ style: Font.TextStyle) -> Font {
        return Font.custom("NewYorkLarge-Bold", size: style.defaultSize, relativeTo: style)
    }
}

private extension Font.TextStyle {
    /// Tamanhos padrão do sistema iOS para cada estilo semântico
    var defaultSize: CGFloat {
        switch self {
        case .largeTitle: return 34
        case .title:      return 28
        case .title2:     return 22
        case .title3:     return 20
        case .headline:   return 17
        case .body:       return 17
        case .callout:    return 16
        case .subheadline: return 15
        case .footnote:   return 13
        case .caption:    return 12
        case .caption2:   return 11
        @unknown default: return 17
        }
    }
}

extension Font {
    struct AppTypography {
        static let largeTitle = Font.newYorkBold(.largeTitle)
        static let title      = Font.newYorkBold(.title)
        static let title2     = Font.newYorkBold(.title2)
        static let title3     = Font.newYorkBold(.title3)
        static let headline   = Font.newYorkBold(.headline)
        static let body       = Font.newYorkBold(.body)
        static let subheadline = Font.newYorkBold(.subheadline)
        static let footnote   = Font.newYorkBold(.footnote)
        static let caption    = Font.newYorkBold(.caption)
    }
}
