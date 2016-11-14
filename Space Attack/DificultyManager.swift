//
//  DificultyManager.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 11/1/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Darwin
import SpriteKit

class DificultyManager: AnyObject {
  static let sharedInstance = DificultyManager()
  let cSpeed: CGFloat = 0.99
  var multiplier: CGFloat{
    didSet {
      self.numberOfMultipleSimpleEnemies = max(1, min(5, (Int(self.multiplier) + 9) / 6))
    }
  }
  
  // Asteroid
  let asteroidLauchMinImpulse: CGFloat = 11
  let asteroidLauchMaxImpulse: CGFloat = 30
  let asteroidHorizontalImpulse: CGFloat = 4
  let asteroidTopImpulse: CGFloat = 12
  let asteroidMinImpulse: CGFloat = 2
  let asteroidTimeIntervalMin: CGFloat = 0.1
  let asteroidTimeIntervalMax: CGFloat = 0.3
  let maximumAsteroidInterval: CGFloat = 1.3
  let minimumAsteroidInterval: CGFloat = 0.6
  
  // Enemy
  let enemyTimeIntervalMin: CGFloat = 9
  let enemyTimeIntervalMax: CGFloat = 15
  
  var numberOfMultipleSimpleEnemies = 1
  var countSimpleEnemies = 0
  var nextEnemySpawn:Double = 0
  
  init() {
    multiplier = 1
  }
  
  static func getInstance() -> DificultyManager {
    return sharedInstance
  }
  
  func dificultyForMultiplier(multiplier: CGFloat) -> CGFloat {
    return multiplier / 2 + 1.5 * sin(multiplier / 3)
  }
  
  func speedForMultiplier(multiplier: CGFloat) -> CGFloat {
    return (1 - pow(cSpeed, multiplier))
  }
  
  func intervalForMultiplier(multiplier: CGFloat) -> CGFloat {
    return pow(cSpeed, multiplier)
  }
  
  func getAsteroidSpeed() -> (CGFloat, CGFloat) {
    let speedFactor = speedForMultiplier(multiplier: multiplier)
    let topImpulse = min(Utils.random(asteroidLauchMinImpulse, max: asteroidLauchMaxImpulse) * speedFactor, asteroidTopImpulse)
    let impulse = max(topImpulse, asteroidMinImpulse)
    return (Utils.random(0, max: asteroidHorizontalImpulse) * speedFactor, impulse)
  }
  
  func getNextAsteroidSpawn() -> Double {
    let curTime = CACurrentMediaTime()
    var speedFactor = intervalForMultiplier(multiplier: multiplier)
    speedFactor *= speedFactor
    let maxi = maximumAsteroidInterval * speedFactor + asteroidTimeIntervalMax
    var mini = minimumAsteroidInterval * speedFactor + asteroidTimeIntervalMin
    
    if maxi - mini < 0.8 {
      mini = maxi - 0.8
    }
    
    return Double(Utils.random(mini, max: maxi)) + curTime
  }
  func getNextSimpleEnemySpawn() -> Double {
    return Double(Utils.random(self.enemyTimeIntervalMin, max: self.enemyTimeIntervalMax))
  }
  func trySpamSimpleEnemy(scene:SKScene) {
    let curTime = CACurrentMediaTime()
    if self.nextEnemySpawn < curTime {
      nextEnemySpawn = getNextSimpleEnemySpawn() + curTime
      let enemiesToSpawn = min(self.numberOfMultipleSimpleEnemies,max(1,self.numberOfMultipleSimpleEnemies - countSimpleEnemies + 1));
      for _ in 1...enemiesToSpawn {
        countSimpleEnemies += 1
        scene.addChild(self.spawnSimpleEnemy(scene: scene))
      }
      
    }
  }
  func spawnSimpleEnemy(scene:SKScene) -> SKNode {
    let xPosition = Utils.random(0, max: scene.frame.maxX)
    let enemy = EnemyShip(scene: scene)
    enemy.name = NodeNames.removable
    enemy.position = CGPoint(x: xPosition, y: scene.frame.maxY)
    return enemy
  }
  
}
