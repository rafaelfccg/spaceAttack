//
//  SmoothMovement.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 10/11/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class SmoothMovement: AnyObject, MovementPattern {
    
    let frontDirection: CGVector = CGVector(dx: 0, dy: 1)
    let changeDirectionProbability:CGFloat = 0.4
    let minimumTimeAtDirection:Double = 3
    let maximumRotatation = M_PI/2
    let defaultRotation = M_PI
    let speed: CGFloat = 50
    
    var lastRotation: Double = 0
    var currDirection:CGVector = CGVector(dx: 0, dy: 1)
    init() {}
    
    func changeDirection(node:SKNode) {
        let angle = Utils.random(-maximumRotatation, max: maximumRotatation) + self.defaultRotation
        let dir = Utils.rotateVector(vector: frontDirection, byAngle: angle)
        self.currDirection = dir
        node.run(SKAction.rotate(toAngle: CGFloat(angle), duration: 0.2))
        let speedVector = CGVector(dx: dir.dx * speed,dy: dir.dy * speed)
        node.physicsBody?.velocity = speedVector
    }
    
    func applyMovement(node:SKNode){
        let currTime = CACurrentMediaTime()
        if (self.lastRotation + self.minimumTimeAtDirection < currTime) {
            self.lastRotation = currTime
            changeDirection(node: node)
            
        }
    }
    
}
