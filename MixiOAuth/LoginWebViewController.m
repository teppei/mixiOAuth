//
//  LoginWebViewController.m
//  MixiOAuth
//
//  Created by Teppei on 11/04/27.
//  Copyright 2011 hybridism.com. All rights reserved.
//

#import "LoginWebViewController.h"

@implementation LoginWebViewController

// プロパティ
@synthesize authorize_uri = _authorize_uri;
@synthesize response_uri = _response_uri;
@synthesize delegate = _delegate;

//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_authorize_uri release], _authorize_uri = nil;
    [_response_uri release], _response_uri = nil;
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

    _web_view = [[UIWebView alloc] initWithFrame:[self.view bounds]];
    _web_view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _web_view.scalesPageToFit = YES;
    _web_view.delegate = self;
    
    [self.view addSubview:_web_view];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://mixi.jp/connect_authorize.pl?client_id=f6be39eb782331b6aefd&response_type=code&scope=r_voice&display=smartphone&state=first"]];
    
    [_web_view loadRequest:request];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

    _web_view.delegate = nil;
    [_web_view release], _web_view = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//--------------------------------------------------------------//
#pragma mark -- UIWebViewDelegate --
//--------------------------------------------------------------//

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString* urlstring = [webView stringByEvaluatingJavaScriptFromString:@"document.URL"];
    
    NSRange search_result = [urlstring rangeOfString:_response_uri];
    
    if (search_result.location != NSNotFound) {
        NSArray* components = [urlstring componentsSeparatedByString:@"?"];
        
        if ([components count] > 1) {
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            for (NSString *query in [[components lastObject] componentsSeparatedByString:@"&"]) {
                
                NSArray *keyAndValues = [query componentsSeparatedByString:@"="];
                [parameters setObject:[keyAndValues objectAtIndex:1] forKey:[keyAndValues objectAtIndex:0]];
            }
            
            if ([parameters valueForKey:@"code"]) {
                
                // デリゲートに通知
                if ([_delegate respondsToSelector:@selector(parse_authorization_code:)]) {
                    [_delegate parse_authorization_code:[parameters valueForKey:@"code"]];
                }
            }
            
        }
    }
}
@end
