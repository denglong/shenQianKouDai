//
//  EvaluateBodyCell.m
//  myTest
//
//  Created by denglong on 12/23/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import "EvaluateBodyCell.h"

@interface EvaluateBodyCell()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet UILabel *lastLab;

@property(nonatomic, strong) DLStarRageView *orderStarView;
@property(nonatomic, strong) DLStarRageView *deliverStarView;
@property(nonatomic, strong) DLStarRageView *mannerStarView;

@end

@implementation EvaluateBodyCell
@synthesize orderStarView, deliverStarView, mannerStarView, myView;
@synthesize oneLab, twoLab, threeLab, lastLab;
@synthesize myTextView, headerView, orderNumLab, moneyLab, submitBtn, userEvaluate;

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    submitBtn.layer.cornerRadius = 5;
    
    myTextView.layer.borderWidth = 0.5;
    myTextView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    myTextView.delegate = self;
    myTextView.hidden = YES;
    lastLab.hidden = YES;
    userEvaluate.hidden = YES;
    self.nullImage.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cellKeyboardHidden)
                                                 name:@"CELLHIDDENKEYBOARD"
                                               object:nil];
}

- (void)setStarViewList:(NSArray *)starViewList {
    orderStarView = starViewList[0];
    deliverStarView = starViewList[1];
    mannerStarView = starViewList[2];
    
    orderStarView.frame = CGRectMake(CGRectGetMaxX(oneLab.frame) + 10, 4, orderStarView.frame.size.width, orderStarView.frame.size.height);
    [myView addSubview:orderStarView];
    
    deliverStarView.frame = CGRectMake(CGRectGetMaxX(twoLab.frame) + 10, 7 + orderStarView.frame.size.height, orderStarView.frame.size.width, orderStarView.frame.size.height);
    [myView addSubview:deliverStarView];
    
    mannerStarView.frame = CGRectMake(CGRectGetMaxX(threeLab.frame) + 10, 32 + 27 + orderStarView.frame.size.height , orderStarView.frame.size.width, orderStarView.frame.size.height);
    [myView addSubview:mannerStarView];
    
    submitBtn.enabled = NO;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"请输入内容，最多140字"]) {
        textView.text = nil;
    }
    textView.textColor = [UIColor blackColor];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"请输入内容，最多140字";
    }
    
    NSNotification *notification = [NSNotification notificationWithName:@"HIDDENKEYBOARD"
                                                                 object:nil
                                                               userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    int length = [self countWord:textView.text];
    if (length >= 140) {
        textView.text = [textView.text substringToIndex:140];
    }
    
    if (length >= 140) {
        lastLab.text = [NSString stringWithFormat:@"还可输入0字"];
    }
    else
    {
        lastLab.text = [NSString stringWithFormat:@"还可输入%d字", 140 - length];
    }
}

- (void)cellKeyboardHidden {
    [myTextView resignFirstResponder];
}

- (int)countWord:(NSString *)strtemp
{
    int i,n=(int)strtemp.length,l=0,a=0,b=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[strtemp characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    if(a==0 && l==0) return 0;
    return l+(int)ceilf((float)(a+b)/2.0);
}

- (void)setResponseDic:(NSDictionary *)responseDic {
    orderNumLab.text = [NSString stringWithFormat:@"订单号:%@", [responseDic objectForKey:@"orderNo"]];
    moneyLab.text = [NSString stringWithFormat:@"￥%@", [responseDic objectForKey:@"payPrice"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
