//
//  GameScene.swift
//  Joystick
//
//  Created by Clissia Bozzer Bovi on 02/10/23.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene {
    
    var virtualController: GCVirtualController?
    var background = SKSpriteNode(imageNamed: "dry")
    let spriteScale = 0.07
    var joystick = Joystick()
    var alligator = Alligator()
    var capybara = Capybara()
    let ContactPlayer: UInt32 = 0x1 << 0
    let ContactAlligator: UInt32 = 0x1 << 1
    var i = 0
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupScene()
        setupCapivara()
        setupAlligator()
        connectController()
        setupContact()
    }
    
    private func setupContact() {
        physicsWorld.contactDelegate = self
        capybara.sprite.physicsBody?.categoryBitMask = ContactPlayer
        alligator.sprite.physicsBody?.categoryBitMask = ContactAlligator
        capybara.sprite.physicsBody?.collisionBitMask = 0
        alligator.sprite.physicsBody?.collisionBitMask = 0
    }

    private func setupBackground() {
        self.scaleMode = .fill
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.xScale = frame.size.width / background.size.width
        background.yScale = frame.size.height / background.size.height
        addChild(background)
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
    
    override func update(_ currentTime: TimeInterval) {
        alligator.follow(player: capybara.sprite.position)
        if joystick.isJoystickStatic() {
            capybara.stop()
            capybara.isCapivaraWalking = false
        } else {
            let direction = joystick.getDirection()
            validateMovement(direction)
            
            
            capybara.walk(positionX: joystick.positionX )
            
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
    
    func connectController() {
        joystick.connectController { controller in
            self.virtualController = controller
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        //alligator.attack()
    }
}
