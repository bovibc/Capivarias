//
//  Joystick.swift
//  Capivarias
//
//  Created by Clissia Bozzer Bovi on 19/10/23.
//

import Foundation
import GameController
import GameplayKit

class Joystick: SKScene {
    
    var playerSprite = SKSpriteNode(imageNamed: "parada") // isso é atributo da capirava
    var virtualController: GCVirtualController?
    var playerPositionX: CGFloat = 0
    var playerPositionY: CGFloat = 0
    var isCapivaraWalking: Bool?  // isso é atributo da capirava
    var playerSpeed: CGFloat? // isso é atributo da capirava
    
    override func update(_ currentTime: TimeInterval) {
        playerPositionX = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.xAxis.value)!)
        playerPositionY = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.yAxis.value)!)
       // followPlayer(x: playerPositionX, y: playerPositionY)

       // print("x: \(playerPositionX)      Y: \(playerPositionY)")

        if (playerPositionX < 0.005 && playerPositionX > -0.005) && (playerPositionY < 0.005 && playerPositionY > -0.005) {
            //stopCapivara()
            isCapivaraWalking = false
        } else {
           // walkCapivara()
        }

        if playerPositionX >= 0.5 {
            if let playerSpeed {
                playerSprite.position.x += playerSpeed
            }
            
        }

        if playerPositionX <= -0.5 {
            if let playerSpeed {
                playerSprite.position.x -= playerSpeed
            }
        }

        if playerPositionY >= 0.5 {
            if let playerSpeed {
                playerSprite.position.y += playerSpeed
            }
        }

        if playerPositionY <= -0.5 {
            if let playerSpeed {
                playerSprite.position.y -= playerSpeed
            }
        }
        
       // nextLevel()

    }
    
    
    func connectController(){
        let controlConfig = GCVirtualController.Configuration()
        controlConfig.elements = [GCInputLeftThumbstick, GCInputButtonX, GCInputButtonY]
        
        let controller = GCVirtualController(configuration: controlConfig)
        controller.connect()
        virtualController = controller
    }
}
