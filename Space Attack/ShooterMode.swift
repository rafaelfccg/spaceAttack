//
//  ShooterMode.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/23/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation

class ShooterMode: AnyObject {
  let powerUpTime = 15.0
  let speed = 0.075
  
  var isPowerUped = false
  var spaceship: Spaceship
  var regularShot: ShotManager
  var powerUpShoot: ShotManager
  
  init(spaceship: Spaceship) {
    self.spaceship = spaceship
    regularShot = RegularShot()
    powerUpShoot = TrilaserShot()
    powerUpShoot.target = PhysicsCategory.asteroid | PhysicsCategory.enemy
    powerUpShoot.category = PhysicsCategory.laser
    regularShot.target = PhysicsCategory.asteroid | PhysicsCategory.enemy
    regularShot.category = PhysicsCategory.laser
  }
}

extension ShooterMode: Mode {
  func shoot() {
    if isPowerUped {
      powerUpShoot.shot(spaceship)
    } else {
      regularShot.shot(spaceship)
    }
  }
  
  func activate() {}
  
  func deactivate() -> Bool {
    return true
  }
  
  func hit() -> Bool {
    return true
  }
  
  func powerUp() {
    isPowerUped = true
    DispatchQueue.main.asyncAfter(deadline: .now() + self.powerUpTime) {
      self.isPowerUped = false
    }
  }
  
  func getSpeedBonus() -> Double {
    return speed
  }
  func reset(){
    isPowerUped = false
  }
}
