//
//  KWBaseClient.m
//  KwarterSDK
//
//  Created by Ludovic Landry on 25/11/12.
//  Copyright (c) 2012 Ludovic Landry. All rights reserved.
//

#import "KWBaseAuthClient.h"
#import "KWCredentialManager.h"
#import "NSDictionary+URLQueryString.h"

NSString *const KWClientErrorDomain = @"com.kwarter.KWClientErrorDomain";
NSString *const KWClientErrorMissingParameterKey = @"com.kwarter.MissingParameter";
NSInteger const KWClientErrorMissingParameterError = 1;
NSString *const KWClientErrorInvalidParameterKey = @"com.kwarter.InvalidParameter";
NSInteger const KWClientErrorInvalidParameterError = 2;
NSString *const KWClientErrorNeedsAccessTokenKey = @"com.kwarter.NeedsAccessTokenKey";
NSInteger const KWClientErrorNeedsAuthenticationTokenError = 3;
NSString *const KWClientErrorNeedsUserIdentifierKey = @"com.kwarter.NeedsUserIdentifier";
NSInteger const KWClientErrorNeedsUserIdentifierError = 4;
NSString *const KWClientErrorNeedsSecretKey = @"com.kwarter.NeedsSecret";
NSInteger const KWClientErrorNeedsSecretError = 5;

@interface KWBaseAuthClient ()
- (void)setAuthTokenHeader;
- (void)tokenChanged:(NSNotification *)notification;
@end

@implementation KWBaseAuthClient

+ (KWBaseAuthClient *)sharedClient {
    static KWBaseAuthClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *hostname = @"http://api.tahoe.kwarter.com/"; //@"http://192.168.1.100:8081/"; //TODO: move that to an environment management
        NSURL *baseUrl = [NSURL URLWithString:hostname];
        _sharedClient = [[self alloc] initWithBaseURL:baseUrl];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Accept-Encoding" value:@"gzip"];
        [self setParameterEncoding:AFJSONParameterEncoding];
        
        [self setAuthTokenHeader];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenChanged:)
                                                     name:@"token-changed" object:nil];
    }
    return self;
}

- (void)setAuthTokenHeader {
    NSString *accessToken = [KWCredentialManager sharedManager].accessToken;
    [self setDefaultHeader:@"access_token" value:accessToken];
}

- (void)tokenChanged:(NSNotification *)notification {
    [self setAuthTokenHeader];
}

#pragma mark - Authenticate Endpoints

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method
                                      path:(NSString *)path
                                parameters:(NSDictionary *)parameters {
    
    path = [self pathWithAuthentication:path];
    return [super requestWithMethod:method path:path parameters:parameters];
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                                   path:(NSString *)path
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {
    
    path = [self pathWithAuthentication:path];
    return [super multipartFormRequestWithMethod:method path:path parameters:parameters constructingBodyWithBlock:block];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
	
    path = [self pathWithAuthentication:path];
    [super postPath:path parameters:parameters success:success failure:failure];
}

- (NSString *)pathWithAuthentication:(NSString *)path {
    NSString *clientId = nil; //TODO: start with client id later on [Tahoe sharedInstance].clientId;
    NSString *accessToken = [KWCredentialManager sharedManager].accessToken;
    
    if (clientId || accessToken) {
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        if (clientId && [path rangeOfString:@"client_id"].location == NSNotFound) {
            [parameters setObject:clientId forKey:@"client_id"];
        }
        if (accessToken && [path rangeOfString:@"access_token"].location == NSNotFound) {
            [parameters setObject:accessToken forKey:@"access_token"];
        }
        if ([parameters count] > 0) {
            NSString *concatSymbol = ([path rangeOfString:@"?"].location == NSNotFound) ? @"?" : @"&";
            return [NSString stringWithFormat:@"%@%@%@", path, concatSymbol, [parameters URLQueryStringUsingPlusSignForSpaces:NO]];
        }
    }
    return path;
}

@end
