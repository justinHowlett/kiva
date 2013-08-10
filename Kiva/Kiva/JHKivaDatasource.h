//
//  JHKivaDatasource.h
//  Kiva
//
//  Created by Justin Howlett on 2013-08-09.
//  Copyright (c) 2013 Justin Howlett. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JHKivaDatasourceCompletion)(NSArray* loanModels, BOOL didSucceed); // takes an NSArray of JHKivaLoanModels

@interface JHKivaDatasource : NSObject
-(void)fetchNewestLoansWithCompletion:(JHKivaDatasourceCompletion)completion;
@end
