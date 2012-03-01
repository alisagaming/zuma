//
//  DLGameMenu.m
//  BigZuma
//
//  Created by Andrej Syskaev on 14.02.12.
//  Copyright 2012 ch0wru@gmail.com. All rights reserved.
//

#import "DLGameOverMenu.h"


@implementation DLGameOverMenu

@synthesize delegate;

- (id) initWithScore:(int)score {
    
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
        CCMenuItemSprite *menuItem = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"menu-btn.png"]
                                                              selectedSprite:[CCSprite spriteWithFile:@"menu-btn.png"]
                                                                      target:self selector:@selector(goMenu)];
        
        
        CCMenu *restartMenu = [CCMenu menuWithItems:restartItem, menuItem, nil];
        [restartMenu alignItemsVerticallyWithPadding:winSize.width /6.0];
        
        restartMenu.position = CGPointMake(winSize.width /2.0, winSize.height /2.0);
        [self addChild:restartMenu];
        
        
        CCLabelTTF *scoreLabel = [[CCLabelTTF alloc] initWithString:[NSString stringWithFormat:@"Your score : %d!", score] fontName:@"kablam!_" fontSize:50.0];
        scoreLabel.position = ccp(SW/2, SH/2);
        scoreLabel.color = ccc3(0xff, 0, 0);
        [self addChild:scoreLabel];
        
    }
    return  self;
}

- (void)goMenu {
    [self.delegate goMainMenuAction];
}

- (void)restart {
    [self.delegate restartAction];
}


- (void)dealloc {
    self.delegate = nil;
    [super dealloc];
}

@end