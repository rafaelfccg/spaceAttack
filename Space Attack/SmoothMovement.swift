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
    var lastRotation: Double = 0
    let minimumTimeAtDirection: Double = 5
    
    let defaultRotation: CGFloat = CGFloat(M_PI)
    let speed: CGFloat = 20
    let forceNorm: CGFloat = 30
    var yDistanceMax: CGFloat = 150
    var yDistanceMin: CGFloat = 100
    var aimPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    var currDirection: CGVector = CGVector(dx: 0, dy: 1)
    let frontDirection: CGVector = CGVector(dx: 0, dy: 1)
    
    init() {}
    
    func changeDirection(node:SKNode) {
        
        let scene  = Utils.getRootNode(node: node)
        let xPos = Utils.random(0, max: scene.frame.size.width)
        let yDis = Utils.random(yDistanceMin, max: yDistanceMin)
        self.aimPoint = CGPoint(x:xPos,y: node.position.y - yDis)
    }
    
    func moveToAim(node:SKNode) {
        let xDir = (aimPoint.x - node.position.x)
        let yDir = (aimPoint.y - node.position.y)
        let normF = Utils.norm(xDir, y: yDir)
        let forceVector = CGVector(dx:xDir * self.forceNorm / normF , dy: yDir * self.forceNorm / normF)
        
        let velocity = node.physicsBody?.velocity
        if(velocity != nil){
            let norm = Utils.norm(velocity!.dx, y: velocity!.dy)

            node.physicsBody?.applyForce(forceVector)
            
            let angle = asin(velocity!.dx/norm) + self.defaultRotation
            node.run(SKAction.rotate(toAngle: angle, duration: 0))
            let normXSpeed = velocity!.dx / norm
            let normYSpeed = velocity!.dy / norm
            node.physicsBody?.velocity = CGVector(dx:  normXSpeed * speed,
                                                  dy:  normYSpeed * speed)
            self.currDirection = CGVector(dx: normXSpeed, dy: normYSpeed)
        }
    }
    func reflectAngle(angle:CGFloat) -> CGFloat {
        return (2 * CGFloat(M_PI) - angle)
    }
    func applyMovement(node:SKNode){
        let currTime = CACurrentMediaTime()
        if (self.lastRotation + self.minimumTimeAtDirection < currTime ||
            abs(aimPoint.y - node.position.y) < (yDistanceMin / 4)) {
            self.lastRotation = currTime
            changeDirection(node: node)
            
        }
        moveToAim(node: node)
    }
    
}
