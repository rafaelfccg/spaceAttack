//
//  RegularShot.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/18/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class TrilaserShot: AnyObject, ShotManager {
    var nextLaserSpawn:Double = 0
    var shotInterval = 0.2
    var verticalStr:CGFloat = 10
    let lateralStr:CGFloat = 0.5
    func shot(node: SKNode) {
        let curTime = CACurrentMediaTime()
        if (curTime > nextLaserSpawn) {
            nextLaserSpawn = curTime + shotInterval
            var shots = [SKSpriteNode.init(imageNamed: Assets.shotRed),
                         SKSpriteNode.init(imageNamed: Assets.shotRed),
                         SKSpriteNode.init(imageNamed: Assets.shotRed)]
            
            for shipLaser in shots {
                shipLaser.name = "laserShip"
                shipLaser.position = CGPointMake(0, 0)
                shipLaser.zPosition = node.zPosition - 1;
                shipLaser.hidden = false
                shipLaser.removeAllActions()
                
                shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
                shipLaser.physicsBody?.categoryBitMask = PhysicsCategory.laser
                shipLaser.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
                shipLaser.physicsBody?.collisionBitMask = 0
                shipLaser.physicsBody?.allowsRotation = false
                
                let remove = SKAction.removeFromParent()
                let seq = SKAction.sequence([SKAction.waitForDuration(5), remove])
                node.addChild(shipLaser)
                shipLaser.runAction(seq)
            }
            shots[0].physicsBody?.applyImpulse(CGVectorMake(lateralStr, verticalStr))
            shots[1].physicsBody?.applyImpulse(CGVectorMake(0, verticalStr))
            shots[2].physicsBody?.applyImpulse(CGVectorMake(-lateralStr, verticalStr))
        }
    }
}