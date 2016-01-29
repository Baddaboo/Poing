//
//  PoingSDK.m
//  Poing
//
//  Created by David Blake Tsuzaki on 1/28/16.
//  Copyright © 2016 'Iolani School. All rights reserved.
//

#import "IolaniSDK.h"
#import "Backendless.h"
#import <Parse/Parse.h>
#import <ParseCrashReporting/ParseCrashReporting.h>

@implementation IolaniSDK
+ (id)sharedInstance{
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[IolaniSDK alloc] init];
    });
    return _sharedObject;
}
- (id)init{
    self = [super init];
#ifdef IOLANI_PARSE_ENABLED
    [ParseCrashReporting enable];
    [Parse setApplicationId:@"BFr7sOFOHuNT4jZxebO8o6xOoCZnEqkZwp79P2Ns"
                  clientKey:@"fMfKdKCIrEhwNmD1pIo6wRihYdXNg4em3BptnpfG"];
#endif
#ifdef IOLANI_BACKENDLESS_ENABLED
    [backendless initApp:BACKENDLESS_APP_ID
                  secret:BACKENDLESS_CLIENT_SECRET
                 version:POING_API_VER];
#endif
    return self;
}
- (BOOL)ensureInit{
    return YES;
}
- (void)initializeAnalyticsWithOptions:(NSDictionary *)options{
#ifdef IOLANI_PARSE_ENABLED
    [PFAnalytics trackAppOpenedWithLaunchOptions:options];
#endif
}
- (void)registerPushNotificatinsWithDeviceToken:(NSData *)deviceToken{
#ifdef IOLANI_PARSE_ENABLED
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[@"global",@"production"];
    [currentInstallation saveInBackground];
#endif
#ifdef IOLANI_BACKENDLESS_ENABLED
    NSString *tokenStr = [[backendless messagingService] deviceTokenAsString:deviceToken];
    [[backendless messagingService] registerDeviceToken:tokenStr];
#endif
}
- (void)handlePushWithUserInfo:(NSDictionary *)userInfo{
#ifdef IOLANI_PARSE_ENABLED
    [PFPush handlePush:userInfo];
#endif
    if ([[self notificationDelegate] respondsToSelector:@selector(pushNotificationReceivedWithUserInfo:)])
        [[self notificationDelegate] pushNotificationReceivedWithUserInfo:userInfo];
}
@end
