//
//  GQYearMonthDayDatePicker.m
//  GQYearMonthDayDatePicker
//
//  Created by july on 16/7/5.
//  Copyright © 2016年 july. All rights reserved.
//

#import "GQYearMonthDayDatePicker.h"


// Identifiers of components
#define MONTH ( 1 )
#define YEAR ( 0 )
#define DAY (2)


// Identifies for component views
#define LABEL_TAG 43


#define kScreenWidth   ([UIScreen mainScreen].bounds.size.width /414)

@interface GQYearMonthDayDatePicker ()
@property (nonatomic, strong) NSIndexPath *todayIndexPath;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;
@property (nonatomic, strong) NSArray * days;

@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;

@property (nonatomic, copy) NSString * yearStr;//年
@property (nonatomic, copy) NSString * monthStr;//月
@property (nonatomic, copy) NSString * dayStr;//日

@property (nonatomic, copy) NSString * currentYearStr;//时间轴当前年
@property (nonatomic, copy) NSString * currentMonthStr;//时间轴当前月
@property (nonatomic, copy) NSString * currentDayStr;//时间轴当前日

@property (nonatomic, copy) NSString * fixedDay;

@property (nonatomic) BOOL seclect;

@end


const NSInteger bigRowCount = 1000;
const NSInteger numberOfComponents = 2;

@implementation GQYearMonthDayDatePicker

#pragma mark - Init

-(instancetype)init
{
    if (self = [super init])
    {
        [self loadDefaultsParameters];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self loadDefaultsParameters];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self loadDefaultsParameters];
}



-(void)loadDefaultsParameters
{
    self.minYear = 2008;
    self.maxYear = 2030;
    self.rowHeight = 80;
    self.seclect = YES;
    self.columnNumber= 3;
    self.fixedDay = [self currentDayName];
    
    self.months = [self nameOfMonths];
    self.years = [self nameOfYears];
    self.days = [self nameOfDays];
    
    
    
    self.delegate = self;
    self.dataSource = self;
    
    [self selectToday];
    self.monthbackgroundColor = [UIColor cyanColor];
    self.yearbackgroundColor = [UIColor greenColor];
    
    self.monthSelectedTextColor = [UIColor blackColor];
    self.monthTextColor = [UIColor redColor];
    
    self.yearSelectedTextColor = [UIColor blackColor];
    self.yearTextColor = [UIColor blueColor];
    
    self.monthSelectedFont = [UIFont systemFontOfSize:17];
    self.monthFont = [UIFont systemFontOfSize:17];
    
    self.yearSelectedFont = [UIFont systemFontOfSize:17];
    self.yearFont = [UIFont systemFontOfSize:17];
    

}



#pragma mark -- system  methods

- (void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear
{
    self.minYear = minYear;
    
    if (maxYear > minYear)
    {
        self.maxYear = maxYear;
    }
    else
    {
        self.maxYear = minYear + 10;
    }
    
    self.years = [self nameOfYears];

}



-(NSString *)currentYearName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年"];
    return [formatter stringFromDate:[NSDate date]];
}

-(NSString *)currentMonthName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"M月"];
    return [formatter stringFromDate:[NSDate date]];
}
-(NSString *)currentDayName
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setLocale:usLocale];
    [formatter setDateFormat:@"dd日"];
    return [formatter stringFromDate:[NSDate date]];
}

#pragma mark =-  ---********
//日期转化为字符串
- (NSString *)Formatter:(NSDate *)data {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:data];
}

