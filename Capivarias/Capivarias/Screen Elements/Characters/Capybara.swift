//
//  Capybara.swift
//  Capivarias
//
//  Created by Clissia Bozzer Bovi on 19/10/23.
//

import Foundation
import SpriteKit

class Capybara {
    var currentState = CapybaraStates.none
    
//    var isCapivaraHitting = false
//    var isCapivaraWalking = false
//    var isCapivaraTakingDamage = false
//    private var isDead = false

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

    var sprite: SKSpriteNode
    let idleSwordTexture:[SKTexture]
    let attackSwordTexture:[SKTexture]
    let runSwordTexture:[SKTexture]
    let takingDamageTexture:[SKTexture]
    let dyingTexture:[SKTexture]
    let idleZarabatanaTexture:[SKTexture]
    let attackZarabatanaTexture:[SKTexture]
    let deadTexture:[SKTexture]
    let walkZarabatanaTexture:[SKTexture]

    var shoot = SKSpriteNode()

    init() {
        self.sprite = SKSpriteNode(imageNamed: assets.idleCapybara)
        idleSwordTexture = [SKTexture(imageNamed: staticName)]
        attackSwordTexture = Textures.getTextures(atlas: assets.capybaraAttack)
        runSwordTexture = Textures.getTextures(atlas: assets.capybaraWalk)
        
        idleZarabatanaTexture = [SKTexture(imageNamed: assets.stoppedZarabatana)]
        attackZarabatanaTexture = Textures.getTextures(atlas: assets.capybaraAttackZarabatana)
        walkZarabatanaTexture = Textures.getTextures(atlas: assets.capybaraZarabanataWalking)

        takingDamageTexture = Textures.getTextures(atlas: assets.capybaraDamage)
        dyingTexture = Textures.getTextures(atlas: assets.capybaraDying)
        deadTexture = Textures.getTextures(atlas: assets.deadCapybara )
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
        stateManager(nextState: .idleSword)
//        self.isCapivaraHitting = false
//        self.isCapivaraWalking = false
//        self.isCapivaraTakingDamage = false
//        let textures = [SKTexture(imageNamed: staticName)]
//        let action = SKAction.animate(with: textures,
//                                      timePerFrame: 0.001,
//                                      resize: true,
//                                      restore: true)
//        sprite.removeAllActions()
//        sprite.run(SKAction.repeatForever(action))
    }

    func idleZarabatana() {
        stateManager(nextState: .idleZarabatana)
//        self.isCapivaraHitting = false
//        self.isCapivaraWalking = false
//        self.isCapivaraTakingDamage = false
//        let textures = [SKTexture(imageNamed: assets.stoppedZarabatana)]
//        let action = SKAction.animate(with: textures,
//                                      timePerFrame: 0.001,
//                                      resize: true,
//                                      restore: true)
//        sprite.removeAllActions()
//        sprite.run(SKAction.repeatForever(action))
    }

    func swordAttackAnimation() {
//        guard !isCapivaraHitting else { return }
        stateManager(nextState: .attackSword)
        audioPlayer.playEffect(effect: sounds.swordAttack, type: "mp3", volume: 0.1)
        
//        let animation = SKAction.animate(with: attackSwordTexture, timePerFrame: 0.07)
//        
//        isCapivaraWalking = false
//        isCapivaraHitting = true
//
//        sprite.removeAllActions()
//        sprite.run(SKAction.sequence([animation])) {
//            self.stop()
//        }
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
        seedBullet.physicsBody?.categoryBitMask = 6 // Defina a categoria da física conforme necessário
        seedBullet.physicsBody?.contactTestBitMask = 2

        capybara.parent?.addChild(seedBullet)
        let moveAction = SKAction.move(to: CGPoint(x: alligator.position.x,
                                                   y: alligator.position.y), duration: bulletTravelTime)

        let deleteAction = SKAction.removeFromParent()
        let combine = SKAction.sequence([moveAction, deleteAction])
        seedBullet.run(combine)
        
        audioPlayer.playEffect(effect: "blow-gun", type: ".mp3", volume: 0.8)

        stateManager(nextState: .attackZarabatana)
//        let textures = Textures.getTextures(atlas: assets.capybaraAttackZarabatana)
//        
//        let animation = SKAction.animate(with: textures, timePerFrame: 0.07,
//                                         resize: true,
//                                         restore: true)
        faceEnemy(enemy: alligator)
        
//        isCapivaraWalking = false
//        isCapivaraHitting = true
//
//        sprite.removeAllActions()
//        sprite.run(SKAction.sequence([animation])) {
//            self.stop()
//        }
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
        stateManager(nextState: .runSword)
//        let action = SKAction.animate(with: runSwordTexture,
//                                      timePerFrame: 1/TimeInterval(runSwordTexture.count),
//                                      resize: true,
//                                      restore: true)
        
        sprite.xScale = positionX > 0 ? abs(sprite.xScale) : -abs(sprite.xScale)

//        if !isCapivaraWalking {
//            isCapivaraWalking = true
//            sprite.removeAllActions()
//            sprite.run(SKAction.repeatForever(action))
//        }
    }

