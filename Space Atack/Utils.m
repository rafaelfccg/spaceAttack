//
//  Utils.m
//  Space Atack
//
//  Created by Rafael Gouveia on 8/16/16.
//  Copyright © 2016 Mini Challenge 2. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+ (float)randomValueBetween:(float)low andValue:(float)high {
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}
@end
