//
//  JHWorldBankDatasource.m
//  Kiva
//
//  Created by Justin Howlett on 2013-08-10.
//  Copyright (c) 2013 Justin Howlett. All rights reserved.
//

#import "JHWorldBankDatasource.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "JHWorldBankCountryModel.h"

@interface JHWorldBankDatasource (){
    NSDictionary*                   _defaultIndicators;
    NSUInteger                      _indicatorCompletionCounter;
    JHWorldBankCountryCompletion    _countryIndicatorCompletion;
    JHWorldBankCountryModel*        _currentModel;
    NSString*                       _currentCountryCode;
}

@end

static const NSString* kWorldBankBaseURL            = @"http://api.worldbank.org/countries/";
static const NSString* kWorldBankIndicatorsEndpoint = @"/indicators/";

@implementation JHWorldBankDatasource

-(void)fetchCountryModelWithCode:(NSString*)countryCode andCompletion:(JHWorldBankCountryCompletion)completion{
   
    if (countryCode && countryCode.length > 2){
        NSLog(@"ERROR: country code provided in fetchCountryModelWithCode: andCompletion: is greater than 2 characters");
        completion(nil,NO);
    }
    
    _currentCountryCode         = countryCode;
    _countryIndicatorCompletion = completion;
    
    [self resetForNewRequest];
    
    /** world bank api requires an individual request for every indicator query */
    for (NSString* propKey in [[self defaultIndicators]allKeys]){
        [self dispatchRequestWithKey:propKey andIndicatorKey:[self defaultIndicators][propKey] forCountryCode:countryCode];
    }
}

-(void)dispatchRequestWithKey:(NSString*)propKey andIndicatorKey:(NSString*)indicatorKey forCountryCode:(NSString*)countryCode{
    
    NSURLRequest* request = [self requestWithMethod:@"GET" withURL:[self URLForIndicatorKey:indicatorKey andCountryCode:countryCode] andBodyData:nil];

    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        id indicatorValue = [self indicatorValueForResponseData:JSON];
        [self attachWorldBankModelValue:indicatorValue forKeyPath:propKey];
        [self incrementIndicatorRequestCompletions];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        [self incrementIndicatorRequestCompletions];
    }];
    
    [operation start];
    
}

-(id)indicatorValueForResponseData:(id)responseData{
    
    NSArray* responseDataArray = (NSArray*)responseData;
    
    /** world bank repsonse is an array of 2 arrays, the first array is request info i.e pagination etc..., second array holds 1 dictionary with our data */
    if (responseDataArray.count < 2)
        return nil;
    
    id value = responseDataArray[1][0][@"value"];
    
    return value;
}

-(NSString*)URLForIndicatorKey:(NSString*)indicator andCountryCode:(NSString*)countryCode{
    
    NSString* url = [NSString stringWithFormat:@"%@%@%@%@?format=json&date=2010:2010",kWorldBankBaseURL,countryCode,kWorldBankIndicatorsEndpoint,indicator];
    
    return url;
}

-(void)incrementIndicatorRequestCompletions{
    
    _indicatorCompletionCounter++;
    
    if (_indicatorCompletionCounter == [[[self defaultIndicators]allKeys]count]){
        
        _countryIndicatorCompletion([self currentCountyModel],YES);
        
    }
}

-(void)attachWorldBankModelValue:(id)value forKeyPath:(NSString*)modelKeyPath{
    
    if ([value isKindOfClass:[NSNull class]])
        return;
    
    JHWorldBankCountryModel* currentModel = [self currentCountyModel];
    
    [currentModel setValue:value forKeyPath:modelKeyPath];
}

-(JHWorldBankCountryModel*)currentCountyModel{
    
    if (!_currentModel){
        _currentModel = [[JHWorldBankCountryModel alloc]init];
        _currentModel.countryCode = _currentCountryCode;
    }
    
    return _currentModel;
}

-(NSDictionary*)defaultIndicators{
    
    if (_defaultIndicators)
        return _defaultIndicators;
    
    /** indicator keys are matched to the country model property KVCs */
    
    NSMutableDictionary* mutableIndicators = [[NSMutableDictionary alloc]init];
    
    mutableIndicators[@"totalPopulation"]                   = @"SP.POP.TOTL";
    mutableIndicators[@"unemploymentPercent"]               = @"SL.UEM.TOTL.ZS";
    mutableIndicators[@"GDPGrowthPercent"]                  = @"NY.GDP.MKTP.KD.ZG";
    mutableIndicators[@"GDPPerCapita"]                      = @"NY.GDP.PCAP.CD";
    mutableIndicators[@"secondarySchoolEnrolment"]          = @"SE.SEC.ENRR";
    mutableIndicators[@"youthLiteracyPercent"]              = @"SE.ADT.1524.LT.ZS";
    mutableIndicators[@"mortalityRateUnderFive"]            = @"SH.DYN.MORT";
    mutableIndicators[@"accessToElectricityPercent"]        = @"EG.ELC.ACCS.ZS";
    mutableIndicators[@"childrenWorkersMalePercent"]        = @"SL.TLF.0714.WK.MA.ZS";
    mutableIndicators[@"childrenWorkersFemalePercent"]      = @"SL.TLF.0714.WK.MA.ZS";
    mutableIndicators[@"roadsPavedPercent"]                 = @"IS.ROD.PAVE.ZS";
    mutableIndicators[@"lifeExpectancy"]                    = @"SP.DYN.LE00.IN";
    mutableIndicators[@"TBCases"]                           = @"SH.TBS.INCD";
    mutableIndicators[@"malnutritionUnderFivePercent"]      = @"SH.STA.MALN.ZS";
    mutableIndicators[@"HIVPrevalencePercent"]              = @"SH.DYN.AIDS.ZS";
    mutableIndicators[@"malariaCases"]                      = @"SH.MLR.INCD";
    
    _defaultIndicators = mutableIndicators;
    
    return _defaultIndicators;
}


#pragma mark -
#pragma mark - Utility methods

-(void)resetForNewRequest{
    _indicatorCompletionCounter = 0;
    _currentModel               = nil;
}

-(NSURLRequest*)requestWithMethod:(NSString*)method withURL:(NSString*)url andBodyData:(NSData*)bodyData{
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    if (bodyData){
        [request setHTTPBody:bodyData];
    }
    
    if (method){
        [request setHTTPMethod:method];
    }
    
    return request;
}

@end
