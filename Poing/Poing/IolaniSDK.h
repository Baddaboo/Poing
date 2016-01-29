//
//  IolaniSDK.h
//  Iolani
//
//  Created by David Blake Tsuzaki on 1/28/16.
//  Copyright © 2016 'Iolani School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IolaniConst.h"
@protocol IolaniNotificationDelegate <NSObject>
@required
@optional
- (void)pushNotificationReceivedWithUserInfo:(NSDictionary *)userInfo;
@end
@interface IolaniSDK : NSObject
+ (id)sharedInstance;
- (BOOL)ensureInit;
/**
 *  @brief Boilerplate functions that must be implemented in the App's AppDelegate
 */
- (void)initializeAnalyticsWithOptions:(NSDictionary *)options;
- (void)registerPushNotificatinsWithDeviceToken:(NSData *)deviceToken;
/**
 *  @brief Implement an action triggered by a push notification
 */
- (void)handlePushWithUserInfo:(NSDictionary *)userInfo;
@property (weak, nonatomic) id<IolaniNotificationDelegate> notificationDelegate;

@end
