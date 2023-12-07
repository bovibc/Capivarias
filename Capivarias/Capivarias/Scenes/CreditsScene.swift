//
//  CreditsScene.swift
//  Capivarias
//
//  Created by Renan Tavares on 04/12/23.
//

import Foundation
import SpriteKit
import GameplayKit
import GameController

class CreditsScene: SKScene {
    let assets = Assets()
    let backgroundController = BackgroundController()
    let transactionScene = TrasactionsScenes()
    override func didMove(to view: SKView) {
        setupScene()
        setupBackground()
        //photo()
        teamPhoto()
        team()
        exit()
        AudioPlayer.shared.EnviromentSong()
    }
    
    private func setupScene() {
        scene?.anchorPoint = .zero
        scene?.size = CGSize(width: view?.scene?.size.width ?? 600, height: view?.scene?.size.height ?? 800)
    }
    
    private func setupBackground() {
        backgroundController.setupBackground(scene: self, imageName: assets.backgroundCredits)
    }
    
    private func photo() {
        let buttonTexture = SKTexture(imageNamed: "Photo")
        
        let buttonSprite = SKSpriteNode(texture: buttonTexture)
        let buttonSize = CGSize(width: 690, height: 350)
        buttonSprite.size = buttonSize
    
        buttonSprite.position = CGPoint(x: size.width / 2 , y: size.height - size.height / 3.17)
        addChild(buttonSprite)
    
    }
    
    
    private func teamPhoto() {
        let buttonTexture = SKTexture(imageNamed: "ImageTeam")
        
        let buttonSprite = SKSpriteNode(texture: buttonTexture)
        let buttonSize = CGSize(width: 690, height: 400)
        buttonSprite.size = buttonSize
    
        buttonSprite.position = CGPoint(x: size.width / 2 , y: size.height - size.height / 3.7)
        addChild(buttonSprite)
    
    }
    
    
    private func team() {
        let buttonTexture = SKTexture(imageNamed: "Group")
        
        let buttonSprite = SKSpriteNode(texture: buttonTexture)
        let buttonSize = CGSize(width: 690, height: 320)
        buttonSprite.size = buttonSize
    
        buttonSprite.position = CGPoint(x: size.width / 2 , y: size.height - size.height / 1.53)
        addChild(buttonSprite)
    }
    
    
    private func exit() {
        let buttonTexture = SKTexture(imageNamed: "Sair")
        let button = SKButtonNode(texture: buttonTexture)
        
        
       // let buttonSprite = SKSpriteNode(texture: buttonTexture)
        let buttonSize = CGSize(width: 340, height: 100)
        button.size = buttonSize
    
        button.position = CGPoint(x: size.width / 2 , y: size.height - size.height / 1.15)
        button.name = "Sair"
        addChild(button)
        
        button.setButtonAction {
            print("Botão foi tocado!")
            
            if let view = self.view {
                self.transactionScene.goToNextLevel(view: view, gameScene: "MenuGameScene")
            }
        }
        
        
    }
    
}
