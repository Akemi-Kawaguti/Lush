//
//  UIimage.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 14/10/26.
//

import Foundation
import UIKit

extension UIImage {
    nonisolated func fixedOrientation() -> UIImage? {
        if imageOrientation == .up { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    } // força usuario posicionar corretamente a foto
}
