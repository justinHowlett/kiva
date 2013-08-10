//
//  JHKivaLoanModel.h
//  Kiva
//
//  Created by Justin Howlett on 2013-08-09.
//  Copyright (c) 2013 Justin Howlett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JHKivaLoanLocationModel;

@interface JHKivaLoanModel : NSObject

@property(nonatomic,strong) NSString*                   activity;
@property(nonatomic,strong) NSNumber*                   basketAmount;
@property(nonatomic,strong) NSNumber*                   borrowerCount;
@property(nonatomic,strong) NSNumber*                   fundedAmount;
@property(nonatomic,strong) NSNumber*                   loanId;
@property(nonatomic,strong) NSDictionary*               imageInfo;
@property(nonatomic,strong) NSNumber*                   loanAmount;
@property(nonatomic,strong) JHKivaLoanLocationModel*    location;
@property(nonatomic,strong) NSString*                   name;
@property(nonatomic,strong) NSNumber*                   partnerId;
@property(nonatomic,strong) NSString*                   sector;
@property(nonatomic,strong) NSString*                   status;
@property(nonatomic,strong) NSString*                   use;

@end

