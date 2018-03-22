//
//  DLCollectionView.h
//  myTest
//
//  Created by denglong on 12/24/15.
//  Copyright © 2015 邓龙. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinsModel.h"

@protocol DLCollectionDelegate

- (void)collectionClickBtnAction:(NSInteger)tagNum;

@end

@interface DLCollectionView : UIView

@property(nonatomic, weak) id<DLCollectionDelegate> delegate;
@property(nonatomic, strong) NSArray *pins;
@property(nonatomic, strong) PinsModel *pinsModel;

- (UIView *)createWithCollectionView:(NSArray *)viewList height:(NSInteger)height width:(NSInteger)width;

@end
