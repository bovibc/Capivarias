//
//  Monkey.swift
//  Capivarias
//
//  Created by Renan Tavares on 10/11/23.
//

import Foundation
import SpriteKit


class Monkey {
    var life: Float = 100
    private var damage: Float = 20
    private var speed: CGFloat = 2
    private var attackSpeed: CGFloat = 1
    private let staticName: String = "a1"
    private var isMonkeyWalking: Bool = false
    private let movementMonkeyName: String = "Monkey_Waking"
    private let speedAtack: Float = 3.0
    var sprite: SKSpriteNode
    var range: Float = 5
    
    init() {
        self.sprite = SKSpriteNode(imageNamed: staticName)
    }
}
