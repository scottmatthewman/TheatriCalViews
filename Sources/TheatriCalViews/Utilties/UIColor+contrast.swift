//
//  UIColor+contrast.swift
//  
//
//  Created by Scott Matthewman on 13/04/2023.
//

import UIKit

extension UIColor {
    struct RGBA {
        let red: CGFloat
        let green: CGFloat
        let blue: CGFloat
        let alpha: CGFloat
    }

    var rgba: RGBA {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }

    func contrastingColor() -> UIColor {
        let components = rgba

        let luminanceArray = [components.red, components.green, components.blue]
            .map { min(max(0, $0), 1.0) }
            .map { value in
                if value < 0.03928 {
                    return (value / 12.92)
                } else {
                    return pow((value + 0.055) / 1.055, 2.4)
                }
            }
        let luminance = luminanceArray[0] * 0.2126 +
                        luminanceArray[1] * 0.7152 +
                        luminanceArray[2] * 0.0722

        return luminance > 0.279 ? .black : .white
    }
}
