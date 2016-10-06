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
    var shotInterval:Double = 0.25
    var impulseVector = CGVector(dx: 0, dy: 10)
    
    init() {}
    init(shotInterval:Double) {
        self.shotInterval = shotInterval
    }
    func shot(_ node: SKNode) {
        let curTime = CACurrentMediaTime()
        if (curTime > nextLaserSpawn) {
            nextLaserSpawn = curTime + shotInterval
            let sceneNode = Utils.getRootNode(node: node)
            let shotPosition = node.convert(CGPoint(x:0,y:0), to: sceneNode)
            let shipLaser = SKSpriteNode.init(imageNamed: Assets.shotBlue)
            shipLaser.position = shotPosition
            shipLaser.isHidden = false
            shipLaser.removeAllActions()
            shipLaser.zPosition = node.zPosition - 1;
            
            shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
            shipLaser.physicsBody?.categoryBitMask = PhysicsCategory.laser
            shipLaser.physicsBody?.contactTestBitMask = PhysicsCategory.asteroid
            shipLaser.physicsBody?.collisionBitMask = 0
            shipLaser.physicsBody?.allowsRotation = false
            
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([SKAction.wait(forDuration: 5), remove])
            
            sceneNode.addChild(shipLaser)
            shipLaser.run(seq)
            shipLaser.physicsBody?.applyImpulse(impulseVector)
        }
    }
}
