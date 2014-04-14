//
//  WXYOrderManagerViewController.m
//  Pingche_client
//
//  Created by wxy325 on 3/9/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYOrderManagerViewController.h"
#import "UIViewController+ShowHud.h"
#import "WXYNetworkEngine.h"
#import "WXYDriverOrderDetailViewController.h"
#import "WXYCustomerOrderListCell.h"

@interface WXYOrderManagerViewController ()
@property (strong, nonatomic) NSArray* orderArray;
@end

@implementation WXYOrderManagerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    MBProgressHUD* hud = [self showNetworkWaitingHud];
    [SHARE_NW_ENGINE driverGetOrderState:GetOrderTypeHistory onSucceed:^(NSArray *resultArray) {
        [hud hide:YES];
        self.orderArray = resultArray;
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

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WXYCustomerOrderListCell* cell = (WXYCustomerOrderListCell*)[tableView dequeueReusableCellWithIdentifier:@"aaa"];
    if (!cell)
    {
        cell = [WXYCustomerOrderListCell makeCell];
    }
    
    OrderEntity* o = self.orderArray[indexPath.row];
    [cell bindOrderEntity:o];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    WXYDriverOrderDetailViewController* vc = (WXYDriverOrderDetailViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"WXYDriverOrderDetailViewController"];
//    OrderEntity* o = self.orderArray[indexPath.row];
//    vc.order = o;
//    [self.navigationController pushViewController:vc animated:YES];
    
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78.f;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
