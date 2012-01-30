//
//  Zuma.h
//  BigZuma
//
//  Created by Kirill Kuvaldin on 28.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Frog.h"
#import "Level.h"
#import "Skull.h"

@interface Zuma : CCLayer {
    NSMutableArray *ballsRolling;
    NSMutableArray *ballsShot;
    NSMutableArray *ballsCollisions;
    NSMutableArray *ballsRollingBackwards;

    Frog *frog;
    Level *level;
    int ballsCount;
    BOOL paused;
    BOOL canMove;
    CGPoint beganPoint;
    CGPoint prevMovePoint;
}

@property (nonatomic, retain) Frog *frog;
@property (nonatomic, retain) Level *level;
@property (nonatomic, retain) Skull *skull;

+(CCScene *)scene;

@end
