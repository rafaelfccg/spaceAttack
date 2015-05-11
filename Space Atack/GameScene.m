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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"teste");
        //NSLog(@"SKScene:initWithSize %f x %f",size.width,size.height);
        
        //3
        self.backgroundColor = [SKColor blackColor];
        
#pragma mark - TBD - Game Backgrounds
        NSArray *paralaxBackgroundNames = @[@"SpaceBck",@"SpaceNeb"];
        CGSize planetSizes = CGSizeMake(200.0, 200.0);
        //2
        _parallaxNodeBackg = [[FMMParallaxNode alloc] initWithBackgrounds:paralaxBackgroundNames
                                                                     size:planetSizes
                                                     pointsPerSecondSpeed:10.0];
        //3
        // _parallaxNodeBackg.position = CGPointMake(size.width/2.0, sizbe.height/2.0);
        ///4
        //[_parallaxNodeBackgrounds randomizeNodesPositions];
        
        //5
        //[self addChild:_parallaxNodeBackgrounds];
        
        
#pragma mark - Setup Sprite for the ship
        //Create space sprite, setup position on left edge centered on the screen, and add to Scene
        //4
        _ship = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        _ship.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _ship.xScale = 0.2;
        _ship.yScale = 0.2;
        [self addChild:_ship];
        
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
