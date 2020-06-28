//
//  Recipe.swift
//  Foodpicker
//
//  Created by tobiasmidskard on 25/06/2020.
//  Copyright © 2020 tobiasmidskard. All rights reserved.
//

import Foundation

class Recipe {
    
    var id: String
    var name: String
    var link: String
    var description : String
    var style_id : String
    var user_id : String
    
    init(id: String, name: String, link : String, description : String, style_id : String, user_id : String) {
        self.id = id
        self.name = name
        self.link = link
        self.description = description
        self.style_id = style_id
        self.user_id = user_id
    }
    
}
