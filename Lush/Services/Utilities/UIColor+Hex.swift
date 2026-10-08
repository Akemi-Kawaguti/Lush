//
//  UIColor+Hex.swift
//  Lush
//
//  Created by Mariana Fracaroli Lopes on 08/10/26.
//

import UIKit

extension UIColor {

    var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(
            &red,
            green: &green,
            blue: &blue,
            alpha: &alpha
        )

        let redInt = Int(red * 255)
        let greenInt = Int(green * 255)
        let blueInt = Int(blue * 255)

        return String(
            format: "#%02X%02X%02X",
            redInt,
            greenInt,
            blueInt
        )
    }

     convenience init?(hex: String) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines)

        if hex.hasPrefix("#") {
            hex.removeFirst()
        }

        guard hex.count == 6,
              let value = UInt64(hex, radix: 16) else {
            return nil
        }

        let red = CGFloat((value >> 16) & 0xFF) / 255
        let green = CGFloat((value >> 8) & 0xFF) / 255
        let blue = CGFloat(value & 0xFF) / 255

        self.init(
            red: red,
            green: green,
            blue: blue,
            alpha: 1
        )
    }
}
