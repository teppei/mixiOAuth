//
//  LoginWebViewController.h
//  MixiOAuth
//
//  Created by Teppei on 11/04/27.
//  Copyright 2011 hybridism.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginWebViewController : UIViewController <UIWebViewDelegate>{
    NSString *_authorize_uri;
    NSString *_response_uri;
    UIWebView *_web_view;
    
    id _delegate; // assing    
}

// プロパティ
@property (nonatomic, retain) NSString *authorize_uri;
@property (nonatomic, retain) NSString *response_uri;
@property (nonatomic, assign) id delegate;

@end

// デリゲートメソッド
@interface NSObject (LoginWebViewControllerDelegate)

- (void)parse_authorization_code:(NSString *)authorization_code;

@end
