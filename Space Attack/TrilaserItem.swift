//
//  TrilaserItem.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/14/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class TrilaserItem: SKSpriteNode {
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init(scene: SKScene) {
    let texture = SKTexture(imageNamed: Assets.shotBlue)
    super.init(texture: texture, color: UIColor.clear, size: texture.size())
    
    let randX = Utils.random(0, max: scene.frame.size.width)
    position = CGPoint(x: CGFloat(randX),y: scene.frame.maxY)
    name = "trilaserItem"
    isHidden = false
    xScale = 1.4
    yScale = 1.4
    
    // setup physics body
    physicsBody = SKPhysicsBody.init(circleOfRadius: frame.size.width / 2)
    physicsBody?.categoryBitMask = PhysicsCategory.trilaser
    physicsBody?.contactTestBitMask = PhysicsCategory.spaceship
    physicsBody?.collisionBitMask = 0
    physicsBody?.allowsRotation = false
  }
  
  static func action() -> SKAction {
    let remove = SKAction.removeFromParent()
    let seq = SKAction.sequence([SKAction.wait(forDuration: 15), remove])
    
    let blink = SKAction.sequence([
      SKAction.fadeOut(withDuration: 0.25),
      SKAction.fadeIn(withDuration: 0.25)
      ])
    
    let blinkForTime = SKAction.repeat(blink, count: 30)
    return SKAction.group([blinkForTime, seq])
  }
}

extension TrilaserItem: Lauchable {
  func lauch(scene: SKScene) {
    run(TrilaserItem.action())
    physicsBody?.applyImpulse(CGVector(dx: 0, dy: -5))
  }
}

// TODO: remove later!
extension TrilaserItem: PowerUp {
  func poweUp(_ ship: Spaceship) {}
}
