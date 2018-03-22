//
//  EvaluateViewController.h
//  myTest
//
//  Created by denglong on 12/23/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import "BaseViewController.h"

@interface EvaluateViewController : BaseViewController

@property (nonatomic, retain) NSString *orderNum;
@property (nonatomic, retain) NSString *type;                       /**<1.店主点评用户，2.顾客点评*/
@property (nonatomic, assign) NSInteger indexNum;                  /**<1.点评页面， 2.查看点评页面*/

@end
