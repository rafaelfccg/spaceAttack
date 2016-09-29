//
//  Asteroid.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class Asteroid: SKSpriteNode, Lauchable, Explodable {
    static var nextAsteroidSpawn = Double()
    static let asteroidAnimation:SKAction = Asteroid.createAsteroidAnimation()
    static let scale:CGFloat = 0.8
    
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
        let anima = SKAction.animate(with: animaAstTexture, timePerFrame: 0.025)
        let animaAst = SKAction.repeatForever(anima)
        return animaAst
    }
    
    
    init(scene: SKScene) {
        let texture = SKTexture(imageNamed: Assets.rock1)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.xScale = Asteroid.scale
        self.yScale = Asteroid.scale
        
        let posX = CGFloat(Utils.random(0, max: Double(scene.frame.size.width)))
        self.position = CGPoint(x: posX, y: scene.frame.maxY)
        self.isHidden = false
        self.zPosition = 10;
        
        // setup physics
        self.physicsBody = SKPhysicsBody.init(circleOfRadius: self.frame.size.width/4)
        self.physicsBody?.categoryBitMask = PhysicsCategory.asteroid
        self.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship | PhysicsCategory.laser
        self.physicsBody?.collisionBitMask = PhysicsCategory.spaceship | PhysicsCategory.asteroid
        self.physicsBody?.allowsRotation = false;
        self.physicsBody?.restitution = 0.4
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func lauch(){
        let speedY = CGFloat(Utils.random(3,max: 9))
        let speedX = CGFloat(Utils.random(-0.8,max: 0.8))
        self.run(Utils.removeAfter(15))
        self.run(Asteroid.asteroidAnimation, withKey: "asteriodAnima")
        self.physicsBody?.applyImpulse(CGVector(dx: speedX, dy: -speedY))
    }
    
    func explode(_ scene:GameScene) {
        let emitterPath = Bundle.main.path(forResource: "explosion", ofType: "sks")
        let emitterNode = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath!) as? SKEmitterNode
        emitterNode?.position = self.position
        self.safeRemoveFromParent()
        if (emitterNode != nil) {
            scene.addChild(emitterNode!)
            emitterNode?.run(Utils.removeAfter(1))
        }
    }
}
