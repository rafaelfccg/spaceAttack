//
//  PropulsiveMode.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/23/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class PropulsiveMode: AnyObject {
  let speed = 0.3
  let powerUpSpeed = 0.6
  let powerUpTime: UInt64 = 15
  let speedParticle: SKEmitterNode? = SKEmitterNode(fileNamed: "SpeedBoost")
  
  var isPowerUped = false
  var spaceship: Spaceship
  var propulsiveShot: ShotManager
  
  init(spaceship: Spaceship) {
    self.spaceship = spaceship
    propulsiveShot = RegularShot(shotInterval: 0.5)
    propulsiveShot.target = PhysicsCategory.asteroid | PhysicsCategory.enemy
    propulsiveShot.category = PhysicsCategory.laser
  }
}

extension PropulsiveMode: Mode {
  func shoot() {
    propulsiveShot.shot(spaceship)
  }
  
  func hit() -> Bool {
    return true
  }
  
  func powerUp() {
    isPowerUped = true
    let delayTime = DispatchTime.init(uptimeNanoseconds: powerUpTime * NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: delayTime) {
      self.isPowerUped = false
    }
  }
  
  func getSpeedBonus() -> Double {
    if isPowerUped {
      return powerUpSpeed
    } else {
      return speed
    }
  }
  
  func activate() {
    let rootNode = Utils.getRootNode(node: spaceship)
    rootNode.addChild(speedParticle!)
    speedParticle?.position = CGPoint(x: rootNode.frame.midX, y: rootNode.frame.minY)
    speedParticle?.zPosition = 1;
  }
  
  func deactivate() -> Bool {
    speedParticle?.removeFromParent()
    return true
  }
  func reset() {
   isPowerUped = false
  }
}
