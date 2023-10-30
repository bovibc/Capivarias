//
//  TrasactionsScenes.swift
//  Capivarias
//
//  Created by Renan Tavares on 27/10/23.
//

import Foundation
import SpriteKit
import GameplayKit
import GameController



class TrasactionsScenes: SKScene {
    
    func goToNextLevel(view: SKView, gameScene: SKScene){
        let scene = gameScene
            
        let transition = SKTransition.fade(withDuration: 1.0)
        view.presentScene(scene as SKScene, transition: transition)
    }
}