    func walkZarabatana(positionX: CGFloat) {
        stateManager(nextState: .runZarabatana)
//        let action = SKAction.animate(with: walkZarabatanaTexture,
//                                      timePerFrame: 1/TimeInterval(walkZarabatanaTexture.count),
//                                      resize: true,
//                                      restore: true)
//        
        sprite.xScale = positionX > 0 ? abs(sprite.xScale) : -abs(sprite.xScale)
//
//        if !isCapivaraWalking {
//            isCapivaraWalking = true
//            sprite.removeAllActions()
//            sprite.run(SKAction.repeatForever(action))
//        }
    }

    func death(_ death: @escaping ()-> Void) {
        stateManager(nextState: .die)
//        guard !isDead else  { return }
//        if  life <= 0 {
//            isDead = true
//            let startAction = SKAction.run {
//                self.dyingAction()
//            }
//            let finishAction = SKAction.run {
//                self.stayingDeadAction()
//            }
//            let callback = SKAction.run {
//                death()
//                self.sprite.removeFromParent()
//            }

//            let action = SKAction.sequence([startAction, SKAction.wait(forDuration: 0.7), finishAction, SKAction.wait(forDuration: 0.5), callback])
//            self.sprite.removeAllActions()
//            self.sprite.run(action)
        }

    private func dyingAction() {
        stateManager(nextState: .die)
//        let textures = Textures.getTextures(atlas: assets.capybaraDying)
//        let action = SKAction.animate(with: textures,
//                                      timePerFrame: 0.7/TimeInterval(textures.count),
//                                      resize: true,
//                                      restore: true)
//
//        sprite.run(action)
    }

//    private func stayingDeadAction() {
//        let textures = Textures.getTextures(atlas: assets.deadCapybara )
//        let action = SKAction.animate(with: textures,
//                                      timePerFrame: 0.001,
//                                      resize: true,
//                                      restore: true)
//
//        sprite.run(SKAction.repeatForever(action))
//    }

    func takingDamage(){
        stateManager(nextState: .takingDamage)
//        self.isCapivaraTakingDamage = true
//        let action = SKAction.animate(with: damageTexture,
//                                      timePerFrame:  1/TimeInterval(damageTexture.count),
//                                      resize: true,
//                                      restore: true)
//        
//        sprite.removeAllActions()
//        sprite.run(action) {
//            self.isCapivaraTakingDamage = false
//            self.stop()
//        }
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
    
    func spriteAnimation(textures: [SKTexture], timePerFrame: Double){
        let action = SKAction.animate(with: textures,
                                      timePerFrame: timePerFrame,
                                      resize: true,
                                      restore: true)
        sprite.run(SKAction.repeatForever(action))
    }
    
    func stateManager(nextState: CapybaraStates){
        exitState()
        enterState(nextState: nextState)
    }
    
    func enterState(nextState: CapybaraStates){
        currentState = nextState
        switch currentState {
        case .none:
            print("None case")
            
        case .idleSword:
            spriteAnimation(textures: idleSwordTexture, timePerFrame: 0.001)
            
        case .runSword:
            spriteAnimation(textures: runSwordTexture, timePerFrame: 1/TimeInterval(runSwordTexture.count))
            
        case .attackSword:
            spriteAnimation(textures: attackSwordTexture, timePerFrame: 1/TimeInterval(attackSwordTexture.count))
            
        case .idleZarabatana:
            spriteAnimation(textures: idleZarabatanaTexture, timePerFrame: 0.001)
            
        case .runZarabatana:
            let action = SKAction.animate(with: walkZarabatanaTexture,
                                          timePerFrame: 1/TimeInterval(walkZarabatanaTexture.count),
                                          resize: true,
                                          restore: true)
            sprite.run(SKAction.repeatForever(action))
            
        case .attackZarabatana:
            spriteAnimation(textures: attackZarabatanaTexture, timePerFrame: 1/TimeInterval(attackZarabatanaTexture.count))
            
        case .takingDamage:
            spriteAnimation(textures: takingDamageTexture, timePerFrame: 1/TimeInterval(takingDamageTexture.count))
            
        case .die:
            spriteAnimation(textures: dyingTexture, timePerFrame: 0.7/TimeInterval(dyingTexture.count))
            sprite.removeAllActions()
            let action = SKAction.animate(with: deadTexture,
                                          timePerFrame: 0.001,
                                          resize: true,
                                          restore: true)
            sprite.run(SKAction.repeatForever(action))
        }
    }
    
    func exitState(){
        //TODO: Pensar se sempre vai remover as ações
        sprite.removeAllActions()
    }
    

}

//class GameLogic {
//    func distanceBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> Double {
//        let deltaX = point2.x - point1.x
//        let deltaY = point2.y - point1.y
//        let distancia = sqrt(pow(deltaX, 2) + pow(deltaY, 2))
//        
//        return Double(distancia)
//    }
//}

