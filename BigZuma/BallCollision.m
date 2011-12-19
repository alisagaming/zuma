//
//  BallCollision.m
//  BigZuma
//
//  Created by Kirill Kuvaldin on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BallCollision.h"

@implementation BallCollision

@synthesize ballRoll, ballShot, placement;

-(id)initWithBallShot:(Ball*)_ballShot ballRoll:(Ball*)_ballRoll placement:(int)_placement {
    if (self = [super init]) {
        self.ballShot = _ballShot;
        self.ballRoll = _ballRoll;
        self.placement = _placement;
    }
    return self;
}

+(BallCollision *)collisionWithBallShot:(Ball*)_ballShot ballRoll:(Ball*)_ballRoll placement:(int)_placement {
    return [[[BallCollision alloc] initWithBallShot:_ballShot ballRoll:_ballRoll placement:_placement] autorelease];
}



@end
