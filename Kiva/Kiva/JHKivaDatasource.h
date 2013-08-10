//
//  JHKivaDatasource.h
//  Kiva
//
//  Created by Justin Howlett on 2013-08-09.
//  Copyright (c) 2013 Justin Howlett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JHKivaPartnerModel;

typedef void(^JHKivaNewestLoansCompletion)(NSArray* loanModels, BOOL didSucceed); // takes an NSArray of JHKivaLoanModels
typedef void(^JHKivaPartnerCompletion)(JHKivaPartnerModel* partnerModel, BOOL didSucceed);

@interface JHKivaDatasource : NSObject
-(void)fetchNewestLoansWithCompletion:(JHKivaNewestLoansCompletion)completion;
-(void)fetchPartnerWithId:(NSUInteger)partnerId andCompletion:(JHKivaPartnerCompletion)completion;
@end
