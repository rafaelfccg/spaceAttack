//
//  ShipNode.h
//  Space Atack
//
//  Created by Rafael Gouveia on 8/5/15.
//  Copyright (c) 2015 Mini Challenge 2. All rights reserved.
//
#import "Constants.h"
#import <SpriteKit/SpriteKit.h>



@interface ShipNode : SKSpriteNode 

@property CGFloat ship_Speed;
@property bool OnTrilaser;
@property double trilaserTime;
@property int nextShipLaser;
@property NSMutableArray *shipLasers;
@property double  nextLaserSpawn;

-(void)doLaser:(SKScene*)scene;
@end
