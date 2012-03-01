//
//  MainMenuViewController.m
//  BigZuma
//
//  Created by Andrej Syskaev on 16.02.12.
//  Copyright (c) 2012 ch0wru@gmail.com. All rights reserved.
//

#import "MainMenuViewController.h"
#import "cocos2d.h"
#import "Zuma.h"

@implementation MainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

-(IBAction) l1 {
    [[CCDirector sharedDirector] replaceScene: [Zuma sceneForLevel:1]];
}

-(IBAction) l2 {
    [[CCDirector sharedDirector] replaceScene: [Zuma sceneForLevel:2]];
}

-(IBAction) l3 {
    [[CCDirector sharedDirector] replaceScene: [Zuma sceneForLevel:3]];
}

@end
