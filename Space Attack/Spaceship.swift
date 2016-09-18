//
//  Spaceship.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/25/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class Spaceship: SKSpriteNode {
    var OnTrilaser = Bool()
    var nextShipLaser = Int()
    var trilaserTime = Double()
    var ship_Speed = CGFloat()
    var shipLasers = []
    let regularShot = RegularShot()
    var specialShot:ShotManager? = nil

    init() {
        let texture = SKTexture(imageNamed: Assets.spaceshipBgspeed)
        super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
        self.xScale = 0.8
        self.yScale = 0.8
        
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
    
    func applyMovement(direction:CGPoint){
        let x = direction.x - self.position.x
        let y = direction.y - self.position.y
        let normT = Utils.norm(x, y: y)
        let thrustVector = CGVectorMake(40 * x / normT, 40 * y / normT)
        self.physicsBody?.applyImpulse(thrustVector)
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
