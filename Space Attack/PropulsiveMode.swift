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
    let speed:Double = 2
    let powerUpSpeed:Double = 4
    
    
    init(spaceship:Spaceship) {
        self.spaceship = spaceship
        propulsiveShot = RegularShot()
    }
    func shoot(){
        propulsiveShot.shot(spaceship)
    }
    func Hit()->Bool{
        return false
    }
    func powerUp(){
        self.isPowerUped = true
        let delayTime = DispatchTime.init(uptimeNanoseconds: self.powerUpTime * NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.isPowerUped = false
        }
    }
    func getSpeed() -> Double {
        if isPowerUped {
            return powerUpSpeed
        }
        return speed
    }
}
