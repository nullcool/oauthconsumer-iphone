/**
 Copyright 2010 Charles Y. Choi, Yummy Melon Software LLC
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */ 

#import "oauthTwitterAppViewController.h"

@implementation oauthTwitterAppViewController

@synthesize consumer;
@synthesize accessToken;
@synthesize message;
@synthesize sendButton;
@synthesize authenticateButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.consumer == nil)
        self.consumer = [[OAConsumer alloc] initWithKey:kConsumerKey
                                                 secret:kConsumerSecret];
    
    self.accessToken = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:kAppProviderName 
                                                                              prefix:kAppPrefix];
    
    if (self.accessToken != nil)
        self.authenticateButton.titleLabel.text = @"Reauthenticate";
    else
        self.authenticateButton.titleLabel.text = @"Authenticate";

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    self.message = nil;
    self.sendButton = nil;
    self.authenticateButton = nil;
}


- (void)dealloc {
    [message release];
    [sendButton release];
    [authenticateButton release];
    [super dealloc];
}

- (IBAction)sendButtonAction {
    NSLog(@"sendButtonAction");
    
    if (self.accessToken != nil) {
        OAMutableURLRequest *request;
        OADataFetcher *fetcher;
        NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"];
        
        request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                   consumer:self.consumer
                                                      token:self.accessToken
                                                      realm:nil
                                          signatureProvider:nil] autorelease];
        
        [request setHTTPMethod:@"POST"];
        
        OARequestParameter *x1 = [[OARequestParameter alloc] initWithName:@"status" value:self.message.text];
        
        NSArray *params = [NSArray arrayWithObjects:x1, nil];
        [request setParameters:params];
        
        
        fetcher = [[[OADataFetcher alloc] init] autorelease];
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(statusRequestTokenTicket:didFinishWithData:)
                      didFailSelector:@selector(statusRequestTokenTicket:didFailWithError:)];
        
        [x1 release];
    }
    
}

- (IBAction)authenticateButtonAction {
    NSLog(@"authenticateButtonAction");
    OAMutableURLRequest *request;
    OADataFetcher *fetcher;
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
        
    request = [[[OAMutableURLRequest alloc] initWithURL:url
                                               consumer:self.consumer
                                                  token:nil
                                                  realm:nil
                                      signatureProvider:nil] autorelease];
    
    [request setHTTPMethod:@"POST"];
    

    OARequestParameter *p0 = [[OARequestParameter alloc] initWithName:@"oauth_callback" value:@"oob"];
    
    NSArray *params = [NSArray arrayWithObject:p0];
    [request setParameters:params];

    fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
    
    [p0 release];

}


- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    
    if (ticket.didSucceed) {
        OAMutableURLRequest *request;
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        if (self.accessToken != nil) {
            [self.accessToken release];
            self.accessToken = nil;
        }
        
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        [responseBody release];
        
        NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
        
        request = [[[OAMutableURLRequest alloc] initWithURL:url
                                                   consumer:self.consumer
                                                      token:self.accessToken
                                                      realm:nil
                                          signatureProvider:nil] autorelease];
        
        
        OARequestParameter *p0 = [[OARequestParameter alloc] initWithName:@"oauth_token"
                                                                    value:self.accessToken.key];
        NSArray *params = [NSArray arrayWithObject:p0];
        [request setParameters:params];
        //[request prepare];

        AuthorizeWebViewController *vc;
        vc = [[AuthorizeWebViewController alloc] initWithNibName:@"AuthorizeWebViewController" bundle:nil];
        vc.delegate = self;
        [self presentModalViewController:vc animated:YES];
        [vc.webView loadRequest:request];
        
        [vc release];
        [p0 release];
    }
    else {
        
    }

        
}


- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

#pragma mark AuthorizeWebViewControllerDelegate Methods

- (void)successfulAuthorizationWithPin:(NSString *)pin {
    NSLog(@"successfulAuthorizationWithPin:%@", pin);
    OAMutableURLRequest *request;
    OADataFetcher *fetcher;
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
    
    request = [[[OAMutableURLRequest alloc] initWithURL:url
                                               consumer:self.consumer
                                                  token:self.accessToken
                                                  realm:nil
                                      signatureProvider:nil] autorelease];
    
    
    OARequestParameter *p0 = [[OARequestParameter alloc] initWithName:@"oauth_token"
                                                                value:self.accessToken.key];
    OARequestParameter *p1 = [[OARequestParameter alloc] initWithName:@"oauth_verifier"
                                                                value:pin];
    NSArray *params = [NSArray arrayWithObjects:p0, p1, nil];
    [request setParameters:params];
    
    fetcher = [[[OADataFetcher alloc] init] autorelease];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
    
    [p0 release];
    [p1 release];
     
    
    
    
}

- (void)failedAuthorization {
    NSLog(@"failedAuthorization");
}



- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSLog(@"accessTokenSuccess");
        
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        
        if (self.accessToken != nil) {
            [self.accessToken release];
            self.accessToken = nil;
        }
        
        self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        [responseBody release];
        
        [self.accessToken storeInUserDefaultsWithServiceProviderName:kAppProviderName
                                                              prefix:kAppPrefix];
        

    }
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}


- (void)statusRequestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
    if (ticket.didSucceed) {
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        NSLog(@"%@", responseBody);
    }    
    
}



- (void)statusRequestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
    
}


@end
