//
//  AccessTokenResponseParser.h
//  MixiOAuth
//
//  Created by Teppei on 11/04/27.
//  Copyright 2011 hybridism.com. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    ATRPNetworkStateNotConnected = 0, 
    ATRPNetworkStateInProgress, 
    ATRPNetworkStateFinished, 
    ATRPNetworkStateError,
    ATRPNetworkStateCanceled, 
};

@interface AccessTokenResponseParser : NSObject {
    NSString *_client_id;
    NSString *_client_secret;
    NSString *_code;
    NSString *_redirect_uri;
    
    int _network_state;
    NSURLConnection *_connection;
    NSMutableData *_download_data;
    NSError* _error;
    
    NSDictionary *_tokens;
    
    id _delegate; // Assign
}

@property (nonatomic, retain) NSString *client_id;
@property (nonatomic, retain) NSString *client_secret;
@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *redirect_uri;

@property (nonatomic, readonly) int network_state;
@property (nonatomic, readonly) NSMutableData *download_data;
@property (nonatomic, readonly) NSError *error;
@property (nonatomic, readonly) NSDictionary *tokens;

@property (nonatomic, assign) id delegate;

// パース
- (void)parse;

@end

// デリゲートメソッド
@interface NSObject (AccessTokenResponseParserDelegate)

- (void)parser:(AccessTokenResponseParser*)parser didReceiveResponse:(NSURLResponse*)response;
- (void)parser:(AccessTokenResponseParser*)parser didReceiveData:(NSData*)data;
- (void)parserDidFinishLoading:(AccessTokenResponseParser*)parser;
- (void)parser:(AccessTokenResponseParser*)parser didFailWithError:(NSError*)error;
- (void)parserDidCancel:(AccessTokenResponseParser*)parser;

@end
