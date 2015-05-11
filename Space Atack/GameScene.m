//
//  GameScene.m
//  Space Atack
//
//  Created by Rafael Gouveia on 5/11/15.
//  Copyright (c) 2015 Mini Challenge 2. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene{
    SKSpriteNode * _ship;
    FMMParallaxNode * _parallaxNodeBackg;
    FMMParallaxNode * _parallaxSoaceDust;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
   
}




-(id)initWithSize:(CGSize)size {
    self = [super initWithSize:size];
    if (self) {
        /* Setup your scene here */
        //2
        NSLog(@"SKScene:initWithSize %f x %f",size.width,size.height);
        
        //3
        self.backgroundColor = [SKColor blackColor];
        
#pragma mark - TBD - Game Backgrounds
        
#pragma mark - Setup Sprite for the ship
        //Create space sprite, setup position on left edge centered on the screen, and add to Scene
        //4
        _ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        _ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _ship.xScale = 0.2;
        _ship.yScale =0.2;
        [self addChild:_ship];
        
#pragma mark - TBD - Setup the asteroids
        
#pragma mark - TBD - Setup the lasers
        
#pragma mark - TBD - Setup the Accelerometer to move the ship
        
#pragma mark - TBD - Setup the stars to appear as particles
        
#pragma mark - TBD - Start the actual game
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        _ship.position = [touch locationInNode:self];
        
        /*SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
         
         sprite.xScale = 0.5;
         sprite.yScale = 0.5;
         sprite.position = location;
         
         //SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
         //[sprite runAction:[SKAction repeatActionForever:action]];
         
         [self addChild:sprite];*/
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
