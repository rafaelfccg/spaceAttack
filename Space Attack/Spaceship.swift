//
//  Spaceship.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit
import Darwin

enum ShipModes {
    case shooter
    case shield
    case propulsor
}

class Spaceship: SKSpriteNode,Hitable {
    var mode:ShipModes = ShipModes.propulsor
    private var modeMap:[ShipModes:Mode] = [:]
    var specialShot:ShotManager? = nil
    private var speedMultiplier:Double = 1
    private var lastSpeedBonus:TimeInterval = 0
    private let speedBonusInterval:TimeInterval = 1

    init() {
        let texture = SKTexture(imageNamed: Assets.spaceshipBgspeed2)
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        self.xScale = 0.5
        self.yScale = 0.5
        var a: CGSize = (self.texture?.size())!
        a.height = a.height * 0.2
        a.width = a.width * 0.2
        self.name = "spaceShip"
        
        self.physicsBody = SKPhysicsBody.init(rectangleOf: CGSize(width: self.frame.size.width * 0.4, height: self.frame.size.height * 0.85))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.spaceship
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship | PhysicsCategory.enemy | PhysicsCategory.asteroid | PhysicsCategory.trilaser
        self.physicsBody?.mass = 0.366144
        self.modeMap = [ShipModes.shooter:ShooterMode(spaceship: self),
                        ShipModes.propulsor:PropulsiveMode(spaceship: self),
                        ShipModes.shield:ShieldMode(spaceship: self)]
    }

    func restrictMovement(toFrame frame:CGRect) {
        let xRange = SKRange(lowerLimit: 0, upperLimit:frame.size.width)
        let yRange = SKRange(lowerLimit: frame.size.height * 0.1, upperLimit:frame.size.height + 400)
        self.constraints = [SKConstraint.positionX(xRange,y:yRange)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyMovement(_ direction:CGPoint, reposition:(CGPoint) -> CGPoint){
        let norm = Utils.norm(abs(direction.x - self.position.x), y: abs(direction.y - self.position.y))
        let time = 0.05 +  0.05*(Double(norm)/Double(max(size.height,size.width)));
        let pointFinal =  reposition(CGPoint(x: direction.x, y: direction.y + self.frame.size.width/2));
        self.run(SKAction.move(to: pointFinal, duration: time))
    }
    
    func doLasers() {
        self.getMode().shoot()
    }
    
    func getMode()->Mode{
        return modeMap[self.mode]!
    }
    
    func setMode(mode:ShipModes) -> Bool?{
        let deactivated = self.modeMap[self.mode]?.deactivate()
        if deactivated! {
            self.mode = mode;
            self.modeMap[mode]?.activate()
        }
        return deactivated
    }
    
    func powerUp(powerUp:PowerUp) {
        self.getMode().powerUp()
    }
    
    func hittedBy(_ node: SKNode?)->Bool {
        let hitted = self.getMode().hit()
        if(hitted){
            let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.fadeIn(withDuration: 0.1)])
            let blinkForTime = SKAction.repeat(blink, count: 5)
            self.run(blinkForTime)
        }
        return hitted
    }
    
    func getSpeed() -> Int {
        let curTime = CACurrentMediaTime()
        if lastSpeedBonus + speedBonusInterval < curTime {
            self.lastSpeedBonus = curTime
            self.speedMultiplier += self.getMode().getSpeedBonus()   
        }
        return Int(floor(self.speedMultiplier))
    }
}
