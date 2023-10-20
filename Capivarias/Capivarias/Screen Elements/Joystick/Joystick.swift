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
    
    var virtualController: GCVirtualController?
    var playerPositionX: CGFloat = 0
    var playerPositionY: CGFloat = 0
    
    func connectController(connect: @escaping ((GCVirtualController) -> Void)) {
        let controlConfig = GCVirtualController.Configuration()
        controlConfig.elements = [GCInputLeftThumbstick, GCInputButtonX, GCInputButtonY]
        
        let controller = GCVirtualController(configuration: controlConfig)
        controller.connect()
        connect(controller)
    }
}
