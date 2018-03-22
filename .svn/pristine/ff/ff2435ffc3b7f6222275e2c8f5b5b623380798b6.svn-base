//
//  CoupViewController.h
//  KingProFrame
//
//  Created by denglong on 8/20/15.
//  Copyright (c) 2015 king. All rights reserved.
//

#import "BaseViewController.h"

@protocol CoupDelegate 

- (void)coupValue:(NSString *)price andCoupId:(NSString *)coupId andCoupName:(NSString *)coupName;

@end

@interface CoupViewController : BaseViewController

@property(nonatomic, retain) id<CoupDelegate> myCoupDelegate;
@property(nonatomic, retain) NSArray *lists;
@property(nonatomic, retain) NSArray *cantLists;
@property(nonatomic, retain) NSString *coupId;
@property (weak, nonatomic) IBOutlet UIImageView *nullImage;
@property (weak, nonatomic) IBOutlet UILabel *nullLab;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *useableBtn;
@property (weak, nonatomic) IBOutlet UIButton *unUseableBtn;
@property (weak, nonatomic) IBOutlet UIView *leftLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;

@end
