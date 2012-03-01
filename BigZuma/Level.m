//
//  Level.m
//  BigZuma
//
//  Created by Kirill Kuvaldin on 29.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Level.h"
#import "Bezier.h"
#import "Ball.h"
#import "Definitions.h"

@implementation Level

@synthesize pointsCount;
@synthesize totalBallsCount;
@synthesize startBallsCount;
@synthesize pathLength;
@synthesize colorCount;
@synthesize frogPosition, levelNumber;

+(Level *)level1 {
    NSArray *__pointsArray =
    [NSArray arrayWithObjects:

     [NSValue valueWithCGPoint:CGPointMake(13, 726)],
     [NSValue valueWithCGPoint:CGPointMake(72, 729)],
     [NSValue valueWithCGPoint:CGPointMake(131, 728)],
     [NSValue valueWithCGPoint:CGPointMake(196, 730)],
     [NSValue valueWithCGPoint:CGPointMake(255, 735)],
     [NSValue valueWithCGPoint:CGPointMake(313, 730)],
     [NSValue valueWithCGPoint:CGPointMake(362, 745)],
     [NSValue valueWithCGPoint:CGPointMake(412, 741)],
     [NSValue valueWithCGPoint:CGPointMake(461, 751)],
     [NSValue valueWithCGPoint:CGPointMake(503, 741)],
     [NSValue valueWithCGPoint:CGPointMake(555, 732)],
     [NSValue valueWithCGPoint:CGPointMake(596, 737)],
     [NSValue valueWithCGPoint:CGPointMake(638, 741)],
     [NSValue valueWithCGPoint:CGPointMake(677, 741)],
     [NSValue valueWithCGPoint:CGPointMake(736, 746)],
     [NSValue valueWithCGPoint:CGPointMake(787, 759)],
     [NSValue valueWithCGPoint:CGPointMake(841, 749)],
     [NSValue valueWithCGPoint:CGPointMake(886, 740)],
     [NSValue valueWithCGPoint:CGPointMake(921, 726)],
     [NSValue valueWithCGPoint:CGPointMake(915, 701)],
     [NSValue valueWithCGPoint:CGPointMake(863, 681)],
     [NSValue valueWithCGPoint:CGPointMake(772, 678)],
     [NSValue valueWithCGPoint:CGPointMake(696, 676)],
     [NSValue valueWithCGPoint:CGPointMake(592, 674)],
     [NSValue valueWithCGPoint:CGPointMake(482, 661)],
     [NSValue valueWithCGPoint:CGPointMake(400, 663)],
     [NSValue valueWithCGPoint:CGPointMake(325, 669)],
     [NSValue valueWithCGPoint:CGPointMake(245, 686)],
     [NSValue valueWithCGPoint:CGPointMake(144, 682)],
     [NSValue valueWithCGPoint:CGPointMake(61, 667)],
     [NSValue valueWithCGPoint:CGPointMake(14, 619)],
     [NSValue valueWithCGPoint:CGPointMake(41, 594)],
     [NSValue valueWithCGPoint:CGPointMake(123, 579)],
     [NSValue valueWithCGPoint:CGPointMake(190, 589)],
     [NSValue valueWithCGPoint:CGPointMake(280, 589)],
     [NSValue valueWithCGPoint:CGPointMake(383, 588)],
     [NSValue valueWithCGPoint:CGPointMake(496, 602)],
     [NSValue valueWithCGPoint:CGPointMake(668, 617)],
     [NSValue valueWithCGPoint:CGPointMake(734, 625)],
     [NSValue valueWithCGPoint:CGPointMake(824, 624)],
     [NSValue valueWithCGPoint:CGPointMake(885, 623)],
     [NSValue valueWithCGPoint:CGPointMake(908, 578)],
     [NSValue valueWithCGPoint:CGPointMake(842, 546)],
     [NSValue valueWithCGPoint:CGPointMake(734, 537)],
     [NSValue valueWithCGPoint:CGPointMake(599, 529)],
     [NSValue valueWithCGPoint:CGPointMake(475, 520)],
     [NSValue valueWithCGPoint:CGPointMake(370, 526)],
     [NSValue valueWithCGPoint:CGPointMake(234, 530)],
     [NSValue valueWithCGPoint:CGPointMake(124, 533)],
     [NSValue valueWithCGPoint:CGPointMake(38, 499)],
     [NSValue valueWithCGPoint:CGPointMake(50, 466)],
     [NSValue valueWithCGPoint:CGPointMake(127, 454)],
     [NSValue valueWithCGPoint:CGPointMake(210, 455)],
     [NSValue valueWithCGPoint:CGPointMake(361, 441)],
     [NSValue valueWithCGPoint:CGPointMake(484, 444)],
     [NSValue valueWithCGPoint:CGPointMake(588, 453)],
     [NSValue valueWithCGPoint:CGPointMake(687, 463)],
     [NSValue valueWithCGPoint:CGPointMake(786, 471)],
     [NSValue valueWithCGPoint:CGPointMake(853, 471)],
     [NSValue valueWithCGPoint:CGPointMake(921, 487)],
     [NSValue valueWithCGPoint:CGPointMake(1001, 502)],
     [NSValue valueWithCGPoint:CGPointMake(1017, 504)],
     nil];
 
    Level *level = [[[Level alloc] initWithPointsArray:__pointsArray andBG:@"level1.png"] autorelease];
    level.totalBallsCount = 70;
    level.startBallsCount = 35;
    level.frogPosition = CGPointMake(512, 100);
    level.colorCount = 4;//BALL_COLOR_COUNT;
    level.levelNumber = 1;
    
    return level;
}

