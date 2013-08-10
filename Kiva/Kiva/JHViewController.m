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
#import "JHKivaPartnerModel.h"

@interface JHViewController ()

@end

@implementation JHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JHKivaDatasource* datasource = [[JHKivaDatasource alloc]init];
    [datasource fetchPartnerWithId:2 andCompletion:^(JHKivaPartnerModel *partnerModel, BOOL didSucceed) {
        NSLog(@"name is %@",partnerModel.name);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
