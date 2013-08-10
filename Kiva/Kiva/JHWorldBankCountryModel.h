//
//  JHWorldBankCountryModel.h
//  Kiva
//
//  Created by Justin Howlett on 2013-08-10.
//  Copyright (c) 2013 Justin Howlett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHWorldBankCountryModel : NSObject

@property(nonatomic,strong) NSString* countryCode;
@property(nonatomic,strong) NSNumber* totalPopulation;
@property(nonatomic,strong) NSNumber* unemploymentPercent;
@property(nonatomic,strong) NSNumber* GDPGrowthPercent;
@property(nonatomic,strong) NSNumber* GDPPerCapita;
@property(nonatomic,strong) NSNumber* secondarySchoolEnrolment;
@property(nonatomic,strong) NSNumber* youthLiteracyPercent;
@property(nonatomic,strong) NSNumber* mortalityRateUnderFive; //per 1000 births
@property(nonatomic,strong) NSNumber* accessToElectricityPercent;
@property(nonatomic,strong) NSNumber* childrenWorkersFemalePercent;
@property(nonatomic,strong) NSNumber* childrenWorkersMalePercent;
@property(nonatomic,strong) NSNumber* roadsPavedPercent;
@property(nonatomic,strong) NSNumber* lifeExpectancy;
@property(nonatomic,strong) NSNumber* TBCases; //per 100,000 people
@property(nonatomic,strong) NSNumber* HIVPrevalencePercent;
@property(nonatomic,strong) NSNumber* malnutritionUnderFivePercent;
@property(nonatomic,strong) NSNumber* malariaCases; //per 100,000 people

@end
