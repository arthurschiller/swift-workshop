//
//  Extensions.swift
//  GeoReminder
//
//  Created by Arthur Schiller on 28.07.16.
//  Copyright © 2016 HYPH. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func customBlueColor() -> UIColor {
        return UIColor(red:0.08, green:0.15, blue:0.76, alpha:1.00)
    }
}

// Fonts
extension UIFont {
    class func customRegularFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "BwQuintaPro-Regular", size: size)!
    }
    
    class func customMediumFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "BwQuintaPro-Medium", size: size)!
    }
    
    class func customBoldFontOfSize(size: CGFloat) -> UIFont {
        return UIFont(name: "BwQuintaPro-Bold", size: size)!
    }
}