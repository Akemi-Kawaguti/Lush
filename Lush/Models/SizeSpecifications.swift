//
//  SizeSpecifications.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

//ombro - cintura - quadril

import Foundation
import SwiftData

@Model
final class SizeSpecifications{
    var shoulderSize: Double
    var waistSize: Double
    var hipSize: Double
    
    init(
        shoulderSize: Double = 0.0,
        waistSize: Double = 0.0,
        hipSize: Double = 0.0
    ) {
        self.shoulderSize = shoulderSize
        self.waistSize = waistSize
        self.hipSize = hipSize
    }
}

