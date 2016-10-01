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
    var shotInterval = 0.25
    var verticalStr:CGFloat = 10
    let lateralStr:CGFloat = 0.5
    func shot(_ node: SKNode) {
        let curTime = CACurrentMediaTime()
        if (curTime > nextLaserSpawn) {
            nextLaserSpawn = curTime + shotInterval
            let sceneNode = Utils.getRootNode(node: node)
            let shotPosition = node.convert(CGPoint(x:0,y:0), to: sceneNode)
            
            var shots = [SKSpriteNode.init(imageNamed: Assets.shotRed),
                         SKSpriteNode.init(imageNamed: Assets.shotRed),
                         SKSpriteNode.init(imageNamed: Assets.shotRed)]
            
            for shipLaser in shots {
                shipLaser.name = "laserShip"
                shipLaser.position = shotPosition
                shipLaser.zPosition = node.zPosition - 1;
                shipLaser.isHidden = false
                shipLaser.removeAllActions()
                
                shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
                shipLaser.physicsBody?.categoryBitMask = PhysicsCategory.laser
                shipLaser.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
                shipLaser.physicsBody?.collisionBitMask = 0
                shipLaser.physicsBody?.allowsRotation = false
                
                let remove = SKAction.removeFromParent()
                let seq = SKAction.sequence([SKAction.wait(forDuration: 5), remove])
                sceneNode.addChild(shipLaser)
                shipLaser.run(seq)
            }
            shots[0].physicsBody?.applyImpulse(CGVector(dx: lateralStr, dy: verticalStr))
            shots[1].physicsBody?.applyImpulse(CGVector(dx: 0, dy: verticalStr))
            shots[2].physicsBody?.applyImpulse(CGVector(dx: -lateralStr, dy: verticalStr))
        }
    }
}
