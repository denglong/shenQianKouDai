//
//  SRMessage.h
//  Discuz2
//
//  Created by rexshi on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"

@interface SRMessage : NSObject {
    
}

+ (void) errorMessage: (NSString *)message;
+ (void) errorMessage:(NSString *)message delegate:(id)delegate;
+ (void) successMessage: (NSString *)message;
+ (void) successMessage:(NSString *)message delegate:(id)delegate;

+ (void) infoMessage: (NSString *)message;
+ (void) infoMessageWithTitle:(NSString *)title message:(NSString *)message;
+ (void) infoMessage:(NSString *)message delegate:(id)delegate;
+ (void) infoMessageWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate;
+ (void)infoMessage:(NSString *)message block:(void (^)())block;
+ (void) myInfoMessage:(NSString *)message delegate:(id)delegate;
+ (void)infoMessageOk:(NSString *)message block:(void (^)())block;
+ (void)loginInfoMessage:(NSString *)message block:(void (^)())block;
+ (void)orderBusinessMessage:(NSString *)message block:(void (^)())block;
+ (void)infoMessage:(NSString *)message title:(NSString *)title cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle block:(void (^)())block;
+ (void)infoMessage:(NSString *)message title:(NSString *)title cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle block:(void (^)())block cancleBlock:(void(^)())cancleBlock;
+ (void)infoDLMessage:(NSString *)message title:(NSString *)title cancelTitle:(NSString *)cancelTitle sureTitle:(NSString *)sureTitle block:(void (^)())block cancleBlock:(void(^)())cancleBlock;
@end
