//
//  ShieldMode.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/23/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class ShieldMode: AnyObject, Mode {
    
    var spaceship: Spaceship
    var shieldShot:ShotManager
    var shieldHP = 3
    var powerUpHP = 0
    let powerUpTime:UInt64 = 15
    var shieldNode:SKShapeNode
    
    init(spaceship:Spaceship) {
        self.spaceship = spaceship
        self.shieldNode = SKShapeNode(circleOfRadius: self.spaceship.size.width/2)
        shieldShot = RegularShot()
    }
    internal func activate() {
        self.spaceship.addChild(self.shieldNode)
    }
    
    internal func deactivate() -> Bool {
        self.shieldNode.removeFromParent()
        return true
    }
    func shoot(){
        shieldShot.shot(spaceship)
    }
    func Hit()->Bool{
        if self.powerUpHP > 0 {
            powerUpHP -= 1
            return false
        }
        if self.shieldHP <= 0 {
            return true
        }
        self.shieldHP -= 1
        return false
    }
    func powerUp(){
        self.powerUpHP += 3
        let delayTime = DispatchTime.init(uptimeNanoseconds: self.powerUpTime * NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) { 
            self.powerUpHP = 0
        }
    }
    func getSpeed() -> Double {
        return 0
    }
}
