//
//  SecondScene.swift
//  Capivarias
//
//  Created by Renan Tavares on 27/10/23.
//

import SpriteKit
import GameplayKit
import GameController

class SecondScene: SKScene {

    override func didMove(to view: SKView) {
        setupScene()
    }
    
    private func setupScene() {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)
    }
}
