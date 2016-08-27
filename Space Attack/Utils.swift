//
//  Utils.swift
//  Space Attack
//
//  Created by Miguel Araújo on 8/27/16.
//  Copyright © 2016 Miguel Araújo. All rights reserved.
//

import Foundation

public class Utils {
    static func random(min: Double, max: Double) -> Double {
        return Double( arc4random() / 0xFFFFFFFF) * (max - min) + min;
    }
}