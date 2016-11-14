//
//  Spaceship.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

enum ShipModes {
  case shooter
  case shield
  case propulsor
}

class Spaceship: SKSpriteNode {
  private var speedMultiplier = 1.0
  private var lastSpeedBonus: TimeInterval = 0
  private let speedBonusInterval: TimeInterval = 1
  let hitMinimumInterval = 0.2
  
  var mode = ShipModes.shooter
  var specialShot: ShotManager? = nil
  var lastInterval:Double = 0
  
  private var modeMap: [ShipModes: Mode] = [:]
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  init() {
    let texture = SKTexture(imageNamed: Assets.spaceshipBgspeed2)
    super.init(texture: texture, color: UIColor.clear, size: texture.size())
    
    xScale = 0.5
    yScale = 0.5
    var a: CGSize = (texture.size())
    a.height = a.height * 0.2
    a.width = a.width * 0.2
    name = "spaceship"
    
    // setup physics body
    physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width: frame.size.width * 0.4, height: frame.size.height * 0.85))
    physicsBody?.affectedByGravity = false
    physicsBody?.allowsRotation = false
    physicsBody?.categoryBitMask = PhysicsCategory.spaceship
    physicsBody?.collisionBitMask = 0
    physicsBody?.mass = 0.366144
    physicsBody?.contactTestBitMask =
      PhysicsCategory.spaceship |
      PhysicsCategory.enemy |
      PhysicsCategory.asteroid |
      PhysicsCategory.trilaser
    
    modeMap = [
      ShipModes.shooter: ShooterMode(spaceship: self),
      ShipModes.propulsor: PropulsiveMode(spaceship: self),
      ShipModes.shield: ShieldMode(spaceship: self)
    ]
  }
  
  func restrictMovement(toFrame frame: CGRect) {
    let xRange = SKRange(lowerLimit: 0, upperLimit: frame.size.width)
    let yRange = SKRange(lowerLimit: frame.size.height * 0.1, upperLimit: frame.size.height + 400)
    constraints = [SKConstraint.positionX(xRange, y: yRange)]
  }
  
  func applyMovement(_ direction:CGPoint, reposition: (CGPoint) -> CGPoint) {
    let norm = Utils.norm(abs(direction.x - position.x), y: abs(direction.y - position.y))
    let time = 0.05 + 0.05 * (Double(norm) / Double(max(size.height,size.width)))
    let pointFinal =  reposition(CGPoint(x: direction.x, y: direction.y + frame.size.width / 2))
    run(SKAction.move(to: pointFinal, duration: time))
  }
  
  func doLasers() {
    getMode().shoot()
  }
  
  func getMode() -> Mode {
    return modeMap[mode]!
  }
  
  func setMode(mode: ShipModes) -> Bool? {
    let deactivated = modeMap[self.mode]?.deactivate()
    if deactivated! {
      self.mode = mode
      modeMap[mode]?.activate()
    }
    
    return deactivated
  }
  
  func powerUp(powerUp: PowerUp) {
    getMode().powerUp()
  }
  
  func getSpeed() -> Int {
    let curTime = CACurrentMediaTime()
    if lastSpeedBonus + speedBonusInterval < curTime {
      lastSpeedBonus = curTime
      speedMultiplier += getMode().getSpeedBonus()
    }
    
    return Int(floor(speedMultiplier))
  }
  func reset(){
    self.speedMultiplier = 1
    for mode in self.modeMap.values {
      mode.reset()
    }
  }
}

extension Spaceship: Hitable {
  func hittedBy(_ node: SKNode?) -> Bool {
    let curr = CACurrentMediaTime()
    if curr >= lastInterval {
      let hitted = getMode().hit()

      if hitted {
        let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.fadeIn(withDuration: 0.1)])
        let blinkForTime = SKAction.repeat(blink, count: 5)
        run(blinkForTime)
      }
    
      return hitted
    }
    return false
  }
}
