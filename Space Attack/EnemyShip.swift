//
//  EnemyShip.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 10/11/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

enum EnemyType {
  case CircularEnemy
  case IrregularEnemy
}

class EnemyShip: SKSpriteNode {
  static let margin: CGFloat = 30
  var shoot: ShotManager
  var movementController: MovementPattern
  var hp: Int
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  static func shipTypeIrregular() -> (SKTexture, ShotManager) {
    let texture = SKTexture(imageNamed: Assets.spaceshipDrakir1)
    let shoot = IrregularCircularShot()
    return (texture,shoot)
  }
  
  static func shipTypeCicurlar() -> (SKTexture, ShotManager) {
    let texture = SKTexture(imageNamed: Assets.spaceshipDrakir6)
    let shoot = CircularShot()
    return (texture, shoot)
  }
  
  static func tupleForType(type:EnemyType) -> (SKTexture, ShotManager) {
    switch type {
    case .CircularEnemy:
        return EnemyShip.shipTypeCicurlar()
    case .IrregularEnemy:
        return EnemyShip.shipTypeIrregular()
    }
  }
  
  init(scene: SKScene, type:EnemyType) {
    let tuple = EnemyShip.tupleForType(type: type)
    let texture = tuple.0
    self.shoot = tuple.1
    shoot.target = PhysicsCategory.spaceship
    shoot.category = PhysicsCategory.enemyLaser
    movementController = SmoothMovement()
    hp = Int(round(Utils.random(4, max: 6)))
    super.init(texture:texture, color:UIColor.clear , size:texture.size())
    
    // setup physics body
    physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2)
    physicsBody?.categoryBitMask = PhysicsCategory.enemy
    physicsBody?.contactTestBitMask = PhysicsCategory.laser
    physicsBody?.collisionBitMask = 0
    physicsBody?.friction = 0
    physicsBody?.linearDamping = 0
    
    xScale = 0.6
    yScale = 0.6
    
    run(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 0))
    zPosition = scene.zPosition + 10
    restrictMovement(toFrame: scene.frame)
    startActionPooling()
    shoot.shootDirection = movementController.currentDirection
  }
  
  func restrictMovement(toFrame frame: CGRect) {
    let xRange = SKRange(lowerLimit: -EnemyShip.margin, upperLimit:frame.size.width + EnemyShip.margin)
    let yRange = SKRange(lowerLimit: -EnemyShip.margin, upperLimit:frame.size.height + EnemyShip.margin)
    constraints = [SKConstraint.positionX(xRange,y:yRange)]
  }
  
  func startActionPooling() {
    let actions = SKAction.run({
      self.shoot.shot(self)
      self.movementController.applyMovement(node: self)
      self.shoot.shootDirection = self.movementController.currentDirection
      let rootNode = Utils.getRootNode(node: self)
      if !rootNode.intersects(self) {
        self.safeRemoveFromParent()
      }
    })
    
    let actionInterval = SKAction.wait(forDuration: 0.1)
    run(SKAction.repeatForever(SKAction.sequence([actions,actionInterval])))
    
  }
}

extension EnemyShip: Hitable {
  func hittedBy(_ node: SKNode?) -> Bool {
    if node == nil {
      return false
    }
    
    hp -= 1
    if hp <= 0 {
      safeRemoveFromParent()
      DificultyManager.sharedInstance.countSimpleEnemies -= 1
    }
    
    return true
  }
}
