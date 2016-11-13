//
//  EnemyShip.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 10/11/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import SpriteKit

class EnemyShip: SKSpriteNode {
    var shoot:ShotManager
    var movementController:MovementPattern
    var hp:Int
    static let margin:CGFloat = 30
    
    init(scene:SKScene) {
        let texture = SKTexture(imageNamed: Assets.spaceshipDrakir1)
        shoot = IrregularCircularShot()
        shoot.target = PhysicsCategory.spaceship
        shoot.category = PhysicsCategory.enemyLaser
        movementController = SmoothMovement()
        hp = Int(round(Utils.random(3, max: 5)))
        super.init(texture:texture, color:UIColor.clear , size:texture.size())
        self.physicsBody = SKPhysicsBody(circleOfRadius: texture.size().width/2)
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.laser
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.friction = 0
        self.physicsBody?.linearDamping = 0
        
        self.xScale = 0.6
        self.yScale = 0.6
        
        self.run(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 0))
        self.zPosition = scene.zPosition + 10
        restrictMovement(toFrame: scene.frame)
        self.startActionPooling()
        shoot.shootDirection = self.movementController.currentDirection
    }
    
    func restrictMovement(toFrame frame:CGRect) {
        let xRange = SKRange(lowerLimit: -EnemyShip.margin, upperLimit:frame.size.width + EnemyShip.margin)
        let yRange = SKRange(lowerLimit: -EnemyShip.margin, upperLimit:frame.size.height + EnemyShip.margin)
        self.constraints = [SKConstraint.positionX(xRange,y:yRange)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.run(SKAction.repeatForever(SKAction.sequence([actions,actionInterval])))
        
    }
}

extension EnemyShip: Hitable {
    func hittedBy(_ node: SKNode?) -> Bool {
        if (node == nil) {
            return false
        }
        
        hp -= 1
        if hp <= 0 {
            safeRemoveFromParent()
        }
        
        return true
    }
}
