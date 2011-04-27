//
//  OAuthViewController.m
//  MixiOAuth
//
//  Created by Teppei on 11/04/27.
//  Copyright 2011 hybridism.com. All rights reserved.
//

#import "OAuthViewController.h"
#import "LoginWebViewController.h"
#import "AccessTokenResponseParser.h"

#define MIXI_LOGIN_URI @"https://mixi.jp/connect_authorize.pl"

@implementation OAuthViewController

// プロパティ
@synthesize client_id = _client_id;
@synthesize client_secret = _client_secret;
@synthesize scope = _scope;
@synthesize display = _display;
@synthesize redirect_uri = _redirect_uri;

//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)dealloc
{
    [_client_id release], _client_id = nil;
    [_client_secret release], _client_secret = nil;
    [_scope release], _scope = nil;
    [_display release], _display = nil;
    [_redirect_uri release], _redirect_uri = nil;
    
    [_login_web_view_controller release], _login_web_view_controller = nil;
    [_atr_parser release], _atr_parser = nil;

    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//--------------------------------------------------------------//
#pragma mark -- ビュー --
//--------------------------------------------------------------//

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"mixiにOAuth認証" forState:UIControlStateNormal];
    [button sizeToFit];
    button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [button addTarget:self action:@selector(modalButtonDidPush:) forControlEvents:UIControlEventTouchUpInside];
    
    button.center = self.view.center;
    [self.view addSubview:button];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//--------------------------------------------------------------//
#pragma mark -- Action --
//--------------------------------------------------------------//

- (void)modalButtonDidPush:(id)sender
{
    NSString *uri = 
    [NSString stringWithFormat:@"%@?client_id=%@&response_type=code&scope=%@&display=%@",
     MIXI_LOGIN_URI, _client_id, _scope, _display];
    
    NSLog(@"uri = %@", uri);
    
    _login_web_view_controller = [[LoginWebViewController alloc] init];
    _login_web_view_controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _login_web_view_controller.authorize_uri = uri;
    _login_web_view_controller.response_uri = _redirect_uri;
    _login_web_view_controller.delegate = self;
    
    [self presentModalViewController:_login_web_view_controller animated:YES];
}

//--------------------------------------------------------------//
#pragma mark -- LoginWebViewControllerDelegate --
//--------------------------------------------------------------//

- (void)parse_authorization_code:(NSString *)authorization_code
{
    NSLog(@"authcode = %@", authorization_code);
    
    [self dismissModalViewControllerAnimated:YES];
    [_login_web_view_controller release], _login_web_view_controller = nil;

    
    [_atr_parser release], _atr_parser = nil;
    _atr_parser = [[AccessTokenResponseParser alloc] init];
    
    _atr_parser.client_id = _client_id;
    _atr_parser.client_secret = _client_secret;
    _atr_parser.code = authorization_code;
    _atr_parser.redirect_uri = _redirect_uri;
    _atr_parser.delegate = self;
    
    [_atr_parser parse];
}

//--------------------------------------------------------------//
#pragma mark -- AccessTokenResponseParserDelegate --
//--------------------------------------------------------------//

- (void)parser:(AccessTokenResponseParser*)parser didReceiveResponse:(NSURLResponse*)response
{
    
}

- (void)parser:(AccessTokenResponseParser*)parser didReceiveData:(NSData*)data
{
    
}

- (void)parserDidFinishLoading:(AccessTokenResponseParser*)parser
{
    NSLog(@"%@", [parser.tokens description]);
}

- (void)parser:(AccessTokenResponseParser*)parser didFailWithError:(NSError*)error
{
    
}

- (void)parserDidCancel:(AccessTokenResponseParser*)parser
{
    
}

@end
