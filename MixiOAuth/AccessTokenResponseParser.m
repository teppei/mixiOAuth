//
//  AccessTokenResponseParser.m
//  MixiOAuth
//
//  Created by Teppei on 11/04/27.
//  Copyright 2011 hybridism.com. All rights reserved.
//

#import "AccessTokenResponseParser.h"
#import "JSON.h"

#define MIXI_TOKEN_URL @"https://secure.mixi-platform.com/2/token"

@implementation AccessTokenResponseParser

// プロパティ
@synthesize client_id = _client_id;
@synthesize client_secret = _client_secret;
@synthesize code = _code;
@synthesize redirect_uri = _redirect_uri;

@synthesize network_state = _network_state;
@synthesize download_data = _download_data;
@synthesize error = _error;

@synthesize tokens = _tokens;

@synthesize delegate = _delegate; // assign

//--------------------------------------------------------------//
#pragma mark -- 初期化 --
//--------------------------------------------------------------//

- (id)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _network_state = ATRPNetworkStateNotConnected;
    
    return self;
}

- (void)dealloc
{
    [_client_id release], _client_id = nil;
    [_client_secret release], _client_secret = nil;
    [_code release], _code = nil;
    [_redirect_uri release], _redirect_uri = nil;
    
    [_connection release], _connection = nil;
    [_download_data release], _download_data = nil;
    [_error release], _error = nil;
    
    _delegate = nil;

    [super dealloc];
}

//--------------------------------------------------------------//
#pragma mark -- パース --
//--------------------------------------------------------------//

- (void)parse
{
    NSMutableURLRequest *request = 
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:MIXI_TOKEN_URL]];
    
    //POST
    NSString *params = 
    [NSString stringWithFormat:@"grant_type=authorization_code&client_id=%@&client_secret=%@&code=%@&redirect_uri=%@",
     _client_id, _client_secret, _code, _redirect_uri];
    
    NSData *post_data = [params dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:post_data];    
    
    [_download_data release], _download_data = nil;
    _download_data = [[NSMutableData data] retain];
    
    _connection = [[NSURLConnection connectionWithRequest:request delegate:self] retain];
    
    _network_state = ATRPNetworkStateInProgress;
}

//--------------------------------------------------------------//
#pragma mark -- NSURLConnectionDelegate --
//--------------------------------------------------------------//

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    // デリゲートに通知
    if ([_delegate respondsToSelector:@selector(parser:didReceiveResponse:)]) {
        [_delegate parser:self didReceiveResponse:response];
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    // ダウンロード済みデータを追加
    [_download_data appendData:data];
    
    // デリゲートに通知
    if ([_delegate respondsToSelector:@selector(parser:didReceiveData:)]) {
        [_delegate parser:self didReceiveData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    _network_state = ATRPNetworkStateFinished;
    
    NSString *data = [[NSString alloc] initWithData:_download_data encoding:NSUTF8StringEncoding];
    
    [_tokens release], _tokens = nil;    
    _tokens = [[data JSONValue] retain];;
    
    [data autorelease];
    
    // NSURLConnectionオブジェクトを解放
    [_connection release], _connection = nil;

    // デリゲートに通知
    if ([_delegate respondsToSelector:@selector(parserDidFinishLoading:)]) {
        [_delegate parserDidFinishLoading:self];
    }
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    // エラーオブジェクトの設定
    [_error release], _error = nil;
    _error = [error retain];
    
    // ネットワークアクセス状態の設定
    _network_state = ATRPNetworkStateError;
    
    // デリゲートに通知
    if ([_delegate respondsToSelector:@selector(parser:didFailWithError:)]) {
        [_delegate parser:self didFailWithError:error];
    }
    
    // NSURLConnectionオブジェクトを解放
    [_connection release], _connection = nil;
}

@end
