//
//  ViewController.m
//  VoiceRemind
//
//  Created by Simon Miao on 2022/6/8.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "ZBLocalNotification.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self removeAllNotification];
}

- (void)initSubViews {
    UIButton *localNoticeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [localNoticeBtn setTitle:@"添加本地通知" forState:UIControlStateNormal];
    [localNoticeBtn addTarget:self action:@selector(localNoticeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    localNoticeBtn.frame = CGRectMake((self.view.frame.size.width - 150) / 2, 200, 150, 50);
    [self.view addSubview:localNoticeBtn];
    
    UIButton *jumpSettingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [jumpSettingBtn setTitle:@"跳转系统设置页面" forState:UIControlStateNormal];
    [jumpSettingBtn addTarget:self action:@selector(jumpSettingBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    jumpSettingBtn.frame = CGRectMake((self.view.frame.size.width - 150) / 2, CGRectGetMaxY(localNoticeBtn.frame) + 50, 150, 50);
    [self.view addSubview:jumpSettingBtn];
}

- (void)localNoticeBtnClicked:(UIButton *)sender {
//    [self checkUserNotificationEnable];
//    [self addLocalNotice];
    
    NSDate *date = [self getDistanceNextMinuteDateWithMinute:5];
    [ZBLocalNotification createLocalNotificationWithAttribute:
         @{
        ZBNotificationUserInfoName:@"notificationName",
        ZBNotificationSoundName:ZBNotificationSoundAlarm,
        ZBNotificationAlertBody:@"提醒内容",
        ZBNotificationAlertTitle:@"提醒标题",
        ZBNotificationFireDate:date,
        ZBNotificationPriority:@(0),
        ZBNotificationRepeat:@(ZBLocalNotificationRepeatEveryDay),
    }
    ];
                                      
}

- (NSDate *)getDistanceNextMinuteDateWithMinute:(NSInteger)distanceMinute
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *lastHourComps = [[NSDateComponents alloc] init];
    //    [lastMonthComps setYear:1]; // year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
//    [lastHourComps setHour:distanceHours];
//    [lastHourComps setMinute:distanceMinute];
    lastHourComps.second = distanceMinute;
    NSDate *newDate = [calendar dateByAddingComponents:lastHourComps toDate:currentDate options:0];
    
//    NSString *dateStr = [formatter stringFromDate:newdate];
    //    NSLog(@"date str = %@", dateStr);
    return newDate;
}

- (void)jumpSettingBtnClicked:(UIButton *)sender {
    [self goToAppSystemSetting];
}

- (void)addLocalNotice {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        // 标题
        content.title = @"测试标题";
        content.subtitle = @"测试通知副标题";
        // 内容
        content.body = @"测试通知的具体内容";
        content.userInfo = @{
            @"key" : @"123456789",
        };
        // 声音
//        content.sound = [UNNotificationSound defaultSound];
        content.sound = [UNNotificationSound soundNamed:@"Alert_ActivityGoalAttained_Salient_Haptic.caf"];
        // 角标 （我这里测试的角标无效，暂时没找到原因）
        content.badge = @1;
        // 多少秒后发送,可以将固定的日期转化为时间
        NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:10] timeIntervalSinceNow];
//        NSTimeInterval time = 10;
        // repeats，是否重复，如果重复的话时间必须大于60s，要不会报错
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
        
        /*
        //如果想重复可以使用这个,按日期
        // 周一早上 8：00 上班
        NSDateComponents *components = [[NSDateComponents alloc] init];
        // 注意，weekday默认是从周日开始
        components.weekday = 2;
        components.hour = 8;
        UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
        */
        // 添加通知的标识符，可以用于移除，更新等操作
        NSString *identifier = @"noticeId";
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        
        [center addNotificationRequest:request withCompletionHandler:^(NSError *_Nullable error) {
            NSLog(@"成功添加推送");
        }];
    }else {
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        // 发出推送的日期
        notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        // 推送的内容
        notif.alertBody = @"你已经10秒没出现了";
        // 可以添加特定信息
        notif.userInfo = @{@"noticeId":@"00001"};
        // 角标
        notif.applicationIconBadgeNumber = 1;
        // 提示音
        notif.soundName = UILocalNotificationDefaultSoundName;
        // 每周循环提醒
        notif.repeatInterval = NSCalendarUnitWeekOfYear;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
}

// 移除某一个指定的通知
- (void)removeOneNotificationWithID:(NSString *)noticeId {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getPendingNotificationRequestsWithCompletionHandler:^(NSArray<UNNotificationRequest *> * _Nonnull requests) {
            for (UNNotificationRequest *req in requests){
                NSLog(@"存在的ID:%@\n",req.identifier);
            }
            NSLog(@"移除currentID:%@",noticeId);
        }];
        
        [center removePendingNotificationRequestsWithIdentifiers:@[noticeId]];
    }else {
        NSArray *array=[[UIApplication sharedApplication] scheduledLocalNotifications];
        for (UILocalNotification *localNotification in array){
            NSDictionary *userInfo = localNotification.userInfo;
            NSString *obj = [userInfo objectForKey:@"noticeId"];
            if ([obj isEqualToString:noticeId]) {
                [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
            }
        }
    }
}

// 移除所有通知
- (void)removeAllNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllPendingNotificationRequests];
    }else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (void)checkUserNotificationEnable { // 判断用户是否允许接收通知
    if (@available(iOS 10.0, *)) {
        __block BOOL isOn = NO;
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.notificationCenterSetting == UNNotificationSettingEnabled) {
                isOn = YES;
                NSLog(@"打开了通知");
            }else {
                isOn = NO;
                NSLog(@"关闭了通知");
               [self showAlertView];
            }
        }];
    }else {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone){
            NSLog(@"关闭了通知");
            [self showAlertView];
        }else {
            NSLog(@"打开了通知");
        }
    }
}

- (void)showAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:@"未获得通知权限，请前去设置" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self goToAppSystemSetting];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改
- (void)goToAppSystemSetting {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [application openURL:url options:@{} completionHandler:nil];
                }
            }else {
                [application openURL:url];
            }
        }
    });
}
@end
