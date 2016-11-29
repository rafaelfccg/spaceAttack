//
//  ShieldMode.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/23/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class ShieldMode: AnyObject {
  let powerUpTime = 20.0
  let regenerationTime = 18.0
  let shieldStartHp = 3
  
  var isActive = false
  var shieldHP = 0
  var powerUpHP = 0
  var spaceship: Spaceship
  var shieldShot: ShotManager
  var shieldNode: SKShapeNode
  
  init(spaceship: Spaceship) {
    self.spaceship = spaceship
    shieldNode = SKShapeNode(circleOfRadius: spaceship.size.width)
    shieldNode.fillColor = SKColor(colorLiteralRed: 0.1, green: 0.15, blue: 0.9, alpha: 0.4)
    shieldNode.zPosition = spaceship.zPosition + 1
    shieldShot = RegularShot(shotInterval: 0.8)
    shieldShot.target = PhysicsCategory.asteroid | PhysicsCategory.enemy
    shieldShot.category = PhysicsCategory.laser
    shieldHP = shieldStartHp
  }
}

extension ShieldMode: Mode {
  func activate() {
    spaceship.addChild(shieldNode)
    isActive = true
  }
  
  internal func deactivate() -> Bool {
    if self.shieldHP <= 0 {
      return false
    } else {
      shieldNode.removeFromParent()
      isActive = false
      return true
    }
  }
  
  func shoot() {
    shieldShot.shot(spaceship)
  }
  
  func hit() -> Bool {
    if self.powerUpHP > 0 {
      powerUpHP -= 1
      return false
    }
    
    if self.shieldHP <= 0 {
      return true
    }
    
    shieldHP -= 1
    
    DispatchQueue.main.asyncAfter(deadline: .now() + regenerationTime) {
      if (self.shieldHP < 3) {
        self.shieldHP += 1
      }
      
      if self.isActive && self.shieldNode.parent == nil {
        self.spaceship.addChild(self.shieldNode)
      }
    }
    
    if shieldHP <= 0 {
      shieldNode.removeFromParent()
    }
    
    return false
  }
  
  func powerUp() {
    powerUpHP += 3
    DispatchQueue.main.asyncAfter(deadline: .now() + self.powerUpTime) {
      self.powerUpHP = 0
    }
  }
  
  func getSpeedBonus() -> Double {
    return 0.08
  }
  func reset() {
    shieldHP = shieldStartHp
    powerUpHP = 0
  }
}
