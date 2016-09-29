//
//  ShooterMode.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/23/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation

class ShooterMode: AnyObject, Mode {
    var spaceship: Spaceship
    var regularShot:ShotManager
    var powerUpShoot:ShotManager
    var isPowerUped:Bool = false
    
    let powerUpTime:UInt64 = 15
    let speed:Double = 1
    
    init(spaceship:Spaceship) {
        self.spaceship = spaceship
        regularShot = RegularShot()
        powerUpShoot = TrilaserShot()
    }
    func shoot(){
        if(self.isPowerUped){
            powerUpShoot.shot(spaceship)
        }else {
            regularShot.shot(spaceship)
        }
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
        return speed
    }
}
