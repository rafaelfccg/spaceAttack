//
//  TrilaserItem.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/14/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class TrilaserItem: SKSpriteNode, Lauchable, PowerUp {
    
    internal func poweUp(_ ship: Spaceship) {
        
    }
    
    static func action()->SKAction{
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([SKAction.wait(forDuration: 15), remove])

        let blink = SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.25),
            SKAction.fadeIn(withDuration: 0.25)
            ])
        let blinkForTime = SKAction.repeat(blink, count: 30)
        
        return SKAction.group([blinkForTime,seq])
    }
    
    init(scene: SKScene) {
        
        let randX = Utils.random(0, max: scene.frame.size.width)
        let texture = SKTexture(imageNamed: Assets.shotRed)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.name = "trilaserItem"
        // setup trilaserItem
        self.position = CGPoint(x: CGFloat(randX),y: scene.frame.maxY)
        self.isHidden = false
        self.xScale = 1.4
        self.yScale = 1.4
        
        // setup trilaserItem physics
        self.physicsBody = SKPhysicsBody.init(circleOfRadius: self.frame.size.width/2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.trilaser
        self.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.allowsRotation = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func lauch() {
        self.run(TrilaserItem.action())
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: -5))
        
    }
}
