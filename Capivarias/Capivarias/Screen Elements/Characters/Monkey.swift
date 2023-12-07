//
//  Monkey.swift
//  Capivarias
//
//  Created by Renan Tavares on 10/11/23.
//

import Foundation
import SpriteKit


class Monkey {
    var life: Float = 1
    private var damage: Float = 20
    private var speed: CGFloat = 2
    private var attackSpeed: CGFloat = 1
    private let staticName: String = "m1"
    var assets = Assets()
    private var isMonkeyWalking: Bool = false
    private let speedAtack: Float = 3.0
    private var scale: CGFloat = 0.19
    var sprite: SKSpriteNode
    var rangeX: Double = 500
    var rangeY: Double = 500
    var monkeyWalkTextures:[SKTexture]
    var isInContact: Bool = false
    var lastChangedPosition: TimeInterval = 0
    var lastAttack: TimeInterval = 0
    private var bananaBulletSpeed = 600.0
    var isMonkeyAttacking: Bool = false
    var isMonkeyTakingDamage: Bool = false


   
    
    init() {
        self.sprite = SKSpriteNode(imageNamed: staticName)
        monkeyWalkTextures = Textures.getTextures(atlas: assets.monkeyWalking)
    }
    
    
    func start(screenWidth: CGFloat, screenHeight: CGFloat, spawnPosition: CGPoint, mask: Int) {
        let scaleX = (screenWidth * scale / sprite.size.width) * 0.7
        let scaleY = (screenHeight * scale / sprite.size.height) * 0.7
        sprite.xScale = scaleX
        sprite.yScale = scaleY

        setPosition( spawnPosition)
        setPhysics(mask)
        sprite.name = "monkey"
    }
    

    func changePosition(size: CGSize, capyX: CGFloat, capyY: CGFloat, monkey: SKSpriteNode, capybara: SKSpriteNode) {
        walk()

        let position = Position.randomize(size)
        let xAsCGFloat: CGFloat = position.x
        let yAsCGFloat: CGFloat = position.y
    
        let moveAction = SKAction.move(to: CGPoint(x: xAsCGFloat,
                                                   y: yAsCGFloat), duration: 1)
        facePoint(point: position)
        
        let stop = SKAction.run {
            self.stop()
         }
        
        let attack = SKAction.run {
            self.attack(capyX: capyX, capyY: capyY, monkey: monkey, capybara: capybara)
        }
        
        sprite.run(.sequence([moveAction, stop, attack]))
        
        
    }
    
