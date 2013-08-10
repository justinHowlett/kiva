//
//  JHViewController.m
//  Kiva
//
//  Created by Justin Howlett on 2013-08-09.
//  Copyright (c) 2013 Justin Howlett. All rights reserved.
//

#import "JHViewController.h"
#import "JHKivaDatasource.h"
#import "JHKivaLoanModel.h"

@interface JHViewController ()

@end

@implementation JHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JHKivaDatasource* datasource = [[JHKivaDatasource alloc]init];
    [datasource fetchNewestLoansWithCompletion:^(NSArray* loanModels, BOOL didSucceed) {
        for (JHKivaLoanModel *loan in loanModels){
            NSLog(@"loan is %@ use is %@",loan,loan.use);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
