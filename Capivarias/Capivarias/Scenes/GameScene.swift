//
//  GameScene.swift
//  Joystick
//
//  Created by Clissia Bozzer Bovi on 02/10/23.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene, SKPhysicsContactDelegate {
    var  lifeBar = LifeBar()
    var sounds = Sounds()
    var virtualController: GCVirtualController?
    var joystick = Joystick()
    var enemies: [Alligator] = [Alligator()]
    var audioPlayer = AudioPlayer()
    var capybara = Capybara()
    let backgroundController = BackgroundController()
    var door = SKSpriteNode()
    var isContact: Bool = false
    var transactionScene = TrasactionsScenes()
    var gameOver: TimeInterval = 0
    var lastEnemyIndex: Int = 0
    let assets = Assets()
    var weapon: Bool = true
    var maxLife: CGFloat = 100
    var weaponSelection = WeaponSelection()
    
    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        setupCapivara()
        getDoor()
        setupAlligator()
        connectController()
        setObstacles()
        setupContact()
        audioPlayer.playEnviroment(sound: sounds.ambient, type: "mp3", volume: 0.7)
        setupLifeBar()
        setupWeaponSelection()
        
    }
    
    private func setupLifeBar() {
        addChild(lifeBar)
        lifeBar.position = .init(x: 300, y: 960)
        lifeBar.zPosition = 99
        lifeBar.xScale = 0.7
        lifeBar.yScale = 0.7
    }

    private func setupWeaponSelection() {
        addChild(weaponSelection)
        weaponSelection.position = .init(x: 100, y: 902)
        weaponSelection.zPosition = 99
        weaponSelection.xScale = 0.7
        weaponSelection.yScale = 0.7
    }
    
    
    
    func changeLifeBar() {
        
    }
    
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: assets.map3)
    }
    
    private func getDoor() {
        self.door = childNode(withName: "Door") as! SKSpriteNode
    }
    
    
    private func setObstacles() {
        setNode(nodeName: "tree", textureName: "tronco")
        setNode(nodeName: "rock", textureName: "rock")
        setNode(nodeName: "lake", textureName: "lake")
        setNode(nodeName: "lake-rock", textureName: "lake-rock")
        setNode(nodeName: "rock1", textureName: "Rock1")

    }
    
    private func setNode(nodeName: String, textureName: String) {
        let node = childNode(withName: nodeName) as! SKSpriteNode
        let texture = SKTexture(imageNamed: textureName)
        
        node.physicsBody = SKPhysicsBody(texture: texture, size: node.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.allowsRotation = false
        node.physicsBody?.affectedByGravity = false
    }
    
    private func setupContact() {
        self.physicsWorld.contactDelegate = self
    }
    
    private func setupAlligator() {
        generateEnemies()
        for i in 0..<enemies.count {
            self.enemies[i].start(
                screenWidth: size.width,
                screenHeight: size.height,
                spawnPosition: Position.randomize(size),
                mask: i+2)
            addChild(enemies[i].sprite)
        }
    }
    
    private func generateEnemies() {
        let plusEnemieNumber = Int.random(in: 0..<3)
        for _ in 0..<plusEnemieNumber {
            enemies.append(Alligator())
        }
    }
    
    private func setupScene() {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)
    }
    
    private func setupCapivara() {
        self.capybara.start(screenWidth: size.width , screenHeight: size.height)
        addChild(capybara.sprite)
    }
    
    private func removeDoor() {
        door.removeFromParent()
    }
    
    override func update(_ currentTime: TimeInterval) {
        for i in 0..<enemies.count {
            if !enemies[i].isInContact {
                enemies[i].follow(player: capybara.sprite.position)
            }
            enemyAutomaticAttack(i, currentTime)
        }
        
        if joystick.isJoystickStatic() {
            if !capybara.isCapivaraHitting && !capybara.isCapivaraTakingDamage {
                if weapon == true {
                    capybara.stop()
                }
                else {
                    capybara.stopZarabatana()
                }
            }
        } else {
            let direction = joystick.getDirection()
            validateMovement(direction)
            if !capybara.isCapivaraHitting && !capybara.isCapivaraTakingDamage {
                if weapon == true {
                    capybara.walk(positionX: joystick.positionX )
                } else {
                    capybara.walkZarabatana(positionX: joystick.positionX )
                }
            }
        }

        capybara.death()
        if capybara.getLife() <= 0 {
            if (currentTime - enemies[lastEnemyIndex].finishAnimation) > 1 {
                enemies[lastEnemyIndex].sprite.removeAllActions()
            }
            
            if (currentTime - gameOver) > 4 {
                if let view = self.view {
                    virtualController?.disconnect()
                    transactionScene.gameOver(view: view, gameScene: GameOverGameScene())
                }
            }
        }
        
        if let view = self.view {
            if capybara.sprite.position.x >= 1400 {
                virtualController?.disconnect()
                transactionScene.goToNextLevel(view: view, gameScene: "SecondScene")
            }
        }
        
        lifeBar.updateProgress(capybara.life / Float(maxLife))
        
        
    }
    
    private func enemyAutomaticAttack(_ i: Int, _ currentTime: TimeInterval) {
        if enemies[i].isInContact {
            if ((currentTime - enemies[i].lastHit) > 3 && !enemies[i].isAlligatorTakingDamage) {
                enemies[i].lastHit = currentTime
                enemies[i].attack()
                capybara.takingDamage()
                self.capybara.changeLife(damage: self.enemies[lastEnemyIndex].getDamage())
            }
        }
    }
        
    private func validateMovement(_ direction: Direction) {
        switch direction.horizontal {
        case .left:
            capybara.goLeft()
        case .right:
            capybara.goRight()
        case .none:
            break
        }
        
        switch direction.vertical {
        case .top:
            capybara.goTop()
        case .bottom:
            capybara.goBottom()
        case .none:
            break
        }
    }
    
    func setupController(){
        self.virtualController?.controller?.extendedGamepad?.buttonX.pressedChangedHandler = { button, value, pressed in
            if self.weapon == true {
                if pressed && self.isContact {
                    self.capybara.hit()
                    self.playerAttack()
                }
                else {
                    self.capybara.hit()
                }
            } else {
                self.capybara.shootZarabatana(capybara: self.capybara.sprite,
                                              alligator: self.enemies[self.lastEnemyIndex].sprite)
            }
        }
        changeWeapon()
    }

    func connectController() {
        joystick.connectController { controller in
            self.virtualController = controller
            self.setupController()
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        let enemyIndex = getEnemy(bodyA, bodyB)
        enemies[enemyIndex].isInContact = false
        isContact = false
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask
        let alligatorMaskA = isEnemyMask(bodyA)
        let alligatorMaskB = isEnemyMask(bodyB)
        
        if bodyA == 1 && alligatorMaskB {
            contactAttack(bodyA, bodyB)
        }
        if alligatorMaskA && bodyB == 1 {
            contactAttack(bodyA, bodyB)
        }
        
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 3 {
            enemies[self.lastEnemyIndex].changeLife(damage: capybara.getDamageZarabatana())
        }
    }

    private func contactAttack(_ bodyA: UInt32, _ bodyB: UInt32) {
        lastEnemyIndex = getEnemy(bodyA, bodyB)
        enemies[lastEnemyIndex].isInContact = true
        isContact = true
        
        if enemies[lastEnemyIndex].isAlligatoraAttacking == false {
            capybara.changeLife(damage: enemies[lastEnemyIndex].getDamage())
        }
    }
    
    private func getEnemy(_ bodyA: UInt32, _ bodyB: UInt32) -> Int {
        var index = 0
        let body = (bodyA == 1) ? bodyB : bodyA
        for i in enemies {
            if body == i.sprite.physicsBody?.categoryBitMask {
                index = enemies.firstIndex{$0 === i} ?? 0
                break
            }
        }
        return index
    }

    private func isEnemyMask(_ mask: UInt32) -> Bool {
        return (mask == 2 || mask == 3 || mask == 4)
    }

    private func enemyDied(_ index: Int) {
        self.enemies[index].die()
        self.enemies.remove(at: index)
        isEnemiesEmpty()
    }

    private func isEnemiesEmpty() {
        if enemies.isEmpty {
            removeDoor()
        }
    }

    private func changeWeapon() {
        self.virtualController?.controller?.extendedGamepad?.buttonY.pressedChangedHandler = { button, value, pressed in
            if pressed {
                self.weapon.toggle()
                self.weaponSelection.changeWeapon(weapon: self.weapon)
            }
            else {
            }
        }
    }

    private func playerAttack() {
        for i in 0..<enemies.count {
            if enemies[i].isInContact && enemies[i].isInFrontOfCapybara(position: capybara.sprite.position, xScale: capybara.sprite.xScale) {
                enemies[i].changeLife(damage: self.capybara.getDamage())
                if enemies[i].getLife() <= 0 {
                    self.enemyDied(i)
                } else {
                    enemies[i].takingDamage()
                }
            }
        }
    }
}
