//
//  OAuthViewController.h
//  MixiOAuth
//
//  Created by Teppei on 11/04/27.
//  Copyright 2011 hybridism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginWebViewController;
@class AccessTokenResponseParser;

@interface OAuthViewController : UIViewController {
    NSString *_client_id;
    NSString *_client_secret;
    NSString *_scope;
    NSString *_display;
    NSString *_redirect_uri;
    
    LoginWebViewController *_login_web_view_controller;
    AccessTokenResponseParser *_atr_parser;
}

// プロパティ
@property (nonatomic, retain) NSString *client_id;
@property (nonatomic, retain) NSString *client_secret;
@property (nonatomic, retain) NSString *scope;
@property (nonatomic, retain) NSString *display;
@property (nonatomic, retain) NSString *redirect_uri;

@end
