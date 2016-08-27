//
//  Asteroid.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class Asteroid: SKSpriteNode {
    static var nextAsteroidSpawn = Double()
    
    init(scene: SKScene, animation: SKAction) {
        let texture = SKTexture(imageNamed: Assets.rock1)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())

        self.xScale = 0.8
        self.yScale = 0.8
        self.position = CGPointMake(0, CGRectGetMaxY(scene.frame))
        self.hidden = false
        
        // setup physics
        self.physicsBody = SKPhysicsBody.init(texture: self.texture!, size: (self.texture?.size())!)
        self.physicsBody?.categoryBitMask = PhysicsCategory.asteroid
        self.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship | PhysicsCategory.laser
        self.physicsBody?.collisionBitMask = PhysicsCategory.spaceship
        self.physicsBody?.allowsRotation = false
        
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([SKAction.waitForDuration(15), remove])
        scene.addChild(self)
        self.runAction(seq)
        self.runAction(animation, withKey: "asteriodAnima")
        //asteriod.physicsBody?.applyImpulse(0, )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}