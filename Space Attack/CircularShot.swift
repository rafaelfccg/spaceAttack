//
//  CircularShot.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 11/27/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class CircularShot: AnyObject {
  let reloadNumberOfShoots = 4
  let shotInterval = 0.15
  
  var nextLaserSpawn = 0.0
  var target: UInt32 = 0
  var category: UInt32 = 0
  var verticalStr: CGFloat = 3
  var shootDirection: CGVector = CGVector(dx: 0, dy: 1)
  var numberOfShots = 10
  var shotsUntilReload = 4
		
}

extension CircularShot : ShotManager {
  
  func shot(_ node: SKNode) {
    let curTime = CACurrentMediaTime()
    
    if shotsUntilReload <= 0 {
      shotsUntilReload = reloadNumberOfShoots
      nextLaserSpawn = curTime + 5
    }
    
    if (curTime < nextLaserSpawn || self.category <= 0) {
      return;
    }
    let sceneNode = Utils.getRootNode(node: node)
    let shotPosition = node.convert(CGPoint(x: 0, y: 0), to: sceneNode)
    
    nextLaserSpawn = curTime + shotInterval
    shotsUntilReload -= 1
    
    var shots:[SKNode] = []
    var directions:[CGVector] = []
    let angleBetwenShots:CGFloat = 2 * CGFloat(M_PI)/CGFloat(numberOfShots)
    
    
    for i in 0...numberOfShots {
      let shot = SKSpriteNode.init(imageNamed: Assets.shotRed)
      shot.xScale = BodyScales.laserScale
      shot.yScale = BodyScales.laserScale
      shot.zPosition = node.zPosition - 1;
      
      // setup physics body
      shot.physicsBody = SKPhysicsBody.init(texture: shot.texture!, size: (shot.texture?.size())!)
      shot.physicsBody?.categoryBitMask = self.category
      shot.physicsBody?.contactTestBitMask = self.target
      shot.physicsBody?.collisionBitMask = 0
      shot.physicsBody?.allowsRotation = false
      shot.physicsBody?.linearDamping = 0
      
      shot.position = shotPosition
      shot.run(Utils.removeAfter(7))  
      
      let impulseDirection = Utils.rotateVector(vector: shootDirection, byAngle: (angleBetwenShots * CGFloat(i)))
      
      directions.append(impulseDirection)
      shots.append(shot)
    }
    
    for (idx, shot) in shots.enumerated() {
      sceneNode.addChild(shot)
      shot.physicsBody?.applyImpulse(Utils.scaleVector(vector: directions[idx], byScale: verticalStr))
    }
  }
}
