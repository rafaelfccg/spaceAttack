//
//  Lauchable.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/14/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit


protocol Lauchable {
    func lauch()
}

protocol Explodable {
    func explode(_ scene:GameScene)
}

protocol Hitable {
    func hittedBy(_ node:SKNode)
}

protocol Mode {
    var spaceship:Spaceship { get }
    func shoot()
    func Hit()->Bool
    func powerUp()
    func getSpeed() -> Double
}
protocol ShotManager {
    var nextLaserSpawn:Double {get}
    var shotInterval:Double {get}
    func shot(_ node:SKNode)
    
}

protocol PowerUp {
    func poweUp(_ ship:Spaceship)
}
