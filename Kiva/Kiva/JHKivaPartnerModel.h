//
//  JHKivaPartnerModel.h
//  Kiva
//
//  Created by Justin Howlett on 2013-08-10.
//  Copyright (c) 2013 Justin Howlett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHKivaPartnerModel : NSObject

@property(nonatomic,strong) NSNumber*       partnerId;
@property(nonatomic,strong) NSNumber*       defaultRate;
@property(nonatomic,strong) NSNumber*       delinquencyRate;
@property(nonatomic,strong) NSString*       dueDiligenceType;
@property(nonatomic,strong) NSDictionary*   imageInfo;
@property(nonatomic,strong) NSNumber*       loansPosted;
@property(nonatomic,strong) NSString*       name;
@property(nonatomic,strong) NSNumber*       rating;
@property(nonatomic,strong) NSNumber*       totalAmountRaised;

@end
