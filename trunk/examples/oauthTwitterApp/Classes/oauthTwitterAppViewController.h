//
//  oauthTwitterAppViewController.h
//  oauthTwitterApp
//
//  Created by Charles Choi on 6/2/10.
//  Copyright Yummy Melon Software LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumer.h"
#import "AuthorizeWebViewController.h"

#define kConsumerKey @"insert your key here"
#define kConsumerSecret @"insert your secret here"

#define kAppProviderName @"yourdomain.com"
#define kAppPrefix @"twitter_app"


@interface oauthTwitterAppViewController : UIViewController 
<AuthorizeWebViewControllerDelegate>
{
    OAConsumer *consumer;
    OAToken *accessToken;

    UITextField *message;
    UIButton *sendButton;
    UIButton *authenticateButton;
}

@property (nonatomic, retain) OAConsumer *consumer;
@property (nonatomic, retain) OAToken *accessToken;
@property (nonatomic, retain) IBOutlet UITextField *message;
@property (nonatomic, retain) IBOutlet UIButton *sendButton;
@property (nonatomic, retain) IBOutlet UIButton *authenticateButton;

- (IBAction)sendButtonAction;
- (IBAction)authenticateButtonAction;

@end

