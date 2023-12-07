//
//  SecondScene.swift
//  Capivarias
//
//  Created by Renan Tavares on 27/10/23.
//

import SpriteKit
import GameplayKit
import GameController

class SecondScene: SKScene, SKPhysicsContactDelegate {

    var lifeBar = LifeBar()
    var virtualController: GCVirtualController?
    var joystick = Joystick()
    var monkey = Monkey()
    var enemies: [Monkey] = [Monkey()]
    var audioPlayer = AudioPlayer()
    var capybara = Capybara()
    let backgroundController = BackgroundController()
    var door = SKSpriteNode()
    let assets = Assets()
    var isContact: Bool = false
    var transactionScene = TrasactionsScenes()
    var gameOver: TimeInterval = 0
    var weapon: Bool = true
    var weaponSelection = WeaponSelection()
    var maxLife: CGFloat = 100
    var timeToChangePosition: TimeInterval = 0
    var lastEnemyIndex: Int = 0

    

    override func didMove(to view: SKView) {
        connectController()
        setupScene()
        setupBackground()
        setupCapivara()
        getDoor()
        removeDoor()
        setupMonkey()
        setupAudio()
        setObstacles()
        setupContact()
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
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: assets.map3)
    }

    private func getDoor() {
        self.door = childNode(withName: "Door") as! SKSpriteNode
    }

    private func setObstacles() {
        setLake()
        setTree()
        setRock()
    }

    private func setTree() {
        let tree = childNode(withName: "tree") as! SKSpriteNode
        let treeTexture = SKTexture(imageNamed: "tronco")
        
        tree.physicsBody = SKPhysicsBody(texture: treeTexture, size: tree.size)
        tree.physicsBody?.isDynamic = false
        tree.physicsBody?.allowsRotation = false
        tree.physicsBody?.affectedByGravity = false
    }

    private func setRock() {
        let rock = childNode(withName: "rock") as! SKSpriteNode
        let rockTexture = SKTexture(imageNamed: "rock")

        rock.physicsBody = SKPhysicsBody(texture: rockTexture, size: rock.size)
        rock.physicsBody?.isDynamic = false
        rock.physicsBody?.allowsRotation = false
        rock.physicsBody?.affectedByGravity = false
    }

    private func setLake() {
        let lake = childNode(withName: "lake") as! SKSpriteNode
        let lakeTexture = SKTexture(imageNamed: "lake")
        
        lake.physicsBody = SKPhysicsBody(texture: lakeTexture, size: lake.size)
        lake.physicsBody?.isDynamic = false
        lake.physicsBody?.allowsRotation = false
        lake.physicsBody?.affectedByGravity = false
    }

    private func setupAudio() {
        audioPlayer.playEnviroment(sound: "ambient-forest", type: "mp3", volume: 1.0)
    }
    


    private func setupContact() {
        self.physicsWorld.contactDelegate = self
    }
    
    func setupMonkey() {
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
            enemies.append(Monkey())
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
    
    
    private func timeToChangePosition(_ i: Int, _ currentTime: TimeInterval) {
        if ((currentTime - enemies[i].lastChangedPosition) > 4) {
                enemies[i].lastChangedPosition = currentTime
                enemies[i].changePosition(size: size, capyX: capybara.sprite.position.x, capyY: capybara.sprite.position.y, monkey: enemies[i].sprite, capybara: capybara.sprite)
            }
    }
    
//    private func timeToAttack(_ i: Int, _ currentTime: TimeInterval) {
//        if ((currentTime - enemies[i].lastAttack) > 3) {
//            enemies[i].lastAttack = currentTime
//            enemies[i].attack(capyX: capybara.sprite.position.x, capyY: capybara.sprite.position.y, monkey: enemies[i].sprite, capybara: capybara.sprite )
//            }
//    }

    
    override func update(_ currentTime: TimeInterval) {
        
//        for i in 0..<enemies.count {
//           // if !enemies[i].isInContact {
//            if enemies[i].isInContact == false {
//                //enemies[i].changePosition(size: size)
//                timeToChangePosition(i, currentTime)
//            }
//           
//        }
        
        
        for i in 0..<enemies.count {
            //timeToAttack(i, currentTime)
            timeToChangePosition(i, currentTime)
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
        if capybara.life <= 0 {
           monkey.sprite.removeAllActions()

            
            if (currentTime - gameOver) > 4 {
                
                if let view = self.view {
                    virtualController?.disconnect()
                    transactionScene.gameOver(view: view, gameScene: GameOverGameScene())
                }
            }
        }



        
        lifeBar.updateProgress(capybara.life / Float(maxLife))
        
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
                        //self.playerAttack()
                }
                else {
                    self.capybara.hit()
                }
            } else {
                self.capybara.shootZarabatana(capybara: self.capybara.sprite,
                                              alligator: self.monkey.sprite)
            }
        }
        changeWeapon()
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

    func connectController() {
        joystick.connectController { controller in
            self.virtualController = controller
            self.setupController()
        }
    }
    
    private func isEnemyMask(_ mask: UInt32) -> Bool {
        return (mask == 2 || mask == 3 || mask == 4)
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

//        if bodyA == 1 && alligatorMaskB {
//            contactAttack(bodyA, bodyB)
//        }
//        if alligatorMaskA && bodyB == 1 {
//            contactAttack(bodyA, bodyB)
//        }

//        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 3 {
//            enemies[self.lastEnemyIndex].changeLife(damage: capybara.getDamageZarabatana())
//        }
        
    }
    

    
    
    
    
    

    private func contactAttack() {
//        lastEnemyIndex = getEnemy(bodyA, bodyB)
        enemies[lastEnemyIndex].isInContact = true
        isContact = true
        
        if enemies[lastEnemyIndex].isMonkeyAttacking == false {
            capybara.changeLife(damage: enemies[lastEnemyIndex].getDamage())
        }
    }

    private func setGamePadAction() {
        self.virtualController?.controller?.extendedGamepad?.buttonX.pressedChangedHandler = { button, value, pressed in
            if pressed {
                self.capybara.hit()
               // self.alligator.changeLife(damage: self.capybara.getDamage())
                //Aqui, chamar alimaçao do jacare tomando dano
            }
        }
    }
}
