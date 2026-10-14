//
//  BodyShape.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

import Foundation

enum BodyShape: String, Codable, CaseIterable {
    case hourglass = "Ampulheta"
    case triangle = "Triângulo"
    case invertedTriangle = "Triângulo invertido"
    case rectangle = "Retângulo"
    case oval = "Oval"
}

struct BodyShapeFeature {
    let title: String
    let description: String
    let imageName: String
}
