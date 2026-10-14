//
//  CompatibilityResult.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 13/10/26.
//

import SwiftUI
import UIKit

struct BodyResult {
    let level: CompatibilityLevel
    let explanation: String
}

struct PaletteResult {
    let level: CompatibilityLevel
    let colors: [GarmentColor]
    let explanation: String
}
