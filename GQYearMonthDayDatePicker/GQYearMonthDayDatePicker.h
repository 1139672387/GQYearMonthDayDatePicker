//
//  GQYearMonthDayDatePicker.h
//  GQYearMonthDayDatePicker
//
//  Created by july on 16/7/5.
//  Copyright © 2016年 july. All rights reserved.

/*
    1.时间选择器, 可以选择 年月 也可以选择 年月日(系统有这个属性)
    2.有点小bug, 就是时间的月份和日期同时快速选择时, 停止时日期会跳到一个随机值.(不同时快速滑动没有问题)
    3.
 
 
*/



#import <UIKit/UIKit.h>
@class GQYearMonthDayDatePicker;

@protocol GQYearMonthDayDatePickerDelegate <NSObject>

-(void)yearMonthDayDatePicker:(GQYearMonthDayDatePicker *)yearMonthDatePicker didSectedDate:(NSDate *)date;

@end

@interface GQYearMonthDayDatePicker : UIPickerView<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id<GQYearMonthDayDatePickerDelegate>gqdelegate;

@property (nonatomic, strong) UIColor *yearbackgroundColor;
@property (nonatomic, strong) UIColor *monthbackgroundColor;

@property (nonatomic, strong) UIColor *daySelectedTextColor;
@property (nonatomic, strong) UIColor *dayTextColor;

@property (nonatomic, strong) UIColor *monthSelectedTextColor;
@property (nonatomic, strong) UIColor *monthTextColor;

@property (nonatomic, strong) UIColor *yearSelectedTextColor;
@property (nonatomic, strong) UIColor *yearTextColor;


@property (nonatomic, strong) UIFont *daySelectedFont;
@property (nonatomic, strong) UIFont *dayFont;

@property (nonatomic, strong) UIFont *monthSelectedFont;
@property (nonatomic, strong) UIFont *monthFont;

@property (nonatomic, strong) UIFont *yearSelectedFont;
@property (nonatomic, strong) UIFont *yearFont;

@property (nonatomic, assign) CGFloat rowWidth;   //显示时间的宽度
@property (nonatomic, assign) NSInteger rowHeight;//显示时间的高度

@property (nonatomic, assign) NSInteger columnNumber;//显示列数(年月或者年月日)(2 = 年月, 3 = 年月日)



/*
 *datePicker 显示当前选择的日期
 */
@property (nonatomic,strong, readonly) NSDate * date;

/*
    datePicker 显示今天日期
 */
-(void)selectToday;
/*
    datePicker 显示date
 */
- (void)selectDate:(NSDate *)date;

/*
    datePicker 设置最小年和最大年份
 */
-(void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear;







@end
