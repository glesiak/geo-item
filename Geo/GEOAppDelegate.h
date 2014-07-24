//
//  RTAppDelegate.h
//  Recruitment Task
//
//  Created by glesiak on 21/07/14.
//

#import <UIKit/UIKit.h>

#define ReachabilityAvailable 0
#define ReachabilityUnavailable 1

@interface GEOAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,readonly,assign) BOOL reachabilityStatus;

@end
