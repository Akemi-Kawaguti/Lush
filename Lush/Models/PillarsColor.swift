//
//  PillarsColor.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 29/09/26.
//

//temperatura - luminosidade
//contraste - saturação

import Foundation
import SwiftData

@Model
final class PillarsColor {
    var temperature: String
    var brightness: String
    var contrast: String
    var saturation: String
    
    var user: UserModel
    
    init(temperature: String, brightness: String, contrast: String, saturation: String, user: UserModel) {
        self.temperature = temperature
        self.brightness = brightness
        self.contrast = contrast
        self.saturation = saturation
        self.user = user
    }
}

