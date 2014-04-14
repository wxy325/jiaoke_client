//
//  WXYDriverOrderDetailViewController.m
//  Pingche_client
//
//  Created by wxy325 on 4/4/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//
#import "OrderEntity.h"
#import "MBProgressHUD.h"
#import "WXYNetworkEngine.h"
#import "UIViewController+ShowHud.h"
#import "WXYDriverOrderDetailViewController.h"

@interface WXYDriverOrderDetailViewController ()

@end

@implementation WXYDriverOrderDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)updateOrder
{
    MBProgressHUD* hud = [self showNetworkWaitingHud];
    [SHARE_NW_ENGINE driverGetOrderState:GetOrderTypeAll onSucceed:^(NSArray *resultArray) {
        [hud hide:YES];
        if (resultArray.count >= self.orderIndex)
        {
            self.order = resultArray[self.orderIndex - 1];
        }
        else
        {
            self.order = nil;
        }
        [self bind:self.order];
        
    } onError:^(NSError *error) {
        [hud hide:YES];
        self.order = nil;
        [self bind:self.order];
    }];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateOrder];
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

- (void)bind:(OrderEntity*)o
{
/*
 
 @property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
 @property (weak, nonatomic) IBOutlet UILabel *desLabel;
 @property (weak, nonatomic) IBOutlet UIButton *btn;
 
 @property (weak, nonatomic) IBOutlet UILabel *stateLabel;

 */
    if (self.order)
    {
        self.noCustomerLabel.hidden = YES;
        self.containerView.hidden = NO;
        
        self.customerLocationLabel.text = o.fromDesc;
        self.customerNameLabel.text = o.customer.realName;
        self.phoneLabel.text = o.customer.tel;
        self.desLabel.text = o.toDesc;
        NSString* typeStr = o.type == OrderTypeDache? @"打车":@"拼车";
        NSString* st = [NSString stringWithFormat:@"%d个人%@",(o.maleNumber + o.femaleNumber),typeStr];
        self.detailLabel.text = st;
        
        
        NSString* str = nil;
        switch (o.state)
        {
            case OrderStateNew:
                str = @"新订单";
                break;
            case OrderStateArrived:
                str = @"已送达";
                break;
            case OrderStateReceived:
                str = @"已接";
                break;
            case OrderStateUnreceived:
                str = @"未接";
                break;
        }
        self.stateLabel.text = str;
        
        switch (o.state)
        {
            case OrderStateNew:
                str = @"确认订单";
                break;
            case OrderStateArrived:
                str = @"";
                break;
            case OrderStateReceived:
                str = @"确认送达";
                break;
            case OrderStateUnreceived:
                str = @"确认接到";
                break;
        }
        [self.btn setTitle:str forState:UIControlStateNormal];

    }
    else
    {
        self.noCustomerLabel.hidden = NO;
        self.containerView.hidden = YES;
    }
}
- (IBAction)btnPressed:(id)sender
{
    MBProgressHUD* hud = [self showNetworkWaitingHud];
    [SHARE_NW_ENGINE driverUpdateOrderOrderId:self.order.orderId state:(self.order.state+1) onSucceed:^{
        [hud hide:YES];
        [self showTextHud:@"成功"];
        [self updateOrder];
//        [self.navigationController popViewControllerAnimated:YES];
    } onError:^(NSError *error)
    {
        [hud hide:YES];
        [self showErrorHudWithError:error];
    }];
}
@end
