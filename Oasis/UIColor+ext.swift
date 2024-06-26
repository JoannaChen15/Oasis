//
//  UIColor+ext.swift
//  Oasis
//
//  Created by joanna on 2024/4/8.
//

import UIKit

extension UIColor {
    
    // 根據 hex init
    public convenience init?(hex: String) {
        let r, g, b: CGFloat
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255
                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        return nil
    }
    
    class var primary: UIColor {
        return UIColor { (traitCollection) -> UIColor in
            if traitCollection.userInterfaceStyle == .dark {
                return UIColor.lightGray
            } else {
                return UIColor(hex: "#4B5674")!
            }
        }
    }
    
    class var lightBlue: UIColor {
        return UIColor(hex: "#90C6FA")!
    }
    
    class var lightPink: UIColor {
        return UIColor(hex: "#F2A987")!
    }
    
    class var lightYellow: UIColor {
        return UIColor(hex: "#F8D68C")!
    }
    
}
