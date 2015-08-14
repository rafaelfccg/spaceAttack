//
//  ShipNode.m
//  Space Atack
//
//  Created by Rafael Gouveia on 8/5/15.
//  Copyright (c) 2015 Mini Challenge 2. All rights reserved.
//

#import "ShipNode.h"

@interface SKSpriteNode ()

-(void)doLaser;

@end

@implementation ShipNode

- (instancetype)init
{
    self = [super initWithImageNamed:@"Spaceship"];
    //self = (ShipNode*)[SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    if (self) {
       // self.texture = [SKTexture textureWithImageNamed:@"Spaceship"];
        //self.size = self.texture.size;
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
-(void)doLaser:(SKScene*)scene
{
    double curTime = CACurrentMediaTime();
    if(curTime> _trilaserTime+15)_OnTrilaser = NO;
    
    if (!_OnTrilaser && curTime > _nextLaserSpawn) {
        _nextLaserSpawn = 0.2+curTime;
        
        SKSpriteNode *shipLaser  = [SKSpriteNode spriteNodeWithImageNamed:@"SBlueShot"];;
        //2
        shipLaser.position = CGPointMake(self.position.x, shipLaser.size.height/2+self.position.y);
        
        shipLaser.hidden = NO;
        [shipLaser removeAllActions];
        
        shipLaser.physicsBody = [SKPhysicsBody bodyWithTexture:shipLaser.texture size:shipLaser.texture.size];
        shipLaser.physicsBody.categoryBitMask = laserCategory;
        shipLaser.physicsBody.contactTestBitMask = asteroidCategory;
        shipLaser.physicsBody.collisionBitMask = 0x0;
        shipLaser.physicsBody.allowsRotation =NO;
        SKAction* remove = [SKAction removeFromParent];
        SKAction* seq = [SKAction sequence:@[[SKAction waitForDuration:5],remove]];
        [scene addChild:shipLaser];
        // CGPoint location = CGPointMake(randX, -self.frame.size.height-asteroid.size.height);
        [shipLaser runAction:seq];
        [shipLaser.physicsBody applyImpulse:CGVectorMake(0, 10)];
    }else if(curTime> _nextLaserSpawn){
        _nextLaserSpawn = 0.15+curTime;
        
        NSArray *shots = @[[SKSpriteNode spriteNodeWithImageNamed:@"redShot"],
                           [SKSpriteNode spriteNodeWithImageNamed:@"redShot"],
                           [SKSpriteNode spriteNodeWithImageNamed:@"redShot"]];
        
        //SKSpriteNode *shipLaser  = [SKSpriteNode spriteNodeWithImageNamed:@"redShot"];
        //2
        for (SKSpriteNode* shipLaser in shots) {
            
            shipLaser.position = CGPointMake(self.position.x, shipLaser.size.height/2+self.position.y);
            shipLaser.hidden = NO;
            [shipLaser removeAllActions];
            
            shipLaser.physicsBody = [SKPhysicsBody bodyWithTexture:shipLaser.texture size:shipLaser.texture.size];
            shipLaser.physicsBody.categoryBitMask = laserCategory;
            shipLaser.physicsBody.contactTestBitMask = asteroidCategory;
            shipLaser.physicsBody.collisionBitMask = 0x0;
            shipLaser.physicsBody.allowsRotation =NO;
            SKAction* remove = [SKAction removeFromParent];
            SKAction* seq = [SKAction sequence:@[[SKAction waitForDuration:5],remove]];
            [scene addChild:shipLaser];
            [shipLaser runAction:seq];
        }
        // CGPoint location = CGPointMake(randX, -self.frame.size.height-asteroid.size.height);
        
        [((SKSpriteNode * )[shots objectAtIndex:0]).physicsBody applyImpulse:CGVectorMake(1, 10)];
        [((SKSpriteNode * )[shots objectAtIndex:1]).physicsBody applyImpulse:CGVectorMake(0, 10)];
        [((SKSpriteNode * )[shots objectAtIndex:2]).physicsBody applyImpulse:CGVectorMake(-1, 10)];
        
    }
    
}

@end
