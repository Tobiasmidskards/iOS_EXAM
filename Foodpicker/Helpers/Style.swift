//
//  Style.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 25/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import Foundation
import UIKit

class Style {
    static func styleTextField(_ textField: UITextField) {
        
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textField.frame.height - 2, width: textField.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.init(red: 173/255, green: 48/255, blue: 99/255, alpha: 1).cgColor
        
        textField.borderStyle = .none;
        
        textField.layer.addSublayer(bottomLine)
    }
    
    static func styleFilledButton(_ button:UIButton) {
        button.backgroundColor = UIColor.init(red: 173/255, green: 48/255, blue: 99/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white;
    }
    
    static func styleFilledSecondaryButton(_ button:UIButton) {
        button.backgroundColor = UIColor.init(red: 102/255, green: 51/255, blue: 51/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white;
    }
    
    static func styleFilledThirdButton(_ button:UIButton) {
        button.backgroundColor = UIColor.init(red: 102/255, green: 151/255, blue: 30/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white;
    }
    
    static func styleHollowButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black;
        button.setTitleColor(UIColor.white, for: .normal)
        //button.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    }
}
