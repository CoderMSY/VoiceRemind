//
//  MSYClockView.m
//  VoiceRemind
//
//  Created by Simon Miao on 2022/6/8.
//

#import "MSYClockView.h"
#import "XLFoldClockItem.h"

@interface MSYClockView ()

@property (nonatomic, strong) XLFoldClockItem *hourItem;
@property (nonatomic, strong) XLFoldClockItem *minuteItem;
@property (nonatomic, strong) XLFoldClockItem *secondItem;

@end

@implementation MSYClockView

#pragma mark - lifecycle methods

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.hourItem];
        [self addSubview:self.minuteItem];
        [self addSubview:self.secondItem];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    BOOL isLandscape = [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height;
    if (isLandscape) {
        CGFloat margin = 0.07 * self.bounds.size.width;
        CGFloat itemW = (self.bounds.size.width - 4 * margin) / 3.0f;
        CGFloat itemY = (self.bounds.size.height - itemW) / 2.0f;
        _hourItem.frame = CGRectMake(margin, itemY, itemW, itemW);
        _minuteItem.frame = CGRectMake(CGRectGetMaxX(_hourItem.frame) + margin, itemY, itemW, itemW);
        _secondItem.frame = CGRectMake(CGRectGetMaxX(_minuteItem.frame) + margin, itemY, itemW, itemW);
    } else {
        CGFloat margin = 0.07 * self.bounds.size.height;
        CGFloat itemW = self.bounds.size.width - 2 * margin;
        CGFloat itemY = (self.bounds.size.height - 3 * itemW) / 4.0f;
        _hourItem.frame = CGRectMake(margin, itemY, itemW, itemW);
        _minuteItem.frame = CGRectMake(margin, CGRectGetMaxY(_hourItem.frame) + itemY, itemW, itemW);
        _secondItem.frame = CGRectMake(margin, CGRectGetMaxY(_minuteItem.frame) + itemY, itemW, itemW);
    }
}

#pragma mark - public methods

- (void)setDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    _hourItem.time = dateComponent.hour;
    _minuteItem.time = dateComponent.minute;
    _secondItem.time = dateComponent.second;
}

#pragma mark - private methods

#pragma mark - getter && setter

- (XLFoldClockItem *)hourItem {
    if (!_hourItem) {
        _hourItem = [[XLFoldClockItem alloc] init];
        _hourItem.type = XLClockItemTypeHour;
    }
    return _hourItem;
}

- (XLFoldClockItem *)minuteItem {
    if (!_minuteItem) {
        _minuteItem = [[XLFoldClockItem alloc] init];
        _minuteItem.type = XLClockItemTypeMinute;
    }
    return _minuteItem;
}

- (XLFoldClockItem *)secondItem {
    if (!_secondItem) {
        _secondItem = [[XLFoldClockItem alloc] init];
        _secondItem.type = XLClockItemTypeSecond;
    }
    return _secondItem;
}


@end
