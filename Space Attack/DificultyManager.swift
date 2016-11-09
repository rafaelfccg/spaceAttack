//
//  DificultyManager.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 11/1/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import Darwin
import SpriteKit

class DificultyManager: AnyObject {
    static let sharedInstance = DificultyManager()
    
    let Cspeed: CGFloat = 0.99
    
    //Asteroid
    let asteroidLauchMinImpulse: CGFloat = 11
    let asteroidLauchMaxImpulse: CGFloat = 30
    let asteroidHorizontalImpulse: CGFloat = 4
    let asteroidTopImpulse: CGFloat = 12
    let asteroidMinImpulse: CGFloat = 2
    let asteroidTimeIntervalMin: CGFloat = 0.1
    let asteroidTimeIntervalMax: CGFloat = 0.3
    let maximumAsteroidInterval: CGFloat = 1.3
    let minimumAsteroidInterval: CGFloat = 0.6
    var multiplier: CGFloat
    
    init() {
        multiplier = 1
    }
    
    static func getInstance() -> DificultyManager {
        return sharedInstance
    }
    
    func dificultyForMultiplier(multiplier: CGFloat) -> CGFloat {
        return multiplier / 2 + 1.5 * sin(multiplier / 3)
    }
    
    func speedForMultiplier(multiplier: CGFloat) -> CGFloat {
        return (1 - pow(Cspeed, multiplier))
    }
    
    func intervalForMultiplier(multiplier: CGFloat) -> CGFloat {
        return pow(Cspeed, multiplier)
    }
    
    func getAsteroidSpeed() -> (CGFloat,CGFloat) {
        let speedFactor = self.speedForMultiplier(multiplier: self.multiplier)
        let topImpulse = min(Utils.random(asteroidLauchMinImpulse, max: asteroidLauchMaxImpulse) * speedFactor, self.asteroidTopImpulse)
        let impulse = max(topImpulse, asteroidMinImpulse)
        return (Utils.random(0, max: asteroidHorizontalImpulse) * speedFactor, impulse)
    }
    
    func getNextAsteroidSpawn() -> Double {
        let curTime = CACurrentMediaTime()
        var speedFactor = intervalForMultiplier(multiplier: self.multiplier)
        speedFactor *= speedFactor
        let maxi = self.maximumAsteroidInterval * speedFactor + self.asteroidTimeIntervalMax
        var mini = self.minimumAsteroidInterval * speedFactor + self.asteroidTimeIntervalMin
        
        if maxi - mini < 0.8 {
            mini = maxi - 0.8
        }

        return Double(Utils.random(mini, max: maxi)) + curTime
    }
}