-(NSDate *)dateYearMonth
{
    
    
    NSInteger yearCount = self.years.count;
    self.currentYearStr = [self.years objectAtIndex:([self selectedRowInComponent:YEAR] % yearCount)];
    NSInteger monthCount = self.months.count;
    self.currentMonthStr = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy年M月"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@%@", self.currentYearStr, self.currentMonthStr]];
    return date;
}
-(NSDate *)date
{

    
    NSInteger yearCount = self.years.count;
    NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR] % yearCount)];
    NSInteger monthCount = self.months.count;
    NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
    

    
    NSDateFormatter *formatter = [NSDateFormatter new];
    if (self.columnNumber == 3) {
        NSInteger dayCount = [self nameOfDays].count;
        NSString *day = [[self nameOfDays] objectAtIndex:([self selectedRowInComponent:DAY] % dayCount)];
        [formatter setDateFormat:@"yyyy年M月dd日"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@%@%@", year, month, day]];
        return date;
    }
    [formatter setDateFormat:@"yyyy年M月"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@%@", year, month]];
    return date;
}

-(void)selectToday
{
    
    //当前日期的年月日
    NSDate * senddate = [NSDate date];
    NSString * strUrl = [self Formatter:senddate];
    NSArray *array = [strUrl componentsSeparatedByString:@"-"];
    self.yearStr = [NSString stringWithFormat:@"%@年", array[0]];
    NSString * tempStr = [array[1] stringByReplacingOccurrencesOfString:@"0" withString:@""];
    self.monthStr = [NSString stringWithFormat:@"%@月", tempStr];
    
    NSString * dayStr = [array[2] stringByReplacingOccurrencesOfString:@"0" withString:@""];
    self.dayStr = [NSString stringWithFormat:@"%@日", dayStr];
    CGFloat yearRow = 0.1f;
    CGFloat monthRow = 0.1f;
    CGFloat dayRow = 0.1f;
    for (NSString * yearString in self.years) {
        if ([yearString isEqualToString:self.yearStr]) {
            yearRow = [self .years indexOfObject:self.yearStr];
            yearRow = yearRow + self.years.count*100 / 2;
        }
    }
    for (NSString * monthString in self.months) {
        if ([monthString isEqualToString:self.monthStr]) {
            monthRow = [self .months indexOfObject:self.monthStr];
            monthRow = monthRow + self.months.count*100 / 2;
        }
    }

    
    //设置默认日期 为 当前日期
    [self selectRow:monthRow inComponent:1 animated:NO];
    [self selectRow:yearRow inComponent:0 animated:NO];
    if (self.columnNumber == 3) {
        for (NSString * dayString in [self nameOfDays]) {
            if ([dayString isEqualToString:self.dayStr]) {
                dayRow = [[self nameOfDays] indexOfObject:self.dayStr];
                dayRow = dayRow + [self nameOfDays].count*100 / 2;
            }
        }
        [self selectRow:dayRow inComponent:2 animated:NO];
    }
    
    

    
}

//返回月份对应的天数
- (NSArray *)returnDays:(NSInteger)dayNumber {
    NSMutableArray * days = [NSMutableArray array];
    for (NSInteger day = 1; day <= dayNumber; day++) {
        NSString * dayStr = [NSString stringWithFormat:@"%li日",(long)day];
        [days addObject:dayStr];
    }
    return days;
}

- (NSArray *)nameOfDays {

    NSString * strUrl = [self Formatter:[self dateYearMonth]];
    NSArray *array = [strUrl componentsSeparatedByString:@"-"];
    self.yearStr = array[0];
    
    NSString * tempStr = [array[1] stringByReplacingOccurrencesOfString:@"0" withString:@""];
    self.monthStr = tempStr;
     int  intYear = [self.yearStr intValue];
    if (![self.currentYearStr isEqualToString:@""]) {
           intYear = [self.currentYearStr intValue];
    }
 
    if ((intYear%4==0 && intYear %100 !=0) || intYear%400==0) {
        int  intMonth = [self.currentMonthStr intValue];
        if (intMonth == 2) {
           return  [self returnDays:29];
        } else if (intMonth == 1 || intMonth == 3 ||intMonth == 5 ||intMonth == 7 || intMonth == 8 || intMonth == 10 ||intMonth == 12 ) {
            return [self returnDays:31];
        }

        
    } else {
        int  intMonth = [self.currentMonthStr intValue];
        //判断是不是2月
        if (intMonth == 2) {
            return  [self returnDays:28];
        } else if (intMonth == 1 || intMonth == 3 || intMonth == 5 || intMonth == 7 || intMonth == 8 || intMonth == 10 || intMonth == 12) {
            return  [self returnDays:31];
        }

        
    }
    return   [self returnDays:30];

}


- (NSArray *)nameOfMonths {
    return @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
}

- (NSArray *)nameOfYears {
    NSMutableArray * years = [NSMutableArray array];
    for (NSInteger year = self.minYear; year <= self.maxYear; year++) {
        NSString * yearStr = [NSString stringWithFormat:@"%li年",(long)year];
        [years addObject:yearStr];
    }
    return years;
}



#pragma mark -- pickerView delegare 方法

// pickerView 列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.columnNumber;
}

// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == YEAR) {
        return self.years.count*100;//*100 循环滚动数据
    }
    
    if (self.columnNumber == 3) {
        if (component == DAY) {
            return [self nameOfDays].count*100;
        }
    }

    
        return self.months.count*100;


    
}

// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 90;

}
//显示数据的行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return _rowHeight;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if ([self.gqdelegate respondsToSelector:@selector(yearMonthDayDatePicker:didSectedDate:)]) {
        if(component == YEAR)//循环滚动数据
            
        {
            NSUInteger max = 0;
            
            NSUInteger base10 = 0;
            max = [self.years count]*100;
            
            base10 = (max/2)-(max/2)%[self.years count];
            
            [pickerView selectRow:[pickerView selectedRowInComponent:component]%[self.years count]+base10 inComponent:component animated:false];
            if (self.columnNumber == 3) {
                [self nameOfDays];
            }
            
        }
        if(component == MONTH)//循环滚动数据
            
        {
            
            NSUInteger max = 0;
            NSUInteger base10 = 0;
            max = [self.months count]*100;
            
            base10 = (max/2)-(max/2)%[self.months count];
            
            [pickerView selectRow:[pickerView selectedRowInComponent:component]%[self.months count]+base10 inComponent:component animated:false];
            //[self nameOfDays];
            
            if (self.columnNumber == 3) {
                CGFloat dayRow = [self.fixedDay floatValue]-1;
                for (NSString * dayString in [self nameOfDays]) {
                    if ([dayString isEqualToString:self.fixedDay]) {
                        dayRow = [[self nameOfDays] indexOfObject:self.fixedDay];
                        dayRow = dayRow + [self nameOfDays].count*100 / 2;
                    }
                }
                [self reloadAllComponents];
                [self selectRow:dayRow inComponent:DAY animated:NO];
            }

            
            
        }
        
        if (self.columnNumber == 3) {
            if(component == DAY)//循环滚动数据
                
            {
                
                
                NSInteger monthCount = [self nameOfDays].count;
                NSString *month = [[self nameOfDays] objectAtIndex:([self selectedRowInComponent:DAY] % monthCount)];
                self.currentDayStr = month;
                
                NSLog(@"滚动时候变化日期 =====%@", self.currentDayStr);
                //[self nameOfDays];
                NSUInteger max = 0;
                
                NSUInteger base10 = 0;
                max = [[self nameOfDays] count]*100;
                
                base10 = (max/2)-(max/2)%[[self nameOfDays] count];
                
                [pickerView selectRow:[pickerView selectedRowInComponent:component]%[[self nameOfDays] count]+base10 inComponent:component animated:false];
                
                self.fixedDay = month;
                
                
                
            }
        }

        
        
        [self.gqdelegate yearMonthDayDatePicker:self didSectedDate:[self date]];
        

    }
}



//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
//-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//
//    if (component == YEAR) {
//        NSInteger dayCount = self.years.count;
//
//        return [self.years objectAtIndex:(row % dayCount)];
//    }
//    if (component == MONTH) {
//
//        NSInteger yearCount = self.months.count;
//
//        return [self.months objectAtIndex:(row % yearCount)];
//    }
//    NSInteger dayCount = self.days.count;
//    return [self.days objectAtIndex:(row % dayCount)];
//
//}


//这个方法和上面的方法 冲突
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{


    if(component==YEAR)
    {
        //获取时间轴上当前的年份
        NSInteger yearCount = self.years.count;
        NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR] % yearCount)];
        self.currentYearStr = year;
        
        //[self nameOfDays];
        //第一列返回一个Label组件
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _rowWidth * kScreenWidth, [pickerView rowSizeForComponent:component].height)];
        label.backgroundColor = _yearbackgroundColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = _yearTextColor;
        NSInteger dayCount = self.years.count;
        label.text = [self.years objectAtIndex:(row % dayCount)];
        return label;
    }
    
    if (self.columnNumber == 3) {
        if (component == DAY) {
            //第二列返回一个Label组件
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _rowWidth * kScreenWidth, [pickerView rowSizeForComponent:component].height)];
            label.alpha = 0.7;
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = _monthbackgroundColor;
            label.font = _monthFont;
            label.textColor = _monthTextColor;
            NSInteger dayCount = [self nameOfDays].count;
            
            
            
            label.text = [[self nameOfDays] objectAtIndex:(row % dayCount)];
            return label;
        }

    }
    

        
        NSInteger monthCount = self.months.count;
        NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
        self.currentMonthStr = month;
        
        //第二列返回一个Label组件
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _rowWidth * kScreenWidth, [pickerView rowSizeForComponent:component].height)];
        label.alpha = 0.7;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = _monthbackgroundColor;
        label.font = _monthFont;
        label.textColor = _monthTextColor;
        label.text = [self.months objectAtIndex:(row % monthCount)];
        return label;



}












@end
