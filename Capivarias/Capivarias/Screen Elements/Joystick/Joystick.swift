//
//  Joystick.swift
//  Capivarias
//
//  Created by Clissia Bozzer Bovi on 19/10/23.
//

import Foundation
import GameController
import GameplayKit

struct Direction {
    let horizontal: HorizontalDirection
    let vertical: VerticalDirection
    
    init(_ horizontal: HorizontalDirection, _ vertical: VerticalDirection) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
}

enum HorizontalDirection {
    case left
    case right
    case none
}

enum VerticalDirection {
    case top
    case bottom
    case none
}

class Joystick: SKScene {
    var positionX: CGFloat = 0
    var positionY: CGFloat = 0
    var virtualController: GCVirtualController?
    
    var controller2: GCController?
    
    func isJoystickStatic() -> Bool {
        positionX = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.xAxis.value)!)
        positionY = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.yAxis.value)!)
        
        return (positionX < 0.005 && positionX > -0.005) && (positionY < 0.005 && positionY > -0.005)
    }
    
    func getDirection() -> Direction {
        positionX = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.xAxis.value)!)
        positionY = CGFloat((virtualController?.controller?.extendedGamepad?.leftThumbstick.yAxis.value)!)
        var horizontal: HorizontalDirection
        var vertical: VerticalDirection
        
        if positionX >= 0.5 {
            horizontal = .left
        } else if positionX <= -0.5 {
            horizontal = .right
        } else {
            horizontal = .none
        }
        
        if positionY >= 0.5 {
            vertical = .top
        } else if positionY <= -0.5 {
            vertical = .bottom
        } else {
            vertical = .none
        }
        
        return Direction(horizontal, vertical)
    }
    
    let buttonX: UIButton = {
        let button = UIButton()
        // Configurar a imagem para o botão X
        let image = UIImage(named: "Sair") // Substitua "sua_imagem" pelo nome da sua imagem
        button.setImage(image, for: .normal)
        // Adicionar uma ação para o botão X
        button.addTarget(Joystick.self, action: #selector(buttonXPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonXPressed(_ sender: UIButton) {
        // Ação ao pressionar o botão X
        print("Botão X pressionado")
    }
    
    
    func connectController(connect: @escaping ((GCVirtualController) -> Void)) {
        let controlConfig = GCVirtualController.Configuration()
        controlConfig.elements = [GCInputLeftThumbstick, GCInputButtonX, GCInputButtonY]
        
        let controller = GCVirtualController(configuration: controlConfig)
        
        controller.connect()
        
        virtualController = controller
        connect(controller)
        
        guard let controller2 = GCController.controllers().first else { return }
        
        controller2.extendedGamepad?.buttonX.pressedChangedHandler = { button, value , pressed in
            if pressed {
                
            }
        }
        
        
    }
}
