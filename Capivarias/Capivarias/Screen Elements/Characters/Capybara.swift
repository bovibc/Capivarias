//
//  Capybara.swift
//  Capivarias
//
//  Created by Clissia Bozzer Bovi on 19/10/23.
//

import Foundation
import SpriteKit

class Capybara {
    var isCapivaraHitting = false
    var isCapivaraWalking = false
    var isCapivaraTakingDamage = false
    var life: Float = 100
    private var damage: Float = 20   //Aqui, é o dano da espada
    private var damageZarabatana: Float = 5
    private var breathTime: Float = 100
    private var speed: CGFloat = 5
    private var defense: Float = 100
    private var assetScale: CGFloat = 0.1
    private var staticName: String = "capybara_stopped"
    var audioPlayer = AudioPlayer()
    var sounds = Sounds()
    let assets = Assets()
    let attackTexture:[SKTexture]
    let walkTexture:[SKTexture]
    let damageTexture:[SKTexture]
    var sprite: SKSpriteNode
    var shoot = SKSpriteNode()

    init() {
        self.sprite = SKSpriteNode(imageNamed: staticName)
        attackTexture = Textures.getTextures(atlas: assets.capybaraAttack)
        walkTexture = Textures.getTextures(atlas: assets.capybaraWalk)
        damageTexture = Textures.getTextures(atlas: assets.capybaraDamage)
    }

    func changeLife(damage: Float) {
        life -= damage
    }

    func getLife() -> Float {
        return life
    }

    func getDamage() -> Float {
        return damage
    }

    func getDamageZarabatana() -> Float {
        return damageZarabatana
    }

    func start(screenWidth: CGFloat, screenHeight: CGFloat) {
        let scaleX = screenWidth * assetScale / sprite.size.width
        let scaleY = screenHeight * assetScale / sprite.size.height
        sprite.xScale = scaleX
        sprite.yScale = scaleY
        
        setPosition(screenWidth, screenHeight)
        setPhysics()
        sprite.name = "capybara"
    }

    private func setPhysics() {
        let width = 0.45 * sprite.size.width
        let height = 0.25 * sprite.size.height
        sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: width, height: height), center: CGPoint(x: -25, y: -40))
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.allowsRotation = false
        sprite.physicsBody?.categoryBitMask = 1
    }

    private func setPosition(_ screenWidth: CGFloat, _ screenHeight: CGFloat) {        
        sprite.position = CGPoint(x: screenWidth/8, y: screenHeight/2)
        sprite.zPosition = 20
    }

    func stop() {
        self.isCapivaraHitting = false
        self.isCapivaraWalking = false
        self.isCapivaraTakingDamage = false
        let textures = [SKTexture(imageNamed: "capybara_stopped")]
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 0.001,
                                      resize: true,
                                      restore: true)
        sprite.removeAllActions()
        sprite.run(SKAction.repeatForever(action))
    }

    func stopZarabatana() {
        self.isCapivaraHitting = false
        self.isCapivaraWalking = false
        self.isCapivaraTakingDamage = false
        let textures = [SKTexture(imageNamed: assets.stoppedZarabatana)]
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 0.001,
                                      resize: true,
                                      restore: true)
        sprite.removeAllActions()
        sprite.run(SKAction.repeatForever(action))
    }

    func hit() {
        guard !isCapivaraHitting else { return }
        audioPlayer.playEffect(effect: sounds.swordAttack, type: "mp3", volume: 0.1)
        
        let animation = SKAction.animate(with: attackTexture, timePerFrame: 0.07)
        
        isCapivaraWalking = false
        isCapivaraHitting = true

        sprite.removeAllActions()
        sprite.run(SKAction.sequence([animation])) {
            self.stop()
        }
    }

    func shootZarabatana(capybara: SKSpriteNode, alligator: SKSpriteNode) {
        
        guard !isCapivaraHitting else { return }
        
        let seedBullet = SKSpriteNode(imageNamed: assets.seedBullet)
        seedBullet.position = CGPoint(x: capybara.position.x + capybara.size.width / 2.0,
                                   y: capybara.position.y)
        seedBullet.setScale(0.3)
        seedBullet.zPosition = 3
        seedBullet.zRotation = angleBetweenPoints(point1: capybara.position, point2: alligator.position)
        seedBullet.physicsBody = SKPhysicsBody(rectangleOf: seedBullet.size)
        seedBullet.physicsBody?.isDynamic = false
        seedBullet.physicsBody?.categoryBitMask = 3 // Defina a categoria da física conforme necessário

        capybara.parent?.addChild(seedBullet)
        
        let moveAction = SKAction.move(to: CGPoint(x: alligator.position.x,
                                                   y: alligator.position.y), duration: 0.8)

        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, deleteAction])
        seedBullet.run(combine)
        
        let textures = Textures.getTextures(atlas: "Capybara_ShootingZarabatana")
        
        audioPlayer.playEffect(effect: "blow-gun", type: ".mp3", volume: 0.8)
        let animation = SKAction.animate(with: textures, timePerFrame: 0.07,
                                         resize: true,
                                         restore: true)

        isCapivaraWalking = false
        isCapivaraHitting = true

        sprite.removeAllActions()
        sprite.run(SKAction.sequence([animation])) {
            self.stop()
        }
    }
    
    func angleBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let distanceX = CGFloat(point1.x - point2.x)
        let distanceY = CGFloat(point1.y - point2.y)
        let tangent = distanceY / distanceX
        return tangent
    }
    
    func walk(positionX: CGFloat) {
        let action = SKAction.animate(with: walkTexture,
                                      timePerFrame: 1/TimeInterval(walkTexture.count),
                                      resize: true,
                                      restore: true)
        
        sprite.xScale = positionX > 0 ? abs(sprite.xScale) : -abs(sprite.xScale)

        if !isCapivaraWalking {
            isCapivaraWalking = true
            sprite.removeAllActions()
            sprite.run(SKAction.repeatForever(action))
        }
    }

    func walkZarabatana(positionX: CGFloat) {
        let textures = Textures.getTextures(atlas: "Capybara_Walking")
        let action = SKAction.animate(with: textures,
                                      timePerFrame: 1/TimeInterval(textures.count),
                                      resize: true,
                                      restore: true)
        
        sprite.xScale = positionX > 0 ? abs(sprite.xScale) : -abs(sprite.xScale)

        if !isCapivaraWalking {
            isCapivaraWalking = true
            sprite.removeAllActions()
            sprite.run(SKAction.repeatForever(action))
        }
    }

    func death() {
    if  life <= 0 {
        print("morreu")
        //Está entrando no print, mas deveria chamar a animaçao dela morrendo
        //não mudar essa textura
        //cortar as movimetações na tela e deixar o joystick inúil

        }
    }

    func takingDamage(){
        self.isCapivaraTakingDamage = true
        let action = SKAction.animate(with: damageTexture,
                                      timePerFrame:  1/TimeInterval(damageTexture.count),
                                      resize: true,
                                      restore: true)
        
        sprite.removeAllActions()
        sprite.run(action) {
            self.isCapivaraTakingDamage = false
            self.stop()
        }
    }
    
    func goLeft() {
        sprite.position.x += speed
    }

    func goRight() {
        sprite.position.x -= speed
    }

    func goTop() {
        sprite.position.y += speed
    }

    func goBottom() {
        sprite.position.y -= speed
    }
}
