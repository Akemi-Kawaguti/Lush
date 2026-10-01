//
//  BodyInputSource.swift
//  Lush
//
//  Created by Tais Akemi Kawaguti on 30/09/26.
//

import Foundation
import CoreGraphics

struct BodyMeasure{
    let shoulder: CGFloat
    let waist: CGFloat
    let hip: CGFloat
}


enum BodyInputSource {
    case photo(shoulderPixels: CGFloat, hipPixels: CGFloat, waistCenter: CGPoint, skeletonHeightPixels: CGFloat, userRealHeightCm: CGFloat)
    case manual(shoulderCm: CGFloat, waistCm: CGFloat, hipCm: CGFloat)
}
