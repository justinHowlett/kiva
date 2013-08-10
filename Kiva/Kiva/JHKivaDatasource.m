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

//APP ID com.justinhowlett.kiva
//Client ID com.justinhowlett.kiva
//Client Secret xxDvDkrwpiqejqtnDqDimtvFeyJvEouF

/*
 OAuth Endpoints
 Lender Authorization
 https://www.kiva.org/oauth/authorize
 Redirect URI
 oob
 Request Token
 https://api.kivaws.org/oauth/request_token
 Access Token
 https://api.kivaws.org/oauth/access_token
 
 */

static const NSString*  kNewestLoanBaseURL  = @"http://api.kivaws.org/v1/loans/newest.json";
static const NSUInteger kNumberOfNewLoans   = 30;
static const NSString*  kKivaAppId          = @"com.justinhowlett.kiva";
static const NSString*  kKivaClientId       = @"com.justinhowlett.kiva";
static const NSString*  kKivaClientSecret   = @"xxDvDkrwpiqejqtnDqDimtvFeyJvEouF";

@implementation JHKivaDatasource

#pragma mark -
#pragma mark - Newest Loans

-(void)fetchNewestLoansWithCompletion:(JHKivaDatasourceCompletion)completion{
 
    NSURLRequest* request = [self requestWithMethod:@"GET" withURL:[self newestLoansURL] andBodyData:nil];

    AFJSONRequestOperation *operation;
   
    operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        if (completion){
            completion(JSON,YES);
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
