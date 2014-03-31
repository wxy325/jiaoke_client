//
//  WXYSelectLocationViewController.h
//  Pingche_client
//
//  Created by wxy325 on 3/8/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@class WXYMapViewController;

@interface WXYSelectLocationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, AMapSearchDelegate>

@property (weak, nonatomic) WXYMapViewController* mapVC;
- (IBAction)backButtonPressed:(id)sender;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
