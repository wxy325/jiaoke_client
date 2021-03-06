//
//  WXYDriverRootViewController.m
//  Pingche_client
//
//  Created by wxy325 on 3/9/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYDriverRootViewController.h"
#import "WXYOrderManagerViewController.h"
#import "CommonUtility.h"
#import "LineDashPolyline.h"
#import "DriverInfoAnnotation.h"
#import "WXYNetworkEngine.h"
#import "UIViewController+ShowHud.h"
#import "WXYSettingManager.h"
#import "WXYCustomerInfoAnnotation.h"
#import "WXYDriverOrderDetailViewController.h"


@interface WXYDriverRootViewController ()

@property (assign, nonatomic) int number;

@property (strong, nonatomic) MAMapView* mapView;
@property (strong, nonatomic) AMapSearchAPI* search;
//@property (strong, nonatomic) POIAnnotation* driver;
//@property (strong, nonatomic) POIAnnotation* siping;
//@property (strong, nonatomic) POIAnnotation* jiading;
//@property (strong, nonatomic) POIAnnotation* wujiao;

@property (strong, nonatomic) NSArray* polylines;
@property (assign, nonatomic) CLLocationCoordinate2D location;
@property (assign, nonatomic) BOOL fFirstLocationUpdate;

@property (assign, nonatomic) BOOL fSearchDone;

//T nimer
@property (strong, nonatomic) NSTimer* locationUpdateTimer;
@property (strong, nonatomic) NSTimer* checkNewOrderTimer;
@property (strong, nonatomic) NSTimer* getDriverInfoTimer;


@property (strong, nonatomic) OrderEntity* getNewOrder;
@property (strong, nonatomic) NSArray* customerAnnoArray;

@end

@implementation WXYDriverRootViewController
#pragma mark - Timer
- (NSTimer*)locationUpdateTimer
{
    if (!_locationUpdateTimer)
    {
        _locationUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
    }
    return _locationUpdateTimer;
}
- (NSTimer*)checkNewOrderTimer
{
    if (!_checkNewOrderTimer)
    {
        _checkNewOrderTimer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(checkNewOrder) userInfo:nil repeats:YES];
    }
    return _checkNewOrderTimer;
}
- (NSTimer*)getDriverInfoTimer
{
    if (!_getDriverInfoTimer)
    {
        _getDriverInfoTimer = [NSTimer scheduledTimerWithTimeInterval:10.f target:self selector:@selector(getDriverInfo) userInfo:nil repeats:YES];
    }
    return _getDriverInfoTimer;
}
- (void)getDriverInfo
{
    [SHARE_NW_ENGINE driverGetInfoOnSucceed:^(DriverInfo *driver)
     {
        SHARE_SETTING_MANAGER.currentUserInfo.driverInfo = driver;
         [self updateRouteOverlayer:driver];
    } onError:^(NSError *error) {
        
    }];
    [SHARE_NW_ENGINE driverGetOrderState:GetOrderTypeAll onSucceed:^(NSArray *resultArray) {
        [self.mapView removeAnnotations:self.customerAnnoArray];
        NSMutableArray* a = [@[] mutableCopy];
        for (OrderEntity *o in resultArray)
        {
            CustomerInfo* c = o.customer;
            WXYCustomerInfoAnnotation* an = [[WXYCustomerInfoAnnotation alloc] init];
            an.customer = c;
            an.coordinate = o.locationFrom;
            [a addObject:an];
        }
        self.customerAnnoArray = a;
        
        [self.mapView addAnnotations:self.customerAnnoArray];

    } onError:^(NSError *error) {
        
    }];
    
}
- (void)restartAllTimer
{
    [self.locationUpdateTimer setFireDate:[NSDate distantPast]];
    [self.checkNewOrderTimer setFireDate:[NSDate distantPast]];
    [self.getDriverInfoTimer setFireDate:[NSDate distantPast]];
}
- (void)stopAllTimer
{
    [self.locationUpdateTimer setFireDate:[NSDate distantFuture]];
    [self.checkNewOrderTimer setFireDate:[NSDate distantFuture]];
    [self.getDriverInfoTimer setFireDate:[NSDate distantFuture]];
}

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.number = 1;
    self.fFirstLocationUpdate = YES;
    self.fSearchDone = YES;
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:@"7b8460b48a80fdd39af6191245021353" Delegate:self];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.contentView.bounds];
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.contentView addSubview:self.mapView];
 
    
    [self.mapView setZoomLevel:12.f];

    [self.navigationController.tabBarController.tabBar setTintColor:[UIColor colorWithRed:121.f/255.f green:223.f/255.f blue:237.f/255.f alpha:1.f]];
    UITabBar* tabBar = self.navigationController.tabBarController.tabBar;
    UITabBarItem* item1 = tabBar.items[1];
    item1.title = @"乘客1";
    UITabBarItem* item2 = tabBar.items[2];
    item2.title = @"乘客2";
    NSArray* vcArray = self.navigationController.tabBarController.viewControllers;
    WXYDriverOrderDetailViewController* vc1 = vcArray[1];
    vc1.orderIndex = 1;
    WXYDriverOrderDetailViewController* vc2 = vcArray[2];
    vc2.orderIndex = 2;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    [self.mapView removeAnnotations:@[self.driver,self.jiading,self.siping,self.wujiao]];
    if (self.number == 1)
    {
        [self.mapView addAnnotations:@[self.driver, self.wujiao]];
    }
    else
    {
        [self.mapView addAnnotations:@[self.driver,self.jiading,self.siping,self.wujiao]];
    }
    */
    //Timer
    [self restartAllTimer];
