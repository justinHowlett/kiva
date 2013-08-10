//
//  JHKivaDatasource.m
//  Kiva
//
//  Created by Justin Howlett on 2013-08-09.
//  Copyright (c) 2013 Justin Howlett. All rights reserved.
//

#import "JHKivaDatasource.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperation.h"
/** models */
#import "JHKivaPartnerModel.h"
#import "JHKivaLoanModel.h"
#import "JHKivaLoanLocationModel.h"

/** Newest loans */
static const NSString*  kNewestLoanBaseURL  = @"http://api.kivaws.org/v1/loans/newest.json";
static const NSUInteger kNumberOfNewLoans   = 2;

/** Partner */
static const NSString*  kPartnersBaseURL    = @"http://api.kivaws.org/v1/partners.json";

/** General */
static const NSString*  kKivaAppId          = @"com.justinhowlett.kiva";
static const NSString*  kKivaClientId       = @"com.justinhowlett.kiva";
static const NSString*  kKivaClientSecret   = @"xxDvDkrwpiqejqtnDqDimtvFeyJvEouF";


@implementation JHKivaDatasource

#pragma mark -
#pragma mark - Newest Loans

-(void)fetchNewestLoansWithCompletion:(JHKivaNewestLoansCompletion)completion{
 
    NSURLRequest* request = [self requestWithMethod:@"GET" withURL:[self newestLoansURL] andBodyData:nil];

    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (completion){
            NSArray* modelArray = [self kivaLoanModelsForData:JSON];
            completion(modelArray,YES);
        }
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (completion){
            completion(nil,NO);
        }
    }];
    
    [operation start];
}

-(NSString*)newestLoansURL{
    return [NSString stringWithFormat:@"%@?app_id=%@&per_page=%d",kNewestLoanBaseURL,kKivaAppId,kNumberOfNewLoans];
}

-(NSArray*)kivaLoanModelsForData:(id)data{
    
    NSMutableArray* loanModelArray = [[NSMutableArray alloc]init];
    
    NSArray* loansArray = [data[@"loans"] copy];
    
    for (NSDictionary* loan in loansArray){
       
        JHKivaLoanModel* loanModel = [[JHKivaLoanModel alloc]init];
        
        loanModel.activity          = loan[@"activity"];
        loanModel.basketAmount      = loan[@"basket_amount"];
        loanModel.borrowerCount     = loan[@"borrower_count"];
        loanModel.fundedAmount      = loan[@"funded_amount"];
        loanModel.loanId            = loan[@"id"];
        loanModel.imageInfo         = loan[@"image"];
        loanModel.loanAmount        = loan[@"loan_amount"];
        loanModel.name              = loan[@"name"];
        loanModel.partnerId         = loan[@"partner_id"];
        loanModel.sector            = loan[@"sector"];
        loanModel.status            = loan[@"status"];
        loanModel.use               = loan[@"use"];
        
        JHKivaLoanLocationModel* location = [[JHKivaLoanLocationModel alloc]init];
        location.country            = loan[@"location"][@"country"];
        location.countryCode        = loan[@"location"][@"country_code"];
        location.town               = loan[@"location"][@"town"];
       
        loanModel.location          = location;

        [loanModelArray addObject:loanModel];
    }
    
    return loanModelArray;
}

#pragma mark - 
#pragma mark - Partner by ID

-(void)fetchPartnerWithId:(NSUInteger)partnerId andCompletion:(JHKivaPartnerCompletion)completion{
    
    NSURLRequest* request = [self requestWithMethod:@"GET" withURL:[self partnersURL] andBodyData:nil];
    
    AFJSONRequestOperation *operation;
    
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
       
        if (completion){
            
            JHKivaPartnerModel* partnerModel = [self partnerModelWithId:partnerId andData:JSON];
            completion(partnerModel,YES);
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (completion){
            completion(nil,NO);
        }
    }];
    
    [operation start];
}


-(NSString*)partnersURL{
    return [NSString stringWithFormat:@"%@?app_id=%@",kPartnersBaseURL,kKivaAppId];
}

-(JHKivaPartnerModel*)partnerModelWithId:(NSUInteger)partnerId andData:(id)data{
    
    //TODO: proccess on BG thread
    
    NSArray* partners               = data[@"partners"];
    NSPredicate *partnerIdPredicate = [NSPredicate predicateWithFormat:@"id ==[c] %d", partnerId];
    NSArray* partnerArrayWithId     = [partners filteredArrayUsingPredicate:partnerIdPredicate];
    
    if (!partnerArrayWithId.count > 0 )
        return nil;
    
    NSDictionary* partnerData       = partnerArrayWithId[0];
    
    JHKivaPartnerModel* partnerModel = [[JHKivaPartnerModel alloc]init];
    partnerModel.partnerId          = partnerData[@"id"];
    partnerModel.defaultRate        = partnerData[@"default_rate"];
    partnerModel.delinquencyRate    = partnerData[@"delinquency_rate"];
    partnerModel.dueDiligenceType   = partnerData[@"due_diligence_type"];
    partnerModel.imageInfo          = partnerData[@"image"];
    partnerModel.loansPosted        = partnerData[@"loans_posted"];
    partnerModel.name               = partnerData[@"name"];
    partnerModel.rating             = partnerData[@"rating"];
    partnerModel.totalAmountRaised  = partnerData[@"total_amount_raised"];
    
    return partnerModel;
}

#pragma mark -
#pragma mark - Utility methods

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
