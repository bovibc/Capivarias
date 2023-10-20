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

    var playerSprite = SKSpriteNode(imageNamed: "capybara_stopped")
    var playerPositionX: CGFloat = 0
    var playerPositionY: CGFloat = 0
    var isCapivaraWalking = false
    var virtualController: GCVirtualController?
    var background = SKSpriteNode(imageNamed: "dry")
    var playerSpeed: CGFloat = 3
    let spriteScale = 0.07
    var capybara: Capybara = Capybara()
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupScene()
        setupCapivara()
        connectController()
    }

    private func setupBackground() {
        self.scaleMode = .fill
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        background.xScale = frame.size.width / background.size.width
        background.yScale = frame.size.height / background.size.height
        addChild(background)
    }

    private func setupScene() {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)
    }

    private func setupCapivara() {
        self.capybara.startCapybara(screenWidth: view?.frame.width ?? 0, screenHeight: size.height)
        addChild(capybara.sprite)
    }


    override func update(_ currentTime: TimeInterval) {
        playerPositionX = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.xAxis.value)!)
        playerPositionY = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.yAxis.value)!)
        

        print("x: \(playerPositionX)      Y: \(playerPositionY)")

        if (playerPositionX < 0.005 && playerPositionX > -0.005) && (playerPositionY < 0.005 && playerPositionY > -0.005) {
            isCapivaraWalking = false
        } else {
            
        }

        if playerPositionX >= 0.5 {
            playerSprite.position.x += playerSpeed
        }

        if playerPositionX <= -0.5 {
            playerSprite.position.x -= playerSpeed
        }

        if playerPositionY >= 0.5 {
            playerSprite.position.y += playerSpeed
        }

        if playerPositionY <= -0.5 {
            playerSprite.position.y -= playerSpeed
        }
    }


    func connectController() {
        let controlConfig = GCVirtualController.Configuration()
        controlConfig.elements = [GCInputLeftThumbstick, GCInputButtonX, GCInputButtonY]
        
        let controller = GCVirtualController(configuration: controlConfig)
        controller.connect()
        virtualController = controller
    }
}
