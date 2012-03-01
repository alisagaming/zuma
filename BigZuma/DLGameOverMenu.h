//
//  DLGameMenu.h
//  BigZuma
//
//  Created by Andrej Syskaev on 14.02.12.
//  Copyright 2012 ch0wru@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Definitions.h"

@protocol DLGameOverMenuProtocol <NSObject>
    -(void) goMainMenuAction;
    -(void) restartAction;
@end

@interface DLGameOverMenu : CCLayerColor {
    
}

@property (nonatomic, retain) id<DLGameOverMenuProtocol> delegate;

-(id) initWithScore:(int)score;

@end