    private func setPhysics(_ mask: Int) {
        let width = 0.55 * sprite.size.width
        let height = 0.25 * sprite.size.height
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height), center: CGPoint(x: -25, y: -40))
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.isDynamic = true
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.categoryBitMask = UInt32(mask)
        sprite.physicsBody?.contactTestBitMask = 2
        sprite.physicsBody?.collisionBitMask = 1
    }

    
    
    
    private func setPosition(_ spawnPosition: CGPoint) {
        sprite.position = spawnPosition
        sprite.zPosition = 20
    }
    
    
    
    func walk() {
        guard !isMonkeyWalking else { return }
        let action = SKAction.animate(with: monkeyWalkTextures,
                                      timePerFrame: 1/TimeInterval(monkeyWalkTextures.count),
                                      resize: true,
                                      restore: true)
        isMonkeyWalking = true
        sprite.removeAllActions()
        sprite.run(SKAction.repeatForever(action))
    }
    
    func angleBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let distanceX = CGFloat(point1.x - point2.x)
        let distanceY = CGFloat(point1.y - point2.y)
        let tangent = distanceY / distanceX
        return tangent
    }
    
    
    func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> Double {
        let deltaX = point2.x - point1.x
        let deltaY = point2.y - point1.y
        let distancia = sqrt(pow(deltaX, 2) + pow(deltaY, 2))
        
        return Double(distancia)
    }
    
    
    func stop() {

        self.isMonkeyAttacking = false
        self.isMonkeyWalking = false
        self.isMonkeyTakingDamage = false
        let textures = [SKTexture(imageNamed: assets.monkey_stopped)]
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 0.001,
                                      resize: true,
                                      restore: true)
        sprite.removeAllActions()
        sprite.run(SKAction.repeatForever(action))

    }
    
    

    func isInRange(x: Double, y: Double, monkeyPosition: CGPoint ) -> Bool {
        let distanceX = monkeyPosition.x - x
        let distanceY = monkeyPosition.y - y
        let term1 = pow(distanceX,2) / pow(rangeX, 2)
        let term2 = pow(distanceY,2) / pow(rangeY, 2)
        let result = term1 + term2
        return result <= 1
    }
    
    func getDamage() -> Float {
        return damage
    }
    
    func faceEnemy(enemy: SKSpriteNode) {
        let deltaX = enemy.position.x - sprite.position.x
        if deltaX > 0 {
            sprite.xScale = abs(sprite.xScale)
        } else if deltaX < 0{
            sprite.xScale = -abs(sprite.xScale)
        }
    }
    
    func facePoint(point: CGPoint) {
        let deltaX = point.x - sprite.position.x
        if deltaX > 0 {
            sprite.xScale = abs(sprite.xScale)
        } else if deltaX < 0{
            sprite.xScale = -abs(sprite.xScale)
        }
    }
    
    func takingDamage(){
        guard !isMonkeyTakingDamage, !isMonkeyAttacking else { return }
        self.isMonkeyTakingDamage = true
        let textures = Textures.getTextures(atlas: assets.monkey_taking_damage)
        let action = SKAction.animate(with: textures,
                                      timePerFrame:  0.5/TimeInterval(textures.count),
                                      resize: true,
                                      restore: true)
        sprite.removeAllActions()
        sprite.run(action) {
            self.isMonkeyTakingDamage = false
            self.stop()
        }
    }
    
    func die() {
        let textures = Textures.getTextures(atlas: assets.alligatorDying)
        let startAction = SKAction.animate(with: textures,
                                           timePerFrame: 0.5/TimeInterval(textures.count),
                                      resize: true,
                                      restore: true)
        
        let finishedAction = SKAction.run {
            self.sprite.removeFromParent()
        }

        sprite.removeAllActions()
        sprite.run(SKAction.sequence([startAction, finishedAction]))
    }

    

    
//    let moveAction = SKAction.move(to: CGPoint(x: capybara.position.x,
//                                               y: capybara.position.y), duration: 2)
//
//    let deleteAction = SKAction.removeFromParent()
//    let combine = SKAction.sequence([moveAction, deleteAction])
//    bananaBullet.run(combine)
    
    
    func attack(capyX: CGFloat, capyY: CGFloat, monkey: SKSpriteNode, capybara: SKSpriteNode ) {
    
            
            let bananaBullet = SKSpriteNode(imageNamed: assets.banana)
            //let bulletTravelTime = distanceBetweenPoints(monkey.position, capybara.position)/bananaBulletSpeed
            
            bananaBullet.position = CGPoint(x: monkey.position.x ,
                                       y: monkey.position.y)
            bananaBullet.setScale(0.1)
            bananaBullet.zPosition = 3
            bananaBullet.zRotation = angleBetweenPoints(point1: monkey.position, point2: capybara.position)
            monkey.parent?.addChild(bananaBullet)
        
        
        
        ///
            let moveAction = SKAction.move(to: CGPoint(x: capybara.position.x,
                                                       y: capybara.position.y), duration: 2)
        
            let rotateAction = SKAction.rotate(byAngle: -15 * .pi / 1, duration: 2 )
        
            //let rotateAction = SKAction.rotate(byAngle: - 6 * .pi / 1, duration: 2 )
        
            let deleteAction = SKAction.removeFromParent()
        
            
            let move_and_rotate = SKAction.run {
            
                bananaBullet.run(rotateAction)
                bananaBullet.run(moveAction)
         }
        
            //let combine = SKAction.sequence([move_and_rotate, deleteAction])
        //bananaBullet.run(combine)
            bananaBullet.run(move_and_rotate)
        
        
        ///
            
            let textures = Textures.getTextures(atlas: assets.monkeyAttacking)
            
            let animation = SKAction.animate(with: textures, timePerFrame: 0.15,
                                             resize: true,
                                             restore: true)
            faceEnemy(enemy: capybara)
            

            sprite.removeAllActions()
            sprite.run(SKAction.sequence([animation])) {
                self.stop()
            }

    }
}
