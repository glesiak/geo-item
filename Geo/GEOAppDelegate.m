//
//  RTAppDelegate.m
//  Recruitment Task
//
//  Created by glesiak on 21/07/14.
//

#import "GEOAppDelegate.h"

@interface GEOAppDelegate ()

@property (nonatomic,assign) BOOL reachabilityStatus;
@property (nonatomic,strong) AFHTTPClient *httpClient;

@end

@implementation GEOAppDelegate

#pragma mark Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupReachability];
    [self setupRestkit];
    [self setupInterface];
    return YES;
}

#pragma mark Application Setup

- (void) setupReachability
{
    self.httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://google.com"]];
    __weak GEOAppDelegate * weakSelf = self;
    [self.httpClient setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status)
     {
         switch ( status )
         {
             case AFNetworkReachabilityStatusReachableViaWiFi:
             case AFNetworkReachabilityStatusReachableViaWWAN:
             {
                 DLog( @"Network is reachable" );
                 weakSelf.reachabilityStatus = ReachabilityAvailable;
                 break;
             }
             case AFNetworkReachabilityStatusNotReachable:
             case AFNetworkReachabilityStatusUnknown:
             default:
             {
                 DLog( @"Network is not reachable" );
                 weakSelf.reachabilityStatus = ReachabilityUnavailable;
                 [[[UIAlertView alloc] initWithTitle: @"Warning"
                                             message: @"Network is not reachable."
                                            delegate: nil cancelButtonTitle: @"Ok" otherButtonTitles: nil] show];
                 break;
             }
         }
         [[NSNotificationCenter defaultCenter] postNotificationName: @"ReachabilityUpdate" object: weakSelf
                                                           userInfo: @{ @"status" : [NSNumber numberWithInteger: weakSelf.reachabilityStatus] } ];
     }];
}

- (void) setupRestkit
{
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
}

- (void) setupInterface
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
}

@end
