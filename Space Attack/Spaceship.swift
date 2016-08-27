//
//  Spaceship.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class Spaceship: SKSpriteNode {
    var OnTrilaser = Bool()
    var nextShipLaser = Int()
    var trilaserTime = Double()
    var nextLaserSpawn = Double()
    var ship_Speed = CGFloat()
    var shipLasers = []
    
    init() {
        super.init(imageNamed: Assets.spaceship)
        self.xScale = 0.8
        self.yScale = 0.8
        
        var a: CGSize = (self.texture?.size())!
        a.height = a.height * 0.2
        a.width = a.width * 0.2
        
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = Physics.shipCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = Physics.shipCategory | Physics.eshipCategory | Physics.asteroidCategory | Physics.itemTrilaser
        self.physicsBody?.mass = 0.366144
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func doLasers(scene: SKScene) {
        let curTime = CACurrentMediaTime()
        
        if (curTime > trilaserTime + 15) {
            OnTrilaser = true
        }
        
        if (!OnTrilaser && curTime > nextLaserSpawn) {
            nextLaserSpawn = curTime + 0.2
            
            let shipLaser = SKSpriteNode.init(imageNamed: Assets.blueShot)
            shipLaser.position = CGPointMake(self.position.x, shipLaser.size.height / 2 + self.position.y)
            shipLaser.hidden = false
            shipLaser.removeAllActions()
            
            shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
            shipLaser.physicsBody?.categoryBitMask = Physics.laserCategory
            shipLaser.physicsBody?.contactTestBitMask = Physics.asteroidCategory
            shipLaser.physicsBody?.collisionBitMask = 0
            shipLaser.physicsBody?.allowsRotation = false
            
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([SKAction.waitForDuration(5), remove])
            self.scene?.addChild(shipLaser)
            shipLaser.runAction(seq)
            shipLaser.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 10))
        } else if (curTime > nextLaserSpawn) {
            nextLaserSpawn = curTime + 0.15
            
            let shot = SKSpriteNode.init(imageNamed: Assets.redShot)
            var shots = [SKSpriteNode](count: 3, repeatedValue: shot)
            
            for shipLaser in shots {
                shipLaser.position = CGPointMake(self.position.x, shipLaser.size.height/2+self.position.y)
                shipLaser.hidden = false
                shipLaser.removeAllActions()
                
                shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
                shipLaser.physicsBody?.categoryBitMask = Physics.laserCategory
                shipLaser.physicsBody?.contactTestBitMask = Physics.asteroidCategory
                shipLaser.physicsBody?.collisionBitMask = 0
                shipLaser.physicsBody?.allowsRotation = false
                
                let remove = SKAction.removeFromParent()
                let seq = SKAction.sequence([SKAction.waitForDuration(5), remove])
                self.scene?.addChild(shipLaser)
                shipLaser.runAction(seq)
                
                shots[0].physicsBody?.applyImpulse(CGVectorMake(1, 10))
                shots[1].physicsBody?.applyImpulse(CGVectorMake(0, 10))
                shots[2].physicsBody?.applyImpulse(CGVectorMake(-1, 10))
            }
        }
    }
    
    func setPhysicsBodyContent() {
        
    }
}
