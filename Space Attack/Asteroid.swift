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
        var asteriod = SKSpriteNode.init(imageNamed: Assets.rocks.rock1)
        asteriod.xScale = 0.8
        asteriod.yScale = 0.8
        asteriod.position = CGPointMake(0, CGRectGetMaxY(scene.frame))
        asteriod.hidden = false
        
        // setup physics
        asteriod.physicsBody = SKPhysicsBody.init(texture: asteriod.texture!, size: (asteriod.texture?.size())!)
        asteriod.physicsBody?.categoryBitMask = Physics.asteroidCategory
        asteriod.physicsBody?.contactTestBitMask = Physics.shipCategory | Physics.laserCategory
        asteriod.physicsBody?.collisionBitMask = Physics.shipCategory
        asteriod.physicsBody?.allowsRotation = false
        
        var remove = SKAction.removeFromParent()
        var seq = SKAction.sequence([SKAction.waitForDuration(15), remove])
        scene.addChild(asteriod)
        asteriod.runAction(seq)
        asteriod.runAction(animation, withKey: "asteriodAnima")
        //asteriod.physicsBody?.applyImpulse(0, )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}