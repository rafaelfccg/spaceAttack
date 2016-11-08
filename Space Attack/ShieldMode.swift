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
    let powerUpTime:Double = 20
    let regenerationTime:Double = 20
    var shieldNode:SKShapeNode
    var isActive:Bool = false
    
    
    init(spaceship:Spaceship) {
        self.spaceship = spaceship
        self.shieldNode = SKShapeNode(circleOfRadius: self.spaceship.size.width)
        self.shieldNode.fillColor = SKColor(colorLiteralRed: 0.1, green: 0.15, blue: 0.9, alpha: 0.4)
        self.shieldNode.zPosition = self.spaceship.zPosition+1;
        shieldShot = RegularShot(shotInterval: 0.8)
        shieldShot.target = PhysicsCategory.asteroid | PhysicsCategory.enemy
        shieldShot.category = PhysicsCategory.laser
    }
    internal func activate() {
        self.spaceship.addChild(self.shieldNode)
        isActive = true
    }
    
    internal func deactivate() -> Bool {
        if self.shieldHP <= 0 {
            return false
        }
        self.shieldNode.removeFromParent()
        isActive = false
        return true
    }
    func shoot(){
        shieldShot.shot(spaceship)
    }
    func hit()->Bool{
        if self.powerUpHP > 0 {
            powerUpHP -= 1
            return false
        }
        if self.shieldHP <= 0 {
            return true
        }
        self.shieldHP -= 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.regenerationTime) {
            if (self.shieldHP < 3) {
                self.shieldHP += 1
            }
            if self.isActive && self.shieldNode.parent == nil {
                self.spaceship.addChild(self.shieldNode)
            }
        }
        if self.shieldHP <= 0 {
            self.shieldNode.removeFromParent()
        }
        
        return false
    }
    func powerUp(){
        self.powerUpHP += 3
        DispatchQueue.main.asyncAfter(deadline: .now() + self.powerUpTime) {
            self.powerUpHP = 0
        }
    }
    func getSpeedBonus() -> Double {
        return 0.1
    }
}
