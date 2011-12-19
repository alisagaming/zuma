//
//  BallCollision.h
//  BigZuma
//
//  Created by Kirill Kuvaldin on 31.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ball.h"

/* placement constants */
#define INSERT_BEFORE   0
#define INSERT_AFTER    1

@interface BallCollision : NSObject

+(BallCollision *)collisionWithBallShot:(Ball*)_ballShot ballRoll:(Ball*)_ballRoll placement:(int)_placement;

@property (nonatomic, retain) Ball *ballShot;
@property (nonatomic, retain) Ball *ballRoll;
@property (nonatomic, assign) int placement;

@end
