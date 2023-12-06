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
    var lifeBar = LifeBar()
    var sounds = Sounds()
    var virtualController: GCVirtualController?
    var joystick = Joystick()
    var enemies: [Alligator] = [Alligator()]
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
        setupLifeBar()
        setupWeaponSelection()
        AudioPlayer.shared.EnviromentSong()
        
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
        weaponSelection.position = .init(x: 77, y: 902)
        weaponSelection.zPosition = 99
        weaponSelection.xScale = 0.4
        weaponSelection.yScale = 0.4
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
                name: i+2)
            addChild(enemies[i].sprite)
        }
    }

    private func generateEnemies() {
        let plusEnemieNumber = Int.random(in: 0..<4)
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

        capybara.closestEnemyAsLast(enemy: &enemies)
        capybara.death() {
            self.gameOverActions(currentTime)
        }

        if let view = self.view {
            if capybara.sprite.position.x >= 1400 {
                virtualController?.disconnect()
                transactionScene.goToNextLevel(view: view, gameScene: "SecondScene")
            }
        }

        lifeBar.updateProgress(capybara.life / Float(maxLife))
    }
    
    private func gameOverActions(_ currentTime: TimeInterval) {
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
    
    private func enemyAutomaticAttack(_ i: Int, _ currentTime: TimeInterval) {
        if enemies[i].isInContact {
            if ((currentTime - enemies[i].lastHit) > 3 && !enemies[i].isAlligatorTakingDamage) {
                enemies[i].lastHit = currentTime
                enemies[i].attack()
                capybara.takingDamage()
                self.capybara.changeLife(damage: self.enemies[i].getDamage())
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
                    self.capybara.swordAttackAnimation()
                    self.playerSwordAttack()
                }
                else {
                    self.capybara.swordAttackAnimation()
                }
            } else if !self.enemies.isEmpty {
                //MARK: animaçao da zarabatana
                self.capybara.shootZarabatanaAnimation(capybara: self.capybara.sprite,
                                              alligator: self.enemies[self.enemies.count-1].sprite)
                print(self.enemies[self.enemies.count-1].getLife())
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
        guard !enemies.isEmpty else {
            return
        }

        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name
        let enemyIndex = getEnemy(bodyA, bodyB)
        enemies[enemyIndex].isInContact = false
        isContact = false
    }

    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.categoryBitMask
        let bodyB = contact.bodyB.categoryBitMask

        let nameA = contact.bodyA.node?.name
        let nameB = contact.bodyB.node?.name

        if bodyA == 1 && bodyB == 2 {
            contactAttack(nameA, nameB)
        }
        if bodyA == 2  && bodyB == 1 {
            contactAttack(nameA, nameB)
        }

        if bodyA == 6 && bodyB == 2  {
            enemies[self.lastEnemyIndex].changeLife(damage: capybara.getDamageZarabatana())
        }

        if bodyA == 2  && bodyB == 6 {
            enemies[self.lastEnemyIndex].changeLife(damage: capybara.getDamageZarabatana())
        }
    }

    private func contactAttack(_ bodyA: String?, _ bodyB: String?) {
        guard !enemies.isEmpty else {
            return
        }
        
        lastEnemyIndex = getEnemy(bodyA, bodyB)
        enemies[lastEnemyIndex].isInContact = true
        isContact = true
        
        if enemies[lastEnemyIndex].isAlligatoraAttacking == false {
            capybara.changeLife(damage: enemies[lastEnemyIndex].getDamage())
        }
    }

    private func getEnemy(_ bodyA: String?, _ bodyB: String?) -> Int {
        guard let bodyA = bodyA, let bodyB = bodyB else { return 0 }
        var index = 0
        let body = (bodyA == "capybara") ? bodyB : bodyA
        for i in enemies {
            if body == i.sprite.name {
                index = enemies.firstIndex{$0 === i} ?? 0
                break
            }
        }
        return index
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

    private func playerSwordAttack() {
        for i in 0..<enemies.count {
            if i >= enemies.count { return }
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
    
    private func playerZarabatanaAttack() {
        for i in 0..<enemies.count {
            if i >= enemies.count { return }
                if enemies[i].getLife() <= 0 {
                    self.enemyDied(i)
                } else {
                    enemies[i].takingDamage()
                    enemies[self.enemies.count-1].changeLife(damage: capybara.getDamageZarabatana())
                }
            }
        }
}
