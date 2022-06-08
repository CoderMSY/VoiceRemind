//
//  AppDelegate.m
//  VoiceRemind
//
//  Created by Simon Miao on 2022/6/8.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
//#import "SceneDelegate.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //注册通知
    [self registerAPN];
    
    return YES;
}

- (void)registerAPN {

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; //收到推送消息的全部内容
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知");
    }else{
        NSLog(@"title:%@ subtitle:%@ description:%@ body:%@",content.title, content.subtitle, content.description, content.body);
        NSLog(@"ios10 收到本地通知userInfo:%@",content.userInfo);
//        [self waitMultipleUserInfo:content.userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge |
                      UNNotificationPresentationOptionSound
                      );
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    UNNotificationContent *content = response.notification.request.content;
    NSLog(@"title:%@ subtitle:%@ description:%@ body:%@",content.title, content.subtitle, content.description, content.body);
    NSLog(@"userInfo:%@",content.userInfo);
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