+(Level *)level2 {
    NSArray *__pointsArray =
    [NSArray arrayWithObjects:
     
     [NSValue valueWithCGPoint:CGPointMake(15, 336)],
     [NSValue valueWithCGPoint:CGPointMake(33, 394)],
     [NSValue valueWithCGPoint:CGPointMake(72, 452)],
     [NSValue valueWithCGPoint:CGPointMake(141, 526)],
     [NSValue valueWithCGPoint:CGPointMake(205, 580)],
     [NSValue valueWithCGPoint:CGPointMake(256, 615)],
     [NSValue valueWithCGPoint:CGPointMake(334, 661)],
     [NSValue valueWithCGPoint:CGPointMake(427, 694)],
     [NSValue valueWithCGPoint:CGPointMake(486, 708)],
     [NSValue valueWithCGPoint:CGPointMake(577, 694)],
     [NSValue valueWithCGPoint:CGPointMake(700, 636)],
     [NSValue valueWithCGPoint:CGPointMake(727, 613)],
     [NSValue valueWithCGPoint:CGPointMake(756, 572)],
     [NSValue valueWithCGPoint:CGPointMake(771, 496)],
     [NSValue valueWithCGPoint:CGPointMake(761, 406)],
     [NSValue valueWithCGPoint:CGPointMake(726, 372)],
     [NSValue valueWithCGPoint:CGPointMake(665, 337)],
     [NSValue valueWithCGPoint:CGPointMake(574, 302)],
     [NSValue valueWithCGPoint:CGPointMake(523, 317)],
     [NSValue valueWithCGPoint:CGPointMake(467, 339)],
     [NSValue valueWithCGPoint:CGPointMake(430, 380)],
     [NSValue valueWithCGPoint:CGPointMake(392, 428)],
     [NSValue valueWithCGPoint:CGPointMake(360, 470)],
     [NSValue valueWithCGPoint:CGPointMake(359, 517)],
     [NSValue valueWithCGPoint:CGPointMake(391, 552)],
     [NSValue valueWithCGPoint:CGPointMake(426, 572)],
     [NSValue valueWithCGPoint:CGPointMake(477, 569)],
     [NSValue valueWithCGPoint:CGPointMake(521, 565)],
     [NSValue valueWithCGPoint:CGPointMake(561, 540)],
     [NSValue valueWithCGPoint:CGPointMake(596, 519)],
     [NSValue valueWithCGPoint:CGPointMake(608, 483)],
     [NSValue valueWithCGPoint:CGPointMake(575, 467)],
     [NSValue valueWithCGPoint:CGPointMake(515, 474)],
     [NSValue valueWithCGPoint:CGPointMake(458, 465)],
     [NSValue valueWithCGPoint:CGPointMake(471, 413)],
     [NSValue valueWithCGPoint:CGPointMake(523, 396)],
     [NSValue valueWithCGPoint:CGPointMake(599, 385)],
     [NSValue valueWithCGPoint:CGPointMake(651, 412)],
     [NSValue valueWithCGPoint:CGPointMake(675, 474)],
     [NSValue valueWithCGPoint:CGPointMake(671, 526)],
     [NSValue valueWithCGPoint:CGPointMake(634, 558)],
     [NSValue valueWithCGPoint:CGPointMake(592, 604)],
     [NSValue valueWithCGPoint:CGPointMake(544, 628)],
     [NSValue valueWithCGPoint:CGPointMake(481, 646)],
     [NSValue valueWithCGPoint:CGPointMake(404, 618)],
     [NSValue valueWithCGPoint:CGPointMake(346, 567)],
     [NSValue valueWithCGPoint:CGPointMake(297, 506)],
     [NSValue valueWithCGPoint:CGPointMake(271, 441)],
     [NSValue valueWithCGPoint:CGPointMake(273, 372)],
     [NSValue valueWithCGPoint:CGPointMake(306, 334)],
     [NSValue valueWithCGPoint:CGPointMake(359, 293)],
     [NSValue valueWithCGPoint:CGPointMake(426, 252)],
     [NSValue valueWithCGPoint:CGPointMake(506, 219)],
     [NSValue valueWithCGPoint:CGPointMake(573, 216)],
     [NSValue valueWithCGPoint:CGPointMake(661, 249)],
     [NSValue valueWithCGPoint:CGPointMake(734, 288)],
     [NSValue valueWithCGPoint:CGPointMake(801, 332)],
     [NSValue valueWithCGPoint:CGPointMake(847, 422)],
     [NSValue valueWithCGPoint:CGPointMake(879, 477)],
     [NSValue valueWithCGPoint:CGPointMake(913, 538)],
     [NSValue valueWithCGPoint:CGPointMake(973, 554)],
     [NSValue valueWithCGPoint:CGPointMake(1016, 556)],  
     nil];
    
    Level *level = [[[Level alloc] initWithPointsArray:__pointsArray andBG:@"blue-greed-ipad.png"] autorelease];
    level.totalBallsCount = 70;
    level.startBallsCount = 35;
    level.frogPosition = CGPointMake(512, 100);
    level.colorCount = 5;//BALL_COLOR_COUNT;
    level.levelNumber = 2;
    
    return level;
}

