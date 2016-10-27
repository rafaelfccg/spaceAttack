//
//  IrregularCircularShot.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 10/22/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class IrregularCircularShot: AnyObject, ShotManager {
    var nextLaserSpawn:Double = 0.0
    var shotInterval:Double = 0.5
    static let shotIntervalMax:CGFloat = 0.3
    static let shotIntervalMin:CGFloat = 0.7
    
    var shootDirection:CGVector = CGVector(dx:0, dy:1)
    var maximumRotation:CGFloat = CGFloat(M_PI)/6
    var impulseNorm:CGFloat = 3
    var shotsUntilReload = 3
    
    var target: UInt32 = 0
    var category: UInt32 = 0
    
    init() {}
    func shot(_ node:SKNode){
        let curTime = CACurrentMediaTime()
        if (curTime > nextLaserSpawn && self.category > 0 && self.shotsUntilReload >= 0) {
            self.shotsUntilReload -= 1;
            self.shotInterval = Double(Utils.random(IrregularCircularShot.shotIntervalMin,
                                                    max: IrregularCircularShot.shotIntervalMax))
            nextLaserSpawn = curTime + shotInterval
            let sceneNode = Utils.getRootNode(node: node)
            let shotPosition = node.convert(CGPoint(x:0,y:0), to: sceneNode)
            let shipLaser = SKSpriteNode.init(imageNamed: Assets.shotRed)
            
            shipLaser.xScale = BodyScales.laserScale
            shipLaser.yScale = BodyScales.laserScale
            
            shipLaser.position = shotPosition
            shipLaser.removeAllActions()
            shipLaser.zPosition = node.zPosition - 1;
            shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
            shipLaser.physicsBody?.categoryBitMask = self.category
            shipLaser.physicsBody?.contactTestBitMask = self.target
            shipLaser.physicsBody?.collisionBitMask = 0
            shipLaser.physicsBody?.allowsRotation = false
            
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([SKAction.wait(forDuration: 5), remove])
            let rotation = Utils.random(-self.maximumRotation, max: self.maximumRotation)
            let direction = Utils.rotateVector(vector: self.shootDirection, byAngle: rotation)
            let impulseVector = CGVector(dx: direction.dx * self.impulseNorm,
                                         dy: direction.dy * self.impulseNorm)
            
            sceneNode.addChild(shipLaser)
            shipLaser.run(seq)
            
            shipLaser.physicsBody?.applyImpulse(impulseVector)
        } else {
            self.shotsUntilReload = 10
            nextLaserSpawn = curTime + 3
        }
    }
}
