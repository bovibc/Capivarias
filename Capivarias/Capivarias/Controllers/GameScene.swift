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
    var background = SKSpriteNode(imageNamed: "dry")
    let spriteScale = 0.07
    var joystick = Joystick()
    var alligator = Alligator()
    var audioPlayer = AudioPlayer()
    var capybara = Capybara()
    let backgroundController = BackgroundController()
    var i = 0
    var isContact: Bool = false
    var timeToAlligatorHit = 0
    
    override func didMove(to view: SKView) {
        backgroundController.setupBackground(scene: self, imageName: "dry")
        setupScene()
        setupCapivara()
        setupAlligator()
        connectController()
        audioPlayer.playEnviroment(sound: "ambient-forest", type: "mp3", volume: 1.0)
        setupContact()
    }
    
    private func setupContact() {
        self.physicsWorld.contactDelegate = self
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
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)}
    
    
    private func setupCapivara() {
        self.capybara.start(screenWidth: size.width , screenHeight: size.height)
        addChild(capybara.sprite)
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
        }
        
        if isContact {
            if (currentTime - alligator.lastHit) > 3 {
                alligator.lastHit = currentTime
                alligator.attack()
                self.capybara.changeLife(damage: self.alligator.getDamage())
                print(capybara.life)
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
}
