//
//  DistributionWayController.m
//  KingProFrame
//
//  Created by denglong on 3/7/16.
//  Copyright © 2016 king. All rights reserved.
//

#import "DistributionWayController.h"
#import "FullTimeView.h"

@interface DistributionWayController ()<FinishPickView>
{
    NSString *localeDate;
    NSMutableArray *dateTimes;
    UIView *bgView;
}
@property (weak, nonatomic) IBOutlet UIButton *immediatelyBtn;
@property (weak, nonatomic) IBOutlet UIButton *preengageBtn;
@property (weak, nonatomic) IBOutlet UIButton *upBtn;

@end

@implementation DistributionWayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"配送时间";
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kViewHeight, viewWidth, 260)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.alpha = 0.8;
    [self.view addSubview:bgView];
    
    FullTimeView *fullTimePick = [[FullTimeView alloc]initWithFrame:CGRectMake(0,0,viewWidth, 260)];
    fullTimePick.delegate = self;
    [bgView addSubview:fullTimePick];
    if (self.isImmediately == YES) {
        self.upBtn.hidden = NO;
        self.immediatelyBtn.selected = YES;
        self.preengageBtn.selected = NO;
    }
    else
    {
        self.upBtn.hidden = YES;
        self.immediatelyBtn.selected = NO;
        self.preengageBtn.selected = YES;
    }
    
    dateTimes = [NSMutableArray array];
    for (NSString *chonseTime in _chooseTimes) {
        NSString *time = [self formatTimeStamp:[chonseTime substringToIndex:10] timeFormat:@"YYYY-MM-dd HH:mm" ];
        [dateTimes addObject:time];
    }
    
    fullTimePick.allTimes = dateTimes;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth - 60, 0, 50, 50)];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:confirmBtn];
}

-(void)didFinishPickView:(NSInteger)row
{
    localeDate = _chooseTimes[row];
}

//即时配送选择事件
- (IBAction)immediatelyAction:(id)sender {
    self.upBtn.hidden = NO;
    [self.delegate chooseDistributionAction:@"即时配送"];
    [self.navigationController popViewControllerAnimated:YES];
}

//预约配送选择事件
- (IBAction)preengageAction:(id)sender {
    self.upBtn.hidden = YES;
    self.immediatelyBtn.selected = NO;
    self.preengageBtn.selected = YES;
    [UIView animateWithDuration:0.5 animations:^{
        bgView.frame = CGRectMake(0, kViewHeight - 260, viewWidth, 260);
    }];
}

- (void)cancelAction {
    self.immediatelyBtn.selected = YES;
    self.preengageBtn.selected = NO;
    [UIView animateWithDuration:0.5 animations:^{
        bgView.frame = CGRectMake(0, kViewHeight, viewWidth, 260);
    }];
}

- (void)confirmBtnAction {
    if (_chooseTimes.count > 0 && ![DataCheck isValidString:localeDate]) {
        localeDate = _chooseTimes.firstObject;
    }
    [self.delegate chooseDistributionAction:localeDate];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
