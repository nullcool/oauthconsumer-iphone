//
//  oauthTwitterAppAppDelegate.m
//  oauthTwitterApp
//
//  Created by Charles Choi on 6/2/10.
//  Copyright Yummy Melon Software LLC 2010. All rights reserved.
//

#import "oauthTwitterAppAppDelegate.h"
#import "oauthTwitterAppViewController.h"

@implementation oauthTwitterAppAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
