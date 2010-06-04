//
//  AuthorizeWebViewController.h
//  oauthTwitterApp
//
//  Created by Charles Choi on 6/3/10.
//  Copyright 2010 Yummy Melon Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AuthorizeWebViewControllerDelegate <NSObject>
@optional
- (void)successfulAuthorizationWithPin:(NSString *)pin;
- (void)failedAuthorization;
@end


@interface AuthorizeWebViewController : UIViewController 
<UIWebViewDelegate>
{
    id <AuthorizeWebViewControllerDelegate> delegate;
    UIWebView *webView;
    UIBarButtonItem *doneButton;
}

@property (nonatomic, retain) id <AuthorizeWebViewControllerDelegate> delegate;  
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

- (IBAction)doneButtonAction;

@end
