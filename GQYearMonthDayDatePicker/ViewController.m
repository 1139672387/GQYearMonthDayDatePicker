//
//  ViewController.m
//  GQYearMonthDayDatePicker
//
//  Created by july on 16/7/5.
//  Copyright © 2016年 july. All rights reserved.
//

#import "ViewController.h"
#import "GQYearMonthDayDatePicker.h"

@interface ViewController ()<GQYearMonthDayDatePickerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIImageView * bagVC = [[UIImageView alloc]initWithFrame:CGRectMake(40, 200, 320, 220)];
    bagVC.image = [UIImage imageNamed:@"rili"];
    bagVC.userInteractionEnabled = YES;
    GQYearMonthDayDatePicker * pickerView = [[GQYearMonthDayDatePicker alloc]initWithFrame:CGRectMake(15, 30, 290, 150)];
    [bagVC addSubview:pickerView];
    
    pickerView.gqdelegate = self;
//    [pickerView selectRow:6 inComponent:1 animated:NO];
//    [pickerView selectRow:8 inComponent:0 animated:NO];
    //[pickerView selectToday];//显示今天日期
    pickerView.rowHeight = 40;
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:bagVC];
}

-(void)yearMonthDayDatePicker:(GQYearMonthDayDatePicker *)yearMonthDatePicker didSectedDate:(NSDate *)date {
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    //[formatter setDateFormat:@"M月"];
    NSLog(@"视图控制器中 %@", [self Formatter:date]);
}

//日期转化为字符串
- (NSString *)Formatter:(NSDate *)data {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:data];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
