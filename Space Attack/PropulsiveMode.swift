//
//  PropulsiveMode.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/23/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation

class PropulsiveMode: AnyObject, Mode {
    var spaceship: Spaceship
    var propulsiveShot:ShotManager
    var isPowerUped:Bool = false
    let powerUpTime:UInt64 = 15
    let speed:Double = 0.2
    let powerUpSpeed:Double = 0.4
    
    
    init(spaceship:Spaceship) {
        self.spaceship = spaceship
        propulsiveShot = RegularShot(shotInterval: 0.5)
    }
    func shoot(){
        propulsiveShot.shot(spaceship)
    }
    func hit()->Bool{
        return true
    }
    func activate(){}
    func deactivate() -> Bool{
        return true
    }
    func powerUp(){
        self.isPowerUped = true
        let delayTime = DispatchTime.init(uptimeNanoseconds: self.powerUpTime * NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.isPowerUped = false
        }
    }
    func getSpeedBonus() -> Double {
        if isPowerUped {
            return powerUpSpeed
        }
        return speed
    }
}
