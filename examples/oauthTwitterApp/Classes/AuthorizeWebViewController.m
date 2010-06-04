//
//  AuthorizeWebViewController.m
//  oauthTwitterApp
//
//  Created by Charles Choi on 6/3/10.
//  Copyright 2010 Yummy Melon Software LLC. All rights reserved.
//

#import "AuthorizeWebViewController.h"


@implementation AuthorizeWebViewController

@synthesize delegate;
@synthesize webView;
@synthesize doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    //[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES]; 
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];  
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"webView:shouldStartLoadWithRequest:");
    NSLog(@"%@", [request.URL absoluteString]);
          
    

    
          
    
    return YES;
}

- (IBAction)doneButtonAction {
    NSLog(@"doneButtonAction");
    
    NSString *script;
    script = @"(function() { return document.getElementById(\"oauth_pin\").firstChild.textContent; } ())";
    
    NSString *pin = [self.webView stringByEvaluatingJavaScriptFromString:script];
    
    if ([pin length] > 0) {
        NSLog(@"pin %@", pin);
        
        if ([delegate respondsToSelector:@selector(successfulAuthorizationWithPin:)])
            [delegate successfulAuthorizationWithPin:pin];
        
    }
    else {
        NSLog(@"no pin");
        if ([delegate respondsToSelector:@selector(failedAuthorization)])
            [delegate failedAuthorization];
    }

    [self dismissModalViewControllerAnimated:YES];
}


@end
