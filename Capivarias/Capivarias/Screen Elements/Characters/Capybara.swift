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
    private var damageSword: Float = 20
    private var damageZarabatana: Float = 500
    private var breathTime: Float = 100
    private var speed: CGFloat = 5
    private var defense: Float = 100
    private var assetScale: CGFloat = 0.1
    private var zarabatanaBulletSpeed = 600.0
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
        return damageSword
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
        sprite.physicsBody?.isDynamic = true
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

    func swordAttackAnimation() {
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

    func shootZarabatanaAnimation(capybara: SKSpriteNode, alligator: SKSpriteNode) {
        
        guard !isCapivaraHitting else { return }
        
        let seedBullet = SKSpriteNode(imageNamed: assets.seedBullet)
        let bulletTravelTime = distanceBetweenPoints(capybara.position, alligator.position)/zarabatanaBulletSpeed
        
        seedBullet.position = CGPoint(x: capybara.position.x + capybara.size.width / 2.0,
                                   y: capybara.position.y)
        seedBullet.setScale(0.3)
        seedBullet.zPosition = 3
        seedBullet.physicsBody = SKPhysicsBody(rectangleOf: seedBullet.size)
        seedBullet.physicsBody?.isDynamic = false
        seedBullet.physicsBody?.categoryBitMask = 3 // Defina a categoria da física conforme necessário

        capybara.parent?.addChild(seedBullet)
        let moveAction = SKAction.move(to: CGPoint(x: alligator.position.x,
                                                   y: alligator.position.y), duration: bulletTravelTime)

        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, deleteAction])
        seedBullet.run(combine)
        
        let textures = Textures.getTextures(atlas: assets.capybaraAttackZarabatana)
        
        audioPlayer.playEffect(effect: "blow-gun", type: ".mp3", volume: 0.8)
        let animation = SKAction.animate(with: textures, timePerFrame: 0.07,
                                         resize: true,
                                         restore: true)
        faceEnemy(enemy: alligator)
        
        isCapivaraWalking = false
        isCapivaraHitting = true

        sprite.removeAllActions()
        sprite.run(SKAction.sequence([animation])) {
            self.stop()
        }
    }
    
    func closestEnemyAsLast(enemy: inout [Alligator]){
        
        guard !enemy.isEmpty else {
            return
        }
        
        var closestDistance = Double.infinity
        var closestEnemyIndex = 0
        
        for (index, enemy) in enemy.enumerated(){
            let distance = distanceBetweenPoints(sprite.position, enemy.sprite.position)
            
            if distance < closestDistance{
                closestDistance = distance
                closestEnemyIndex = index
            }
        }
        
        let closestEnemy = enemy.remove(at: closestEnemyIndex)
        enemy.append(closestEnemy)
    }
    
    func faceEnemy(enemy: SKSpriteNode) {
        let deltaX = enemy.position.x - sprite.position.x
        if deltaX > 0 {
            sprite.xScale = abs(sprite.xScale)
        } else if deltaX < 0{
            sprite.xScale = -abs(sprite.xScale)
        }
    }
    
    func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> Double {
        let deltaX = point2.x - point1.x
        let deltaY = point2.y - point1.y
        let distancia = sqrt(pow(deltaX, 2) + pow(deltaY, 2))
        
        return Double(distancia)
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
