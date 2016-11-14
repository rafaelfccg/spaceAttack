//
//  RegularShot.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/18/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class RegularShot: AnyObject {
  var count = 0
  var nextLaserSpawn = 0.0
  var shotInterval = 0.25
  var target: UInt32 = 0
  var category: UInt32 = 0
  var impulseNorm: CGFloat = 10
  var impulseVector = CGVector(dx: 0, dy: 10)
  var shootDirection: CGVector = CGVector(dx:0, dy:1)
  
  init() {}
  
  init(shotInterval: Double) {
    self.shotInterval = shotInterval
  }
}

extension RegularShot: ShotManager {
  func shot(_ node: SKNode) {
    let curTime = CACurrentMediaTime()
    if (curTime > nextLaserSpawn) {
      nextLaserSpawn = curTime + shotInterval
      let sceneNode = Utils.getRootNode(node: node)
      let shotPosition = node.convert(CGPoint(x: 0, y: 0), to: sceneNode)
      let shipLaser = SKSpriteNode.init(imageNamed: Assets.shotBlue)
      
      shipLaser.position = shotPosition
      shipLaser.isHidden = false
      shipLaser.removeAllActions()
      shipLaser.zPosition = node.zPosition - 1
      shipLaser.xScale = BodyScales.laserScale
      shipLaser.yScale = BodyScales.laserScale
      
      //set physics body
      shipLaser.physicsBody = SKPhysicsBody.init(texture: shipLaser.texture!, size: (shipLaser.texture?.size())!)
      shipLaser.physicsBody?.categoryBitMask = category
      shipLaser.physicsBody?.contactTestBitMask = target
      shipLaser.physicsBody?.collisionBitMask = 0
      shipLaser.physicsBody?.allowsRotation = false
      
      let remove = SKAction.removeFromParent()
      let seq = SKAction.sequence([SKAction.wait(forDuration: 5), remove])
      shipLaser.name = "\(count)"
      count += 1
      sceneNode.addChild(shipLaser)
      shipLaser.run(seq)
      impulseVector = CGVector(dx: shootDirection.dx * impulseNorm, dy: shootDirection.dy * impulseNorm)
      shipLaser.physicsBody?.applyImpulse(impulseVector)
    }
  }
}
