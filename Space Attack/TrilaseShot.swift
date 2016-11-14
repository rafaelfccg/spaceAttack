//
//  RegularShot.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/18/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class TrilaserShot: AnyObject {
  let lateralStr:CGFloat = 0.5
  
  var nextLaserSpawn = 0.0
  var shotInterval = 0.25
  var target: UInt32 = 0
  var category: UInt32 = 0
  var verticalStr: CGFloat = 10
  var shootDirection: CGVector = CGVector(dx: 0, dy: 1)
}

extension TrilaserShot: ShotManager {
  func shot(_ node: SKNode) {
    let curTime = CACurrentMediaTime()
    if (curTime > nextLaserSpawn && category > 0) {
      nextLaserSpawn = curTime + shotInterval
      let sceneNode = Utils.getRootNode(node: node)
      let shotPosition = node.convert(CGPoint(x: 0, y: 0), to: sceneNode)
      
      var shots = [
        SKSpriteNode.init(imageNamed: Assets.shotBlue),
        SKSpriteNode.init(imageNamed: Assets.shotBlue),
        SKSpriteNode.init(imageNamed: Assets.shotBlue)
      ]
      
      for shipLaser in shots {
        shipLaser.name = "laserShip"
        shipLaser.position = shotPosition
        shipLaser.zPosition = node.zPosition - 1
        shipLaser.isHidden = false
        shipLaser.removeAllActions()
        shipLaser.xScale = BodyScales.laserScale
        shipLaser.yScale = BodyScales.laserScale
        
        //setup physics body
        shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
        shipLaser.physicsBody?.categoryBitMask = category
        shipLaser.physicsBody?.contactTestBitMask = target
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
