//
//  MSYClockViewController.m
//  VoiceRemind
//
//  Created by Simon Miao on 2022/6/8.
//

#import "MSYClockViewController.h"
#import "MSYClockView.h"

@interface MSYClockViewController ()

@property (nonatomic, strong) MSYClockView *clockView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MSYClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.clockView.frame = self.view.bounds;
    [self.view addSubview:self.clockView];
    
    [self timer];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.clockView.frame = self.view.bounds;
}

#pragma mark - lifecycle methods

#pragma mark - public methods

#pragma mark - private methods

- (void)updateTime:(NSTimer *)timer {
    self.clockView.date = [NSDate date];
}

#pragma mark - getter && setter

- (MSYClockView *)clockView {
    if (!_clockView) {
        _clockView = [[MSYClockView alloc] init];
    }
    return _clockView;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:true];
    }
    return _timer;
}

@end
