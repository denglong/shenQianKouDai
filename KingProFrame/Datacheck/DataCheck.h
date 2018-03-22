//
//  DataCheck.h
//  Discuz2
//
//  Created by rexshi on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCheck : NSObject {

}
+ (BOOL) isValidNumber:(id)input;
+ (BOOL) isValidString:(id)input;
+ (BOOL) isValidDictionary:(id)input;
+ (BOOL) isValidArray:(id)input;


@end
