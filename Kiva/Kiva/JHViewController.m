//
//  JHViewController.m
//  Kiva
//
//  Created by Justin Howlett on 2013-08-09.
//  Copyright (c) 2013 Justin Howlett. All rights reserved.
//

#import "JHViewController.h"
#import "JHKivaDatasource.h"

@interface JHViewController ()

@end

@implementation JHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    JHKivaDatasource* datasource = [[JHKivaDatasource alloc]init];
    [datasource fetchNewestLoansWithCompletion:^(id data, BOOL didSucceed) {
        NSLog(@"kiva newest is %@",data);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
