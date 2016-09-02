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
    static let asteroidAnimation:SKAction = Asteroid.createAsteroidAnimation()
    
    static func createAsteroidAnimation() -> SKAction {
        let animaAstTexture = [
            SKTexture.init(imageNamed: Assets.rock1),
            SKTexture.init(imageNamed: Assets.rock2),
            SKTexture.init(imageNamed: Assets.rock3),
            SKTexture.init(imageNamed: Assets.rock4),
            SKTexture.init(imageNamed: Assets.rock5),
            SKTexture.init(imageNamed: Assets.rock6),
            SKTexture.init(imageNamed: Assets.rock7),
            SKTexture.init(imageNamed: Assets.rock8),
            SKTexture.init(imageNamed: Assets.rock9),
            SKTexture.init(imageNamed: Assets.rock10),
            SKTexture.init(imageNamed: Assets.rock11),
            SKTexture.init(imageNamed: Assets.rock12),
            SKTexture.init(imageNamed: Assets.rock13),
            SKTexture.init(imageNamed: Assets.rock14),
            SKTexture.init(imageNamed: Assets.rock15)
        ]
        let anima = SKAction.animateWithTextures(animaAstTexture, timePerFrame: 0.025)
        let animaAst = SKAction.repeatActionForever(anima)
        return animaAst
    }
    
    
    init(scene: SKScene) {
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
        self.runAction(Asteroid.asteroidAnimation, withKey: "asteriodAnima")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}