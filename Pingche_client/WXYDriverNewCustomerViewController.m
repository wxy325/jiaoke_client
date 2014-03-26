//
//  WXYDriverNewCustomerViewController.m
//  Pingche_client
//
//  Created by wxy325 on 3/9/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYDriverNewCustomerViewController.h"

@interface WXYDriverNewCustomerViewController ()

@end

@implementation WXYDriverNewCustomerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)pressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
