//
//  WeaponSelection.swift
//  Capivarias
//
//  Created by Ricardo de Agostini Neto on 28/11/23.
//

import Foundation
import SpriteKit

class WeaponSelection: SKNode {
    
    var weaponSelected: SKSpriteNode
    
    override init() {
        self.weaponSelected = SKSpriteNode(imageNamed: "sword selected")
        super.init()
        setup()
    }
    
    required init? (coder aDecoder: NSCoder) {
        self.weaponSelected = SKSpriteNode(imageNamed: "sword selected")
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        addChild(weaponSelected)
        
        weaponSelected.zPosition += 99
        weaponSelected.position.x = -(weaponSelected.size.width/2) + 105
        weaponSelected.position.y = -(weaponSelected.size.height/2) - 5
    }
    
    public func changeWeapon(weapon: Bool) {
        
        if weapon == true {
            weaponSelected.texture = SKTexture(imageNamed: "sword selected")
        }
        else {
            weaponSelected.texture = SKTexture(imageNamed: "zarabatana selected")
        }
        
    }
    
}
