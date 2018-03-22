//
//  ConfigModel.h
//  KingProFrame
//
//  Created by denglong on 12/2/15.
//  Copyright © 2015 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigModel : NSObject

@property (nonatomic, retain) NSString *isRecomShow;
@property (nonatomic, retain) NSString *startPageUrl;
@property (nonatomic, retain) NSString *startPageMs;
@property (nonatomic, retain) NSString *shopCancelAlert;
@property (nonatomic, copy) NSString *caigouShow;
@property (nonatomic, copy) NSString *caigouUrl;
@property (nonatomic, copy) NSString *showReg;
@property (nonatomic, copy) NSString *showRegImg;

@end
