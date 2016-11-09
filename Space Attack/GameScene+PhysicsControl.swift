//
//  GameScene+PhysicsControl.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/14/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    
    @objc(didBeginContact:) func didBegin(_ contact: SKPhysicsContact) {
        let cur = CACurrentMediaTime()
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
                
        if ((secondBody.categoryBitMask & PhysicsCategory.asteroid == PhysicsCategory.asteroid) &&
            (firstBody.categoryBitMask & PhysicsCategory.spaceship == PhysicsCategory.spaceship) && (self.lastHit + 1.0 < cur)) {
            self.lastHit = cur
            secondBody.node?.safeRemoveFromParent()
            if self.spaceship.hittedBy(secondBody.node) {            
                self.childNode(withName: String(format: "L%d", arguments: [self.lives - 1]))?.removeFromParent()
                lives -= 1
            }
        } else if (((secondBody.categoryBitMask & PhysicsCategory.laser == PhysicsCategory.laser) &&
            (firstBody.categoryBitMask & PhysicsCategory.asteroid == PhysicsCategory.asteroid))) {
            secondBody.node?.safeRemoveFromParent()
            self.addScore(value: 50)
            if let explodable = firstBody.node as? Explodable {
                explodable.explode(self)
            }
        } else if (((secondBody.categoryBitMask & PhysicsCategory.enemyLaser == PhysicsCategory.enemyLaser) &&
            (firstBody.categoryBitMask & PhysicsCategory.spaceship == PhysicsCategory.spaceship))) {
            secondBody.node?.safeRemoveFromParent()
            self.lastHit = cur
            secondBody.node?.safeRemoveFromParent()
            if self.spaceship.hittedBy(secondBody.node) {
                self.addScore(value: 100)
                self.childNode(withName: String(format: "L%d", arguments: [self.lives - 1]))?.removeFromParent()
                lives -= 1
            }
            
        } else if (((secondBody.categoryBitMask & PhysicsCategory.enemy == PhysicsCategory.enemy) &&
            (firstBody.categoryBitMask & PhysicsCategory.laser == PhysicsCategory.laser))) {
            let node = firstBody.node
            
            if let hitable = secondBody.node as? Hitable {
                _ = hitable.hittedBy(node)
            }
            node?.safeRemoveFromParent()
        }else if ((secondBody.categoryBitMask == PhysicsCategory.trilaser) &&
            (firstBody.categoryBitMask == PhysicsCategory.spaceship)) {
            if let powerUp = secondBody.node as? PowerUp {
                self.spaceship.powerUp(powerUp: powerUp)
            }
            secondBody.node?.safeRemoveFromParent()
        }
    }

}
