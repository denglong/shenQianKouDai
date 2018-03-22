//
//  HomeModel.m
//  KingProFrame
//
//  Created by denglong on 12/2/15.
//  Copyright © 2015 king. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"maskAdModel" : @"maskAd",
             @"userInfoListModel" : @"userInfoList",
             @"configModel" : @"config",
             @"cartInfoModel" : @"cartInfo"
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"sliders" : @"SlidersModel",
             @"banners" : @"BannersModel",
             @"pin" : @"PinsModel",
             @"hotCategories" : @"HotCategoriesModel",
             @"topices" : @"labelListModel"
             };
}

@end
