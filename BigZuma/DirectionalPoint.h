//
//  DirectionalPoint.h
//  BigZuma
//
//  Created by Kirill Kuvaldin on 30.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DirectionalPoint : NSObject {
    CGPoint point;
    float angle;
}

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) float angle;

-(id)initWithPoint:(CGPoint)_point angle:(float)_angle;

@end
