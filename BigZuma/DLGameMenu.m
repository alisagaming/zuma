//
//  DLGameMenu.m
//  BigZuma
//
//  Created by Andrej Syskaev on 14.02.12.
//  Copyright 2012 ch0wru@gmail.com. All rights reserved.
//

#import "DLGameMenu.h"


@implementation DLGameMenu

@synthesize delegate;

- (id) init {
    
    if ((self = [super initWithColor:ccc4(0,0,0,75)] )) {
    
        //self.isTouchEnabled = YES;
        //[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *background = [CCSprite spriteWithFile: @"n891_512x384.jpg"];
        background.position = ccp(winSize.width /2.0, winSize.height /2.0);
        [self addChild:background];
        
        CCMenuItemSprite *restartItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"replay-btn.png"]
                                                                selectedSprite:[CCSprite spriteWithFile:@"replay-btn.png"]
                                                                        target:self selector:@selector(restart)];
        CCMenuItemSprite *pauseItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"paused-btn.png"]
                                                              selectedSprite:[CCSprite spriteWithFile:@"paused-btn.png"]
                                                                      target:self selector:@selector(resume)];
        
        CCMenuItemSprite *menuItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"menu-btn.png"]
                                                              selectedSprite:[CCSprite spriteWithFile:@"menu-btn.png"]
                                                                      target:self selector:@selector(goMenu	)];
        
        CCMenu *restartMenu = [CCMenu menuWithItems:restartItem, pauseItem, menuItem, nil];
        [restartMenu alignItemsVerticallyWithPadding:winSize.width /12.0];
        
        restartMenu.position = CGPointMake(winSize.width /2.0, winSize.height /2.0);
        [self addChild:restartMenu];
        
    }
    return  self;
}

- (void)resume {
    [self.delegate pauseAction];
}

- (void)restart {
    [self.delegate restartAction];
}

- (void)goMenu {
    [self.delegate goMainMenuAction];
}


- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}

@end