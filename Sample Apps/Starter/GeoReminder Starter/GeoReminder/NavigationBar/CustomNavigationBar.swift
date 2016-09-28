//
//  CustomNavigationBar.swift
//  GeoReminder
//
//  Created by Arthur Schiller on 28.07.16.
//  Copyright © 2016 HYPH. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCustomStyles()
    }
    
    func configureCustomStyles() {
        let boldFont = UIFont.customBoldFontOfSize(17)
        let regularFont = UIFont.customRegularFontOfSize(17)
        titleTextAttributes = [NSFontAttributeName: boldFont, NSForegroundColorAttributeName: UIColor.customBlueColor()]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: regularFont, NSForegroundColorAttributeName: UIColor.customBlueColor()], forState: UIControlState.Normal)
    }
}