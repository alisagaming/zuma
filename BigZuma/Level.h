//
//  Level.h
//  BigZuma
//
//  Created by Kirill Kuvaldin on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DirectionalPoint.h"
#import "cocos2d.h"

@interface Level : CCLayer {
    NSArray *pointsArray;
    NSMutableArray *path;
    CCSprite *bgSprite;
}

+(Level *)level1;
+(Level *)level2;
+(Level *)level3;

@property (nonatomic, assign) int pointsCount;
@property (nonatomic, assign) int totalBallsCount;
@property (nonatomic, assign) int startBallsCount;
@property (nonatomic, assign) int pathLength;
@property (nonatomic, assign) int colorCount;
@property (nonatomic, assign) int levelNumber;
@property (nonatomic, assign) CGPoint frogPosition;

-(CGPoint)pointAtIndex:(int)index;
- (id)initWithPointsArray:(NSArray *)__pointsArray andBG:(NSString *)bgName;
-(DirectionalPoint *)pathPoint:(int)index;
-(DirectionalPoint *)deathPoint;

@end
