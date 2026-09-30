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
    
    var user: UserModel?
    
    init(shoulderSize: Double, waistSize: Double, hipSize: Double, user: UserModel? = nil) {
        self.shoulderSize = shoulderSize
        self.waistSize = waistSize
        self.hipSize = hipSize
        
        self.user = user
    }
}