+(Level *)level3 {
    NSArray *__pointsArray =
    [NSArray arrayWithObjects:
     
     [NSValue valueWithCGPoint:CGPointMake(23, 355)],
     [NSValue valueWithCGPoint:CGPointMake(61, 356)],
     [NSValue valueWithCGPoint:CGPointMake(110, 360)],
     [NSValue valueWithCGPoint:CGPointMake(181, 356)],
     [NSValue valueWithCGPoint:CGPointMake(240, 356)],
     [NSValue valueWithCGPoint:CGPointMake(291, 361)],
     [NSValue valueWithCGPoint:CGPointMake(347, 360)],
     [NSValue valueWithCGPoint:CGPointMake(402, 361)],
     [NSValue valueWithCGPoint:CGPointMake(459, 375)],
     [NSValue valueWithCGPoint:CGPointMake(474, 399)],
     [NSValue valueWithCGPoint:CGPointMake(458, 435)],
     [NSValue valueWithCGPoint:CGPointMake(433, 470)],
     [NSValue valueWithCGPoint:CGPointMake(410, 516)],
     [NSValue valueWithCGPoint:CGPointMake(371, 573)],
     [NSValue valueWithCGPoint:CGPointMake(356, 628)],
     [NSValue valueWithCGPoint:CGPointMake(356, 671)],
     [NSValue valueWithCGPoint:CGPointMake(373, 716)],
     [NSValue valueWithCGPoint:CGPointMake(399, 731)],
     [NSValue valueWithCGPoint:CGPointMake(458, 704)],
     [NSValue valueWithCGPoint:CGPointMake(501, 669)],
     [NSValue valueWithCGPoint:CGPointMake(518, 638)],
     [NSValue valueWithCGPoint:CGPointMake(517, 609)],
     [NSValue valueWithCGPoint:CGPointMake(557, 630)],
     [NSValue valueWithCGPoint:CGPointMake(572, 668)],
     [NSValue valueWithCGPoint:CGPointMake(608, 711)],
     [NSValue valueWithCGPoint:CGPointMake(647, 726)],
     [NSValue valueWithCGPoint:CGPointMake(692, 726)],
     [NSValue valueWithCGPoint:CGPointMake(716, 686)],
     [NSValue valueWithCGPoint:CGPointMake(715, 644)],
     [NSValue valueWithCGPoint:CGPointMake(683, 597)],
     [NSValue valueWithCGPoint:CGPointMake(670, 555)],
     [NSValue valueWithCGPoint:CGPointMake(635, 492)],
     [NSValue valueWithCGPoint:CGPointMake(616, 455)],
     [NSValue valueWithCGPoint:CGPointMake(582, 391)],
     [NSValue valueWithCGPoint:CGPointMake(606, 366)],
     [NSValue valueWithCGPoint:CGPointMake(663, 378)],
     [NSValue valueWithCGPoint:CGPointMake(724, 386)],
     [NSValue valueWithCGPoint:CGPointMake(779, 385)],
     [NSValue valueWithCGPoint:CGPointMake(842, 392)],
     [NSValue valueWithCGPoint:CGPointMake(904, 390)],
     [NSValue valueWithCGPoint:CGPointMake(971, 389)],
     [NSValue valueWithCGPoint:CGPointMake(1008, 387)],
     nil];
    
    Level *level = [[[Level alloc] initWithPointsArray:__pointsArray andBG:@"Beautiful-girls-322.jpg"] autorelease];
    level.totalBallsCount = 70;
    level.startBallsCount = 35;
    level.frogPosition = CGPointMake(512, 100);
    level.colorCount = 6;//BALL_COLOR_COUNT;
    level.levelNumber = 3;
    
    return level;
}

