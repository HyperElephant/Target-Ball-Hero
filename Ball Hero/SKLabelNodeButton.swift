//
//  SKLabelNodeButton.swift
//  Ball Hero
//
//  Created by David Taylor on 9/20/15.
//  Copyright © 2015 Hyper Elephant. All rights reserved.
//

import SpriteKit

class SKLabelNodeButton: SKLabelNode {
    
    var selected = false
    var defaultColor = UIColor.black
    var selectedColor = UIColor.white
    
    func select() {
        self.fontColor = selectedColor
        selected = true
    }
    
    func deselect() {
        self.fontColor = defaultColor
        selected = false
    }

}
