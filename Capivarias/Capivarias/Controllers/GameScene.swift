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
    var virtualController: GCVirtualController?
    let spriteScale = 0.07
    var joystick = Joystick()
    var alligator = Alligator()
    var audioPlayer = AudioPlayer()
    var capybara = Capybara()
    let backgroundController = BackgroundController()
    var door = SKSpriteNode()
    var i = 0
    var isContact: Bool = false
    var timeToAlligatorHit = 0
    var transactionScene = TrasactionsScenes()

    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        setupCapivara()
        removeDoor()
        getDoor()
        removeDoor()
        setupAlligator()
        connectController()
        setupAudio()
        setObstacles()
        setupContact()
        
    }
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: "mapateste")
    }

    private func getDoor() {
        self.door = childNode(withName: "Door") as! SKSpriteNode
    }

    private func setObstacles() {
        setLake()
        setTree()
    }

    private func setTree() {
        let tree = childNode(withName: "tree") as! SKSpriteNode
        let treeTexture = SKTexture(imageNamed: "tree")

        tree.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: tree.size.width, height: tree.size.height/3), center: CGPoint(x: 0, y: -tree.size.height/3))
        tree.physicsBody?.isDynamic = false
        tree.physicsBody?.allowsRotation = false
        tree.physicsBody?.affectedByGravity = false
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
    
    private func setupAlligator() {
        self.alligator.start(screenWidth: size.width , screenHeight: size.height)
        addChild(alligator.sprite)
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
        alligator.follow(player: capybara.sprite.position)
        if joystick.isJoystickStatic() {
            
            if !capybara.isCapivaraHitting {
                capybara.stop()
            }

        } else {
            let direction = joystick.getDirection()
            validateMovement(direction)
            capybara.walk(positionX: joystick.positionX )
        }

        capybara.death()
        if capybara.life <= 0 {
            alligator.isFollowing = false
            alligator.sprite.removeAllActions()
        }

        if isContact {
            if (currentTime - alligator.lastHit) > 3 {
                alligator.lastHit = currentTime
                alligator.attack()
                self.capybara.changeLife(damage: self.alligator.getDamage())
                print(capybara.life)
            }
        }

        if let view = self.view {
            if capybara.sprite.position.x >= 1400 {
                transactionScene.goToNextLevel(view: view, gameScene: SecondScene())
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
            if pressed && self.isContact {
                self.capybara.hit()
                self.alligator.changeLife(damage: self.capybara.getDamage())

            }
            else {
                self.capybara.hit()
            }
        }
    }

    func connectController() {
        joystick.connectController { controller in
            self.virtualController = controller
            self.setupController()
        }
    }

    func didEnd(_ contact: SKPhysicsContact) {
        isContact = false
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2 {
            i+=1
            isContact = true
        
        }
        
        if contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1 {
            i+=1
            isContact = true
        }
    }
    
    
    
//    func goToNextLevel(){
//        let secondScene = SecondScene()
//            
//        let transition = SKTransition.fade(withDuration: 1.0)
//        self.view?.presentScene(secondScene, transition: transition)
//    }
//        
//    func nextLevel() {
//        if capybara.sprite.position.x >= 1270 {
//            goToNextLevel()
//        }
//    }
    
}
