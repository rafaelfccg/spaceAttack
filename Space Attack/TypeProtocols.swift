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
    func explode(scene:GameScene)
}

protocol Hitable {
    func hittedBy(node:SKNode)
}

protocol ShotManager {
    var nextLaserSpawn:Double {get}
    var shotInterval:Double {get}
    func shot(node:SKNode)
    
}

protocol PowerUp {
    func poweUp(ship:Spaceship)
}