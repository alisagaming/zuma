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
#import "DLGameMenu.h"
#import "DLGameOverMenu.h"
#import "Definitions.h"
#import "AdWhirlView.h"

@interface Zuma : CCLayer <DLGameMenuProtocol, DLGameOverMenuProtocol, AdWhirlDelegate> {
    NSMutableArray *ballsRolling;
    NSMutableArray *ballsShot;
    NSMutableArray *ballsCollisions;
    NSMutableArray *ballsRollingBackwards;

    Frog *frog;
    Level *level;
    int ballsCount;
    int score;
    BOOL paused;
    BOOL canMove;
    CGPoint beganPoint;
    CGPoint prevMovePoint;
    DLGameMenu *menuLayer;
    DLGameOverMenu *overMenuLayer;
    AdWhirlView *bannerView;

}

@property (nonatomic, retain) Frog *frog;
@property (nonatomic, retain) Level *level;
@property (nonatomic, retain) Skull *skull;
@property (nonatomic, retain) DLGameMenu *menuLayer;
@property (nonatomic, retain) DLGameOverMenu *overMenuLayer;
@property (nonatomic, retain) CCLabelTTF *scoreLabel;

+(CCScene *)sceneForLevel:(int)levelNumber;

@end
