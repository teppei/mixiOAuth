//
//  MixiOAuthAppDelegate.m
//  MixiOAuth
//
//  Created by Teppei on 11/04/27.
//  Copyright 2011 hybridism.com. All rights reserved.
//

#import "MixiOAuthAppDelegate.h"
#import "OAuthViewController.h"

@implementation MixiOAuthAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    CGRect bounds = [[UIScreen mainScreen] bounds];
    _window = [[UIWindow alloc]initWithFrame:bounds];
    
    _oauth_view_controller = [[OAuthViewController alloc] init];
    
    // Consumer Key
    _oauth_view_controller.client_id = @"";
    // Consumer secret
    _oauth_view_controller.client_secret = @"";
    // 認可したいスコープ
    _oauth_view_controller.scope = @"";
    // デバイス
    _oauth_view_controller.display = @"";
    // リダイレクト先
    _oauth_view_controller.redirect_uri = @"";
    
    [_window addSubview:_oauth_view_controller.view];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_oauth_view_controller release], _oauth_view_controller = nil;
    [_window release];
    [super dealloc];
}

@end
