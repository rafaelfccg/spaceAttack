//
//  EnemyShip.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 10/11/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class EnemyShip: SKSpriteNode {
    var shoot:ShotManager
    init() {
        let texture = SKTexture(imageNamed: Assets.spaceshipBgspeed)
        shoot = RegularShot()
        super.init(texture:texture, color:UIColor.clear , size:texture.size());   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
