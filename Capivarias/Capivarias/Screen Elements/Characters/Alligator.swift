//
//  Alligator.swift
//  Capivarias
//
//  Created by Clissia Bozzer Bovi on 19/10/23.
//

import Foundation
import SpriteKit

class Alligator {
    private var life: CGFloat = 100
    private var damage: CGFloat = 20
    private var speed: CGFloat = 1
    private var scale: CGFloat = 0.09
    private let staticName: String = "alligator_stopped"
    private let movementAliasName: String = "Alligator_Walking"

    var sprite: SKSpriteNode

    init() {
        self.sprite = SKSpriteNode(imageNamed: staticName)
    }

    func start(screenWidth: CGFloat) {
        let scale = screenWidth * scale / sprite.size.width
        let texture = SKTexture(imageNamed: staticName)
        sprite.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        sprite.position = CGPoint(x: 500, y: 200)
        sprite.zPosition = 10
        sprite.physicsBody?.affectedByGravity = false
        sprite.setScale(scale)
        walk()
    }

    func walk() {
        let textures = Textures.getTextures(name: "", atlas: "Alligator_Walking")
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 1/TimeInterval(textures.count),
                                      resize: true,
                                      restore: true)
        sprite.removeAllActions()
        sprite.run(SKAction.repeatForever(action))
    }

    func follow(player: CGPoint) {
        let dx = player.x - self.sprite.position.x
        let dy = player.y - self.sprite.position.y
        let angle = atan2(dy, dx)

        let vx = cos(angle) * speed
        let vy = sin(angle) * speed

        sprite.position.x += vx
        sprite.position.y += vy

        sprite.xScale = dx > 0 ? abs(sprite.xScale) : -abs(sprite.xScale)
        sprite.zRotation = 0
    }
}
