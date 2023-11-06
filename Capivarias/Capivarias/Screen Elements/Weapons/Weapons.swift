//
//  Weapons.swift
//  Capivarias
//
//  Created by Renan Tavares on 24/10/23.
//

import Foundation


enum TypeWeapon: String {
    case sword
    case pear
    case blowgun
}

struct Weapons {
    var typeWeapon = TypeWeapon.sword
    var damage: Int = 0
    var range: Double = 0
    
    
    mutating func changeWeapon(weapon: TypeWeapon) {
        switch weapon {
            case .sword:
                damage = 7
                range = 3.0
            case .pear:
                damage = 4
                range = 6.5
            case .blowgun:
                damage = 5
                range = 8
        }
    }
}
