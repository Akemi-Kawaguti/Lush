//
//  PalleteSeason+Hex.swift
//  Lush
//
//  Created by Agatha Barbosa Marinho dos Santos on 06/10/26.
//

import UIKit

// Uma cor da paleta pronta para a busca no Pexels
struct FashionColor {
    let hex: String         // cor exata, para o filtro "color" (ex.: "#971B21")
    let name: String        // nome em inglês, para o texto da busca (ex.: "burgundy")
    let keywords: [String]  // palavras que podem aparecer na descrição da foto
}

extension PalleteSeason {

    // As 7 cores da paleta (Assets) com hex e nome da cor mais parecida
    var fashionColors: [FashionColor] {
        colorPalletes.compactMap { assetName in
            guard let color = UIColor(named: assetName) else { return nil }

            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            let red = Int(min(max(r, 0), 1) * 255)
            let green = Int(min(max(g, 0), 1) * 255)
            let blue = Int(min(max(b, 0), 1) * 255)

            // Procura o nome de cor mais próximo (menor distância entre os RGB)
            let nearest = NamedColor.all.min { first, second in
                first.distance(red, green, blue) < second.distance(red, green, blue)
            }!

            return FashionColor(
                hex: String(format: "#%02X%02X%02X", red, green, blue),
                name: nearest.name,
                keywords: nearest.keywords
            )
        }
    }
}

// Cores comuns em moda, com as palavras que aparecem nas descrições do Pexels
private struct NamedColor {
    let name: String
    let red: Int, green: Int, blue: Int
    let keywords: [String]

    func distance(_ r: Int, _ g: Int, _ b: Int) -> Int {
        (red - r) * (red - r) + (green - g) * (green - g) + (blue - b) * (blue - b)
    }

    static let all: [NamedColor] = [
        NamedColor(name: "black", red: 20, green: 20, blue: 20, keywords: ["black"]),
        NamedColor(name: "white", red: 245, green: 245, blue: 245, keywords: ["white"]),
        NamedColor(name: "gray", red: 128, green: 128, blue: 128, keywords: ["gray", "grey"]),
        NamedColor(name: "beige", red: 222, green: 200, blue: 170, keywords: ["beige", "cream", "nude"]),
        NamedColor(name: "camel", red: 193, green: 154, blue: 107, keywords: ["camel", "tan", "beige"]),
        NamedColor(name: "brown", red: 110, green: 65, blue: 50, keywords: ["brown", "chocolate"]),
        NamedColor(name: "red", red: 200, green: 30, blue: 40, keywords: ["red"]),
        NamedColor(name: "burgundy", red: 128, green: 20, blue: 40, keywords: ["burgundy", "maroon", "wine", "red"]),
        NamedColor(name: "terracotta", red: 190, green: 100, blue: 80, keywords: ["terracotta", "rust", "orange"]),
        NamedColor(name: "orange", red: 230, green: 130, blue: 40, keywords: ["orange"]),
        NamedColor(name: "mustard", red: 205, green: 160, blue: 40, keywords: ["mustard", "yellow"]),
        NamedColor(name: "yellow", red: 240, green: 210, blue: 60, keywords: ["yellow"]),
        NamedColor(name: "olive", red: 120, green: 115, blue: 60, keywords: ["olive", "khaki", "green"]),
        NamedColor(name: "green", red: 40, green: 140, blue: 70, keywords: ["green"]),
        NamedColor(name: "teal", red: 20, green: 90, blue: 90, keywords: ["teal", "turquoise", "green"]),
        NamedColor(name: "blue", red: 40, green: 90, blue: 190, keywords: ["blue"]),
        NamedColor(name: "navy", red: 20, green: 40, blue: 90, keywords: ["navy", "blue"]),
        NamedColor(name: "light blue", red: 150, green: 190, blue: 230, keywords: ["blue"]),
        NamedColor(name: "purple", red: 110, green: 50, blue: 140, keywords: ["purple", "violet"]),
        NamedColor(name: "lavender", red: 190, green: 170, blue: 220, keywords: ["lavender", "lilac", "purple"]),
        NamedColor(name: "pink", red: 235, green: 140, blue: 170, keywords: ["pink"]),
        NamedColor(name: "coral", red: 240, green: 120, blue: 100, keywords: ["coral", "pink", "orange"])
    ]
}
