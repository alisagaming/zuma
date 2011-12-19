//
//  DirectionalPoint.m
//  BigZuma
//
//  Created by Kirill Kuvaldin on 30.10.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DirectionalPoint.h"

@implementation DirectionalPoint 

@synthesize point;
@synthesize angle;

-(id)initWithPoint:(CGPoint)_point angle:(float)_angle{
    if (self = [super init]) {
        point = _point;
        angle = _angle;
    }
    return self;
}

@end
