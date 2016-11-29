//
//  DificultyManager.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 11/1/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Darwin
import SpriteKit
import GameplayKit

class DificultyManager: AnyObject {
  static let sharedInstance = DificultyManager()
  let cSpeed: CGFloat = 0.99
  var multiplier: CGFloat{
    didSet {
      self.numberOfMultipleSimpleEnemies = max(1, min(6, (Int(self.multiplier) + 7) / 5))
    }
  }
  
  // Asteroid
  let asteroidLauchMinImpulse: CGFloat = 11
  let asteroidLauchMaxImpulse: CGFloat = 35
  let asteroidHorizontalImpulse: CGFloat = 3
  let asteroidTopImpulse: CGFloat = 12
  let asteroidMinImpulse: CGFloat = 2
  let asteroidTimeIntervalMin: CGFloat = 0.1
  let asteroidTimeIntervalMax: CGFloat = 0.3
  let maximumAsteroidInterval: CGFloat = 1.2
  let minimumAsteroidInterval: CGFloat = 0.5
  
  // Enemy
  let enemyTimeIntervalMin: CGFloat = 8
  let enemyTimeIntervalMax: CGFloat = 15
  let circularProbability:CGFloat = 0.6
  
  var numberOfMultipleSimpleEnemies = 1
  var countSimpleEnemies = 0
  var nextEnemySpawn:Double = 0
  
  init() {
    multiplier = 1
    nextEnemySpawn = CACurrentMediaTime() + 1;
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
    let speedFactor = max(speedForMultiplier(multiplier: multiplier),0.05)
    let topImpulse = min(Utils.random(asteroidLauchMinImpulse, max: asteroidLauchMaxImpulse) * speedFactor, asteroidTopImpulse)
    let impulse = topImpulse + asteroidMinImpulse
    let random = GKRandomSource()
    let gaussian = GKGaussianDistribution(randomSource: random, mean: 0, deviation: 100)
    // Roll the dice...
    let value = CGFloat(gaussian.nextInt())/100
    return (fabs(value), impulse)
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
      let enemiesToSpawn = min(self.numberOfMultipleSimpleEnemies, max(1,self.numberOfMultipleSimpleEnemies - countSimpleEnemies + 1));
      for _ in 1...enemiesToSpawn {
        countSimpleEnemies += 1
        scene.addChild(self.spawnSimpleEnemy(scene: scene))
      }
      
    }
  }
  
  func chooseEnemyType() -> EnemyType {
    let rand = Utils.random(0, max: 1)
    if rand > circularProbability {
      return EnemyType.IrregularEnemy
    } else {
      return EnemyType.CircularEnemy
    }
  }
  
  func spawnSimpleEnemy(scene:SKScene) -> SKNode {
    
    let enemyType = chooseEnemyType()
    let xPosition = Utils.random(0, max: scene.frame.maxX)
    let enemy = EnemyShip(scene: scene, type:enemyType)
    enemy.name = NodeNames.removable
    enemy.position = CGPoint(x: xPosition, y: scene.frame.maxY)
    return enemy
  }
  
}
