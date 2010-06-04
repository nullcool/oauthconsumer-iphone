//
//  oauthTwitterAppAppDelegate.h
//  oauthTwitterApp
//
//  Created by Charles Choi on 6/2/10.
//  Copyright Yummy Melon Software LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class oauthTwitterAppViewController;

@interface oauthTwitterAppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    oauthTwitterAppViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet oauthTwitterAppViewController *viewController;


@end

