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
    var OnTrilaser = Bool()
    var nextShipLaser = Int()
    var trilaserTime = Double()
    var ship_Speed = CGFloat()
    var mode:ShipModes = ShipModes.shooter
    var modeMap:[ShipModes:Mode] = [:]
    let regularShot = RegularShot()
    var specialShot:ShotManager? = nil

    init() {
        let texture = SKTexture(imageNamed: Assets.spaceshipBgspeed)
        
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyMovement(_ direction:CGPoint, reposition:(CGPoint) -> CGPoint){
        let norm = Utils.norm(abs(direction.x - self.position.x), y: abs(direction.y - self.position.y))
        let time = 0.07 +  0.07*(Double(norm)/Double(max(size.height,size.width)));
        let pointFinal =  reposition(CGPoint(x: direction.x, y: direction.y + self.frame.size.width/2));
        self.run(SKAction.move(to: pointFinal, duration: time))
    }
    
    func doLasers(_ scene: SKScene) {
        let curTime = CACurrentMediaTime()
        
        
        if (OnTrilaser && curTime > trilaserTime + 15) {
            OnTrilaser = false
            self.specialShot = nil
        }
        
        if (!OnTrilaser) {
            self.modeMap[self.mode]?.shoot()
        } else {
            self.modeMap[self.mode]?.shoot()
        }
    }

}
