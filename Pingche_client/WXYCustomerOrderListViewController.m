//
//  WXYCustomerOrderListViewController.m
//  Pingche_client
//
//  Created by wxy325 on 4/4/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYCustomerOrderListViewController.h"
#import "WXYNetworkEngine.h"
#import "WXYCustomerOrderListCell.h"
#import "UIViewController+ShowHud.h"

@interface WXYCustomerOrderListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray* nOrderArray;
@property (strong, nonatomic) NSArray* historyOrderArray;

@end

@implementation WXYCustomerOrderListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MBProgressHUD* hud = [self showNetworkWaitingHud];
    [SHARE_NW_ENGINE customerGetAllOrder:^(NSArray *nArray, NSArray *hArray) {
        [hud hide:YES];
        self.nOrderArray = nArray;
        self.historyOrderArray = hArray;
        [self.tableView reloadData];
        
    } onError:^(NSError *error) {
        [hud hide:YES];
        [self showErrorHudWithError:error];
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.nOrderArray.count;
    }
    else
    {
        return self.historyOrderArray.count;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


#pragma mark - UITableView Delegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXYCustomerOrderListCell* cell = (WXYCustomerOrderListCell*)[tableView dequeueReusableCellWithIdentifier:@"aaa"];
    if (!cell)
    {
        cell = [WXYCustomerOrderListCell makeCell];
    }
    OrderEntity* o = nil;
    if (indexPath.section == 0)
    {
        o = self.nOrderArray[indexPath.row];
    }
    else
    {
        o = self.historyOrderArray[indexPath.row];
    }
    [cell bindOrderEntity:o];
    return cell;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"当前订单";
    }
    else
    {
        return @"历史订单";
    }
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78.f;
}

@end