- (id)initWithPointsArray:(NSArray *)__pointsArray andBG:(NSString *)bgName{
    if (self = [super init]) {
        pointsArray = __pointsArray;
        pointsCount = __pointsArray.count;
        path = [[NSMutableArray alloc] init];
        for (int j = 0; j < self.pointsCount - 2; j++) {
            CGPoint a0 = [self pointAtIndex:j];
            CGPoint a1 = [self pointAtIndex:j+1];
            CGPoint a2 = [self pointAtIndex:j+2];
            CGPoint p0 = (j == 0) ? a0 : CGPointMake((a0.x+a1.x)/2, (a0.y+a1.y)/2);
            CGPoint p1 = a1;
            CGPoint p2 = (j < self.pointsCount - 3) ? CGPointMake((a1.x+a2.x)/2, (a1.y+a2.y)/2) : a2;
            Bezier *bezier = [[[Bezier alloc] initWith:p0 :p1 :p2 :STEP] autorelease];
            for (int m = 1; m <= bezier.step; m++) {
                DirectionalPoint *dp = [bezier getAnchorPoint:m];
                if (dp)
                    [path addObject:dp];
            }
        }
        bgSprite = [[CCSprite alloc] initWithFile:bgName];
        bgSprite.position = ccp(SW/2, SH/2);
        [self addChild:bgSprite];
        //self.position = ccp(SW/2, SH/2);
    }
    return self;
}

- (CGPoint)pointAtIndex:(int)index {
    return [(NSValue*)[pointsArray objectAtIndex:index] CGPointValue];
}

- (CGPoint)pointAtPath:(int)index {
    return [(DirectionalPoint*)[path objectAtIndex:index] point];
}

-(DirectionalPoint *)pathPoint:(int)index {
    if (index < 0)
        return [path objectAtIndex:0];
    else if (index >= path.count)
        return [path lastObject];
    else
        return [path objectAtIndex:index];
}

-(DirectionalPoint *)deathPoint {
    return [path lastObject];
}

-(int)pathLength {
    return path.count;
}

-(void)dealloc {
    [bgSprite release];
    bgSprite = nil;
    [path release];
    path = nil;
    [super dealloc];
}

@end
