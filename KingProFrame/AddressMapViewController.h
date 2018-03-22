//
//  AddressMapViewController.h
//  KingProFrame
//
//  Created by lihualin on 15/8/4.
//  Copyright (c) 2015年 king. All rights reserved.
//

#import "BaseViewController.h"

#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
//#import <MapKit/MapKit.h>

@protocol AddressMapViewControllerDelegate <NSObject>

-(void)getAddress:(NSString *)address;

@end

@interface AddressMapViewController : BaseViewController<MAMapViewDelegate,AMapSearchDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *localTableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (nonatomic, retain) IBOutlet UISearchBar *serchBar;
@property (nonatomic , retain) id<AddressMapViewControllerDelegate> delegate;
@property (nonatomic , assign) BOOL isSwitchCity; /**首页切换城市 yes 是 no否*/
@property (nonatomic , assign) NSDictionary *pointsDic;   //首页传入经纬度
@end
