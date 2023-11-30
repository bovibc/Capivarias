//
//  LifeBar.swift
//  Capivarias
//
//  Created by Ricardo de Agostini Neto on 27/11/23.
//

import Foundation
import SpriteKit

class LifeBar: SKNode {
    
    var borderNode: SKSpriteNode
    var barNode: SKSpriteNode
    
    let customColor = UIColor(red: 198/255, green: 62/255, blue: 62/255, alpha: 1.0)
    
    
    
    override init() {
        self.borderNode = SKSpriteNode(imageNamed: "novabarra8")
        self.barNode = SKSpriteNode(imageNamed: "bar")
        super.init()
        setup()
    }
    
    
    required init? (coder aDecoder: NSCoder) {
        self.borderNode = SKSpriteNode(color: .white, size: .init(width: 300, height: 100))
        self.barNode = SKSpriteNode(color: .systemRed, size: .init(width: 300, height: 100))
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        
        addChild(borderNode)
        addChild(barNode)
        
        barNode.zPosition += 99
        barNode.color = SKColor(cgColor: customColor.cgColor)
        barNode.colorBlendFactor = 1
        
        barNode.anchorPoint = .init(x: 0, y: 0.5)
        barNode.position.x = -(barNode.size.width/2) + 105
        barNode.position.y = -(barNode.size.height/2) - 5
    }
    
    public func updateProgress(_ amount: Float) {
        let correctAmount = min(max(0, amount), 1)
        barNode.run(.scaleX(to: CGFloat(correctAmount), duration: 0.3))
        
    }
    
}
