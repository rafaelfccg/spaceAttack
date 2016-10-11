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
    var currDirection: CGVector
    var lastRotation: Double = 0
    
    let changeDirectionProbability:CGFloat = 0.4
    let minimumTimeAtDirection:Double = 1
    let maximumRotatation = M_PI/8
    let speed: CGFloat = 10

    init() {
        self.currDirection = CGVector(dx: 0, dy: 1)
    }
    
    func changeDirection(node:SKNode) {
        let angle = Utils.random(-maximumRotatation, max: maximumRotatation);
        
    }
    
    func applyMovement(node:SKNode){
        let currTime = CACurrentMediaTime()
        if (self.lastRotation + self.minimumTimeAtDirection < currTime) {
            changeDirection(node: node)
        }
    }
    
}