//    [self.locationUpdateTimer fire];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Timer
//    [self.locationUpdateTimer invalidate];
    [self stopAllTimer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)longPressed:(id)sender
{
    [self performSegueWithIdentifier:@"NewCustomer" sender:self];
    self.number = 2;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[WXYOrderManagerViewController class]])
    {
        WXYOrderManagerViewController* o = segue.destinationViewController;
        o.number = self.number;
    }
}

#pragma mark - Map
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    //    MAPinAnnotationView* p = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"tttt"];
    MAPinAnnotationView* p = nil;
    
    if (!p)
    {
        p = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"tttt"];
    }
    p.canShowCallout = YES;
    
    if ([self.customerAnnoArray containsObject:annotation])
    {
        p.pinColor = MAPinAnnotationColorGreen;
    }
    else
    {
        p.pinColor = MAPinAnnotationColorPurple;
    }
    
    /*
    if (annotation == self.driver)
    {
        p.pinColor = MAPinAnnotationColorGreen;
//        p.canShowCallout = YES;
//        p.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else if (annotation == self.jiading)
    {
        p.pinColor = MAPinAnnotationColorRed;
    }
    else if (annotation == self.siping)
    {
        p.pinColor = MAPinAnnotationColorPurple;
    }
    else if (annotation == self.wujiao)
    {
        p.pinColor = MAPinAnnotationColorPurple;
    }
    */
    
    //    annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];    return annotationView;
    return p;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{

    CLLocationCoordinate2D userL = userLocation.coordinate;
    self.location = userL;
    
    if (self.fFirstLocationUpdate)
    {
        [self.mapView setCenterCoordinate:userL animated:NO];
        self.fFirstLocationUpdate = NO;
    }

}


-(void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    [self.mapView removeOverlays:self.polylines];
    
    self.polylines = [CommonUtility polylinesForPath:response.route.paths[0]];
    [self.mapView addOverlays:self.polylines];
    
}
- (IBAction)currentButtonPressed:(id)sender
{
//    [self.mapView setCenterCoordinate:self.driver.coordinate animated:YES];
}
- (IBAction)rbt:(id)sender {
//    CLLocationCoordinate2D userL = self.location;
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviDrive;
    naviRequest.requireExtension = YES;
    /*
    naviRequest.origin = [AMapGeoPoint locationWithLatitude:self.driver.coordinate.latitude longitude:self.driver.coordinate.longitude];
    if (self.number == 2)
    {
        naviRequest.waypoints = @[[AMapGeoPoint locationWithLatitude:self.jiading.coordinate.latitude longitude:self.jiading.coordinate.longitude], [AMapGeoPoint locationWithLatitude:self.siping.coordinate.latitude longitude:self.siping.coordinate.longitude] ];
    }

    
    naviRequest.destination = [AMapGeoPoint locationWithLatitude:self.wujiao.coordinate.latitude longitude:self.wujiao.coordinate.longitude];
    */
    [self.search AMapNavigationSearch: naviRequest];
    
}





- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        overlayView.lineWidth   = 2;
        overlayView.strokeColor = [UIColor redColor];
        overlayView.lineDashPattern = @[@5, @10];
        
        return overlayView;
    }
    
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        overlayView.lineWidth   = 2;
        overlayView.strokeColor = [UIColor redColor];
        
        return overlayView;
    }
    
    return nil;
}

#pragma mark - Location
- (void)updateLocation
{
    if (!self.fFirstLocationUpdate)
    {
        [SHARE_NW_ENGINE driverUpdateLocation:self.location onSucceed:^{
            
        } onError:^(NSError *error) {
            
        }];
    }
}


#pragma mark - New Order Related
- (void)checkNewOrder
{
    if (!self.getNewOrder)
    {
        [SHARE_NW_ENGINE driverGetOrderState:GetOrderTypeNew onSucceed:^(NSArray *resultArray) {
            if (resultArray.count)
            {
                self.getNewOrder = resultArray[0];
                [self notifyNewOrder];
            }
        } onError:^(NSError *error) {
            
        }];
    }
}

- (void)notifyNewOrder
{
    [self.getNewOrderNotifyView bind:self.getNewOrder];
    self.getNewOrderNotifyView.hidden = NO;
    self.getNewOrderNotifyView.alpha = 0.f;
    [UIView animateWithDuration:0.3f animations:^
    {
        self.getNewOrderNotifyView.alpha = 1.f;
    }];
}

- (IBAction)newOrderSubmitButtonPressed:(id)sender
{
    MBProgressHUD* hud = [self showNetworkWaitingHud];
    [SHARE_NW_ENGINE driverUpdateOrderOrderId:self.getNewOrder.orderId
                                        state:OrderStateUnreceived
                                    onSucceed:^
     {
         [hud hide:YES];
         self.getNewOrder.state = OrderStateUnreceived;
         [SHARE_SETTING_MANAGER.currentUserInfo.driverInfo.orderArray addObject:self.getNewOrder];
         self.getNewOrder = nil;
         [UIView animateWithDuration:0.3f animations:^
          {
              self.getNewOrderNotifyView.alpha = 0.f;
          } completion:^(BOOL finished) {
              self.getNewOrderNotifyView.hidden = YES;
          }];
     }
     
                                      onError:^(NSError *error)
     {
         [hud hide:YES];
         [self showErrorHudWithError:error];
     }];
}




- (void)updateRouteOverlayer:(DriverInfo*)driver
{
    
    if (driver.route.count)
    {
        AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
        naviRequest.searchType = AMapSearchType_NaviDrive;
        naviRequest.requireExtension = YES;
        
        
        
        NSMutableArray* waypointsArray = [@[] mutableCopy];
        for (DriverLocationInfo* i in driver.route)
        {
            AMapGeoPoint* p =[AMapGeoPoint locationWithLatitude:i.location.latitude longitude:i.location.longitude];
            [waypointsArray addObject:p];
        }
        AMapGeoPoint* last = [waypointsArray lastObject];
        [waypointsArray removeObject:last];
        //        naviRequest.waypoints = waypointsArray;
        
//        if (self.fSearchDone)
//        {
            self.fSearchDone = NO;
            
            naviRequest.searchType = AMapSearchType_NaviDrive;
            naviRequest.requireExtension = YES;
            naviRequest.origin = [AMapGeoPoint locationWithLatitude:driver.location.latitude longitude:driver.location.longitude];
            naviRequest.destination = last;
            naviRequest.waypoints = waypointsArray;
            [self.search AMapNavigationSearch: naviRequest];
//        }
    }
    else
    {
        [self.mapView removeOverlays:self.polylines];
    }
}

- (IBAction)menuButtonPressed:(id)sender
{
    if (self.menuView.hidden)
    {
        self.menuView.hidden = NO;
        self.menuView.alpha = 0;
        [UIView animateWithDuration:0.3f animations:^{
            self.menuView.alpha = 1;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^{
            self.menuView.alpha = 0;
        } completion:^(BOOL finished) {
            self.menuView.hidden = YES;
        }];
    }
}


- (IBAction)stateChangeButtonPressed:(id)sender {
}

- (IBAction)settingButtonPressed:(id)sender {
}
@end
