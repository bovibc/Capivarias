//
//  ButtonNode.swift
//  Capivarias
//
//  Created by Renan Tavares on 27/11/23.
//

import Foundation
import SpriteKit


class SKButtonNode: SKSpriteNode {
    var action: (() -> Void)?

    func setButtonAction(target: @escaping () -> Void) {
        self.isUserInteractionEnabled = true
        self.action = target
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let action = action {
            action()
        }
    }
}
