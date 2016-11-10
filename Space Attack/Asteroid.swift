//
//  Asteroid.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class Asteroid: SKSpriteNode {
    static let scale: CGFloat = 0.8
    static let asteroidAnimation: SKAction = Asteroid.createAsteroidAnimation()
    static var nextAsteroidSpawn = Double()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        let texture = SKTexture(imageNamed: Assets.rock1)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        xScale = Asteroid.scale
        yScale = Asteroid.scale
        
        isHidden = false
        zPosition = 10
        
        // setup physics body
        physicsBody = SKPhysicsBody.init(circleOfRadius: frame.size.width / 4)
        physicsBody?.categoryBitMask = PhysicsCategory.asteroid
        physicsBody?.contactTestBitMask = PhysicsCategory.spaceship | PhysicsCategory.laser
        physicsBody?.collisionBitMask = PhysicsCategory.spaceship | PhysicsCategory.asteroid
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0.4
        physicsBody?.friction = 0
        physicsBody?.linearDamping = 0
        physicsBody?.angularDamping = 0
    }
    
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
}

extension Asteroid: Explodable {
    func explode(_ scene: GameScene) {
        let emitterPath = Bundle.main.path(forResource: "explosion", ofType: "sks")
        let emitterNode = NSKeyedUnarchiver.unarchiveObject(withFile: emitterPath!) as? SKEmitterNode
        emitterNode?.position = position
        safeRemoveFromParent()
        if (emitterNode != nil) {
            scene.addChild(emitterNode!)
            emitterNode?.run(Utils.removeAfter(1))
        }
    }
}

extension Asteroid: Lauchable {
    func lauch(scene: SKScene) {
        let posX = CGFloat(Utils.random(0, max: scene.frame.size.width))
        let speedTuple = DificultyManager.sharedInstance.getAsteroidSpeed()
        position = CGPoint(x: posX, y: scene.frame.maxY)
        run(Utils.removeAfter(15))
        run(Asteroid.asteroidAnimation, withKey: "asteriodAnima")
        let horizontalImpulse = position.x > scene.frame.midX ? -speedTuple.0 : speedTuple.0
        physicsBody?.applyImpulse(CGVector(dx: horizontalImpulse, dy: -speedTuple.1))
    }
}
