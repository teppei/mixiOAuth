//
//  MixiOAuthAppDelegate.h
//  MixiOAuth
//
//  Created by Teppei on 11/04/27.
//  Copyright 2011 hybridism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OAuthViewController;

@interface MixiOAuthAppDelegate : NSObject <UIApplicationDelegate> {
    OAuthViewController *_oauth_view_controller;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
