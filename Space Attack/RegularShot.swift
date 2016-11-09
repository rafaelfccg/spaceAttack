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
    var impulseNorm:CGFloat = 10
    var impulseVector = CGVector(dx: 0, dy: 10)
    var shootDirection:CGVector = CGVector(dx:0, dy:1)
    var target: UInt32 = 0
    var category: UInt32 = 0
    
    var count = 0
    
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
            shipLaser.zPosition = node.zPosition - 1
            shipLaser.xScale = BodyScales.laserScale
            shipLaser.yScale = BodyScales.laserScale
            shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
            shipLaser.physicsBody?.categoryBitMask = self.category
            shipLaser.physicsBody?.contactTestBitMask = self.target
            shipLaser.physicsBody?.collisionBitMask = 0
            shipLaser.physicsBody?.allowsRotation = false
            
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([SKAction.wait(forDuration: 5), remove])
            shipLaser.name = "\(count)"
            count+=1
            sceneNode.addChild(shipLaser)
            shipLaser.run(seq)
            self.impulseVector = CGVector(dx: self.shootDirection.dx * self.impulseNorm,
                                          dy: self.shootDirection.dy * self.impulseNorm)
            shipLaser.physicsBody?.applyImpulse(self.impulseVector)
        }
    }
}
