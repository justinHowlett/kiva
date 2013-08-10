//
//  JHWorldBankDatasource.h
//  Kiva
//
//  Created by Justin Howlett on 2013-08-10.
//  Copyright (c) 2013 Justin Howlett. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHWorldBankCountryModel;

typedef void(^JHWorldBankCountryCompletion)(JHWorldBankCountryModel* countryModel, BOOL didSucceed);

@interface JHWorldBankDatasource : NSObject
-(void)fetchCountryModelWithCode:(NSString*)countryCode andCompletion:(JHWorldBankCountryCompletion)completion; //accepts 2 letter country code
@end
