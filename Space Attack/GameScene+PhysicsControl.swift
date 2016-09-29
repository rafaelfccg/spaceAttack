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
            (firstBody.categoryBitMask & PhysicsCategory.spaceship == PhysicsCategory.spaceship) && (last_hit + 1.0 < cur)) {
            last_hit = cur
            secondBody.node?.safeRemoveFromParent()
            let blink = SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.fadeIn(withDuration: 0.1)])
            let blinkForTime = SKAction.repeat(blink, count: 5)
            self.spaceship.run(blinkForTime)
            self.childNode(withName: String(format: "L%d", arguments: [self.lives - 1]))?.removeFromParent()
            lives -= 1
        } else if (((secondBody.categoryBitMask & PhysicsCategory.laser == PhysicsCategory.laser) &&
            (firstBody.categoryBitMask & PhysicsCategory.asteroid == PhysicsCategory.asteroid))) {
            secondBody.node?.safeRemoveFromParent()
            self.score += 50
            setScore()
            if let explodable = firstBody.node as? Explodable {
                explodable.explode(self)
            }
            
        } else if ((secondBody.categoryBitMask == PhysicsCategory.trilaser) &&
            (firstBody.categoryBitMask == PhysicsCategory.spaceship)) {
            if let powerUp = secondBody.node as? PowerUp {
                powerUp.poweUp(self.spaceship)
            }
            secondBody.node?.safeRemoveFromParent()
        }
    }

}
