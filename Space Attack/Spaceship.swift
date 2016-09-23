//
//  Spaceship.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

enum ShipModes {
    case Shooter
    case Shield
    case Propulsor
}

class Spaceship: SKSpriteNode {
    var OnTrilaser = Bool()
    var nextShipLaser = Int()
    var trilaserTime = Double()
    var ship_Speed = CGFloat()
    var mode:ShipModes = ShipModes.Shooter
    var modeMap:[ShipModes:Mode]
    var shipLasers = []
    let regularShot = RegularShot()
    var specialShot:ShotManager? = nil

    init() {
        modeMap = [ShipModes.Shooter:ShooterMode()]
        let texture = SKTexture(imageNamed: Assets.spaceshipBgspeed)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.xScale = 0.5
        self.yScale = 0.5
        
        var a: CGSize = (self.texture?.size())!
        a.height = a.height * 0.2
        a.width = a.width * 0.2
        self.name = "spaceShip"
        
        self.physicsBody = SKPhysicsBody.init(rectangleOfSize: CGSizeMake(self.frame.size.width * 0.4, self.frame.size.height * 0.85))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.spaceship
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = PhysicsCategory.spaceship | PhysicsCategory.enemy | PhysicsCategory.asteroid | PhysicsCategory.trilaser
        self.physicsBody?.mass = 0.366144
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func applyMovement(direction:CGPoint, reposition:CGPoint -> CGPoint){
        let norm = Utils.norm(abs(direction.x - self.position.x), y: abs(direction.y - self.position.y))
        let time = 0.07 +  0.07*(Double(norm)/Double(max(size.height,size.width)));
        let pointFinal =  reposition(CGPointMake(direction.x, direction.y + self.frame.size.width/2));
        self.runAction(SKAction.moveTo(pointFinal, duration: time))
    }
    
    func doLasers(scene: SKScene) {
        let curTime = CACurrentMediaTime()
        
        if (OnTrilaser && curTime > trilaserTime + 15) {
            OnTrilaser = false
            self.specialShot = nil
        }
        
        if (!OnTrilaser) {
            self.regularShot.shot(self)
        } else {
            specialShot?.shot(self)
        }
    }

}
