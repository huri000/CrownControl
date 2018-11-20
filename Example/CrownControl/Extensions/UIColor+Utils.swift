//
//  UIColor+Utils.swift
//  CrownControlDemo
//
//  Created by Daniel Huri on 4/20/18.
//  Copyright © 2018 Daniel Huri. All rights reserved.
//

import UIKit

extension UIColor {
    static func by(r: Int, g: Int, b: Int, a: CGFloat = 1) -> UIColor {
        let d = CGFloat(255)
        return UIColor(red: CGFloat(r) / d, green: CGFloat(g) / d, blue: CGFloat(b) / d, alpha: a)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIColor {
    static let contact1 = UIColor(rgb: 0xffdfd3)
    static let contact2 = UIColor(rgb: 0xfec8d8)
    static let contact3 = UIColor(rgb: 0xd291bc)
    static let contact4 = UIColor(rgb: 0x957dad)
    
    static let blueGray = UIColor(rgb: 0x455a64)
}
