//
//  Lauchable.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 9/14/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation


protocol Lauchable {
    func lauch()
}

protocol Explodable {
    func explode(scene:GameScene)
}