//
//  RegularShot.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/18/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class RegularShot: AnyObject, ShotManager {
    var nextLaserSpawn:Double = 0
    var shotInterval = 0.2
    var impulseVector = CGVector(dx: 0, dy: 10)
    func shot(node: SKNode) {
        let curTime = CACurrentMediaTime()
        if (curTime > nextLaserSpawn) {
            nextLaserSpawn = curTime + shotInterval
            let shipLaser = SKSpriteNode.init(imageNamed: Assets.shotBlue)
            shipLaser.position = CGPointMake(0, 0)
            shipLaser.hidden = false
            shipLaser.removeAllActions()
            shipLaser.zPosition = node.zPosition - 1;
            
            shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
            shipLaser.physicsBody?.categoryBitMask = PhysicsCategory.laser
            shipLaser.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
            shipLaser.physicsBody?.collisionBitMask = 0
            shipLaser.physicsBody?.allowsRotation = false
            
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([SKAction.waitForDuration(5), remove])
            node.addChild(shipLaser)
            shipLaser.runAction(seq)
            shipLaser.physicsBody?.applyImpulse(impulseVector)
            
        }
    }
}