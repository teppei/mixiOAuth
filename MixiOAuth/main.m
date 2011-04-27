//
//  main.m
//  MixiOAuth
//
//  Created by Teppei on 11/04/27.
//  Copyright 2011 hybridism.com. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, @"MixiOAuthAppDelegate");
    [pool release];
    return retVal;
}
