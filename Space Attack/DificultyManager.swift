//
//  DificultyManager.swift
//  SpaceAttack
//
//  Created by Rafael Gouveia on 11/1/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation
import Darwin

class DificultyManager: AnyObject {
    
    func dificultyForMultiplier(multiplier: Double) -> Double {
        return multiplier/2 + 1.5 * sin(multiplier/3)
    }
}
