//
//  Shield.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/23/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import SpriteKit

class Shield: SKShapeNode, Hitable {
    
    var life = 3;
    
    static func shieldNode(forShipOfSize size: CGSize)->Shield{
        let shield = Shield(ellipseOf: size);
        return shield;
    }
    
    func hittedBy(_ node:SKNode){
        life -= 1;
    }
}
