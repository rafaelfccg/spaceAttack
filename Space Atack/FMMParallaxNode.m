//
//  FMMParallaxNode.m
//  SpaceShooter
//
//  Created by Tony Dahbura on 9/9/13.
//  Copyright (c) 2013 fullmoonmanor. All rights reserved.
//

#import "FMMParallaxNode.h"


@implementation FMMParallaxNode
{
    
    __block NSMutableArray *_backgrounds;
    NSInteger _numberOfImagesForBackground;
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _deltaTime;
    float _pointsPerSecondSpeed;
    BOOL _randomizeDuringRollover;
    CGSize _framesize;
    
}


- (instancetype)initWithBackground:(NSString *)file size:(CGSize)size pointsPerSecondSpeed:(float)pointsPerSecondSpeed frameSize:(CGSize) csz;
{
    // we add the file 3 times to avoid image flickering
    return [self initWithBackgrounds:@[file, file, file]
                                size:size
                pointsPerSecondSpeed:pointsPerSecondSpeed
                                frameSize:csz];
    
}

- (instancetype)initWithBackgrounds:(NSArray *)files size:(CGSize)size pointsPerSecondSpeed:(float)pointsPerSecondSpeed frameSize:(CGSize) csz
{
    if (self = [super init])
    {
        _pointsPerSecondSpeed = pointsPerSecondSpeed;
        _numberOfImagesForBackground = [files count];
        _backgrounds = [NSMutableArray arrayWithCapacity:_numberOfImagesForBackground];
        _randomizeDuringRollover = NO;
        [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:obj];
            node.size = size;
            node.anchorPoint = CGPointZero;
            node.position = CGPointMake(0.0,size.height*idx);
            node.name = @"background";
            //NSLog(@"node.position = x=%f,y=%f",node.position.x,node.position.y);
            _framesize = csz;
            [_backgrounds addObject:node];
            [self addChild:node];
        }];
    }
    return self;
}

// Add new method, above update loop
- (CGFloat)randomValueBetween:(CGFloat)low andValue:(CGFloat)high {
    return (((CGFloat) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}


- (void)randomizeNodesPositions
{
    [_backgrounds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        SKSpriteNode *node = (SKSpriteNode *)obj;
        [self randomizeNodePosition:node];
        
    }];
    //flag it for random placement each main scroll through
    _randomizeDuringRollover = YES;
    
}


- (void)randomizeNodePosition:(SKSpriteNode *)node
{
//    CGFloat randomOffset = [self randomValueBetween:0 andValue:50];
//    CGFloat randomSign = [self randomValueBetween:0.0 andValue:1000.0]>500.0 ? -1 : 1;
//    randomOffset *= randomSign;
//    NSLog(@"randomsign=%f",randomSign);
//    node.position = CGPointMake(node.position.x,node.position.y+randomOffset);
    
    //I liked this look better for randomizing the placement of the nodes!
    CGFloat randomXPosition = [self randomValueBetween:(-_framesize.width/2)
                                              andValue:(_framesize.width/2)];
   
    
    node.position = CGPointMake(randomXPosition, node.position.y +_framesize.height/2 +node.size.height/2);
    NSLog(@"NODE x: %f /y: %f",node.position.x,node.position.y);
    
}

-(CGSize)getSize{
    return _framesize;
}

- (void)update:(NSTimeInterval)currentTime
{
    //To compute velocity we need delta time to multiply by points per second
    if (_lastUpdateTime) {
        _deltaTime = currentTime - _lastUpdateTime;
    } else {
        _deltaTime = 0;
    }
    _lastUpdateTime = currentTime;
    
    CGPoint bgVelocity = CGPointMake(0.0,-_pointsPerSecondSpeed);
    CGPoint amtToMove = CGPointMake(bgVelocity.x * _deltaTime, bgVelocity.y * _deltaTime);
    self.position = CGPointMake(self.position.x+amtToMove.x, self.position.y+amtToMove.y);
    SKNode *backgroundScreen = self.parent;
    
    [_backgrounds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKSpriteNode *bg = (SKSpriteNode *)obj;
        CGPoint bgScreenPos = [self convertPoint:bg.position
                                          toNode:backgroundScreen];
        if (bgScreenPos.y <= -bg.size.height)
        {
            bg.position = CGPointMake(bg.position.x, (bg.size.height * _numberOfImagesForBackground)+ bg.position.y);
           
            if (_randomizeDuringRollover) {
                [self randomizeNodePosition:bg];
            }
            // NSLog(@" x: %f /y: %f",bg.position.y,bg.position.x);
        }
        
    }];
}

@end
