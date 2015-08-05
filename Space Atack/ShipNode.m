//
//  ShipNode.m
//  Space Atack
//
//  Created by Rafael Gouveia on 8/5/15.
//  Copyright (c) 2015 Mini Challenge 2. All rights reserved.
//

#import "ShipNode.h"
#import "Constants.h"


@implementation ShipNode

- (instancetype)init
{
    self = (ShipNode*)[SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    if (self) {
        self.xScale = 0.8;
        self.yScale =0.8;
        
        CGSize a  = self.texture.size;
        a.height = a.height*0.2;
        a.width =a.width *0.2;
        self.physicsBody = [SKPhysicsBody bodyWithTexture:self.texture  size:self.size];
        
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.allowsRotation = NO;
        self.physicsBody.categoryBitMask = shipCategory;
        self.physicsBody.collisionBitMask = 0x0;
        self.physicsBody.contactTestBitMask = shipCategory|eshipCategory|asteroidCategory| itemTrilaser;
        //_ship.physicsBody.usesPreciseCollisionDetection;
        [self.physicsBody setMass:0.366144];
        
    }
    return self;
}

@end
