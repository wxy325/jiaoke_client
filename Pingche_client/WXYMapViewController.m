//
//  WXYViewController.m
//  Pingche_client
//
//  Created by wxy325 on 3/8/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYMapViewController.h"
#import "CommonUtility.h"
#import "LineDashPolyline.h"
#import "DriverInfoAnnotation.h"
#import "WXYCustomerInfoAnnotation.h"
#import "WXYSelectLocationViewController.h"
#import "WXYCustomerResultNotifyView.h"
#import "WXYNetworkEngine.h"
#import "UIViewController+ShowHud.h"

@interface WXYMapViewController ()


@property (assign, nonatomic) BOOL fFirstLocationUpdate;

@property (strong, nonatomic) MAMapView* mapView;
@property (strong, nonatomic) AMapSearchAPI* search;
//@property (strong, nonatomic) DriverInfoAnnotation* driver;
//@property (strong, nonatomic) DriverInfoAnnotation* destination;

@property (strong, nonatomic) NSMutableArray* driverAnnotationArray;

@property (assign, nonatomic) CGRect bottomViewRect;

//@property (strong, nonatomic) MAUserLocation* userLocation;
//@property (assign, nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) WXYTextAnnotation* currentAnnotation;
@property (strong, nonatomic) NSArray* polylines;

@property (strong, nonatomic) NSTimer* updateNearCarTimer;
@property (strong, nonatomic) NSTimer* updateOrderTimer;


@property (strong, nonatomic) OrderEntity* currentOrder;

@property (strong, nonatomic) DriverInfoAnnotation* driverAnnotation;

@property (strong, nonatomic) WXYTextAnnotation* destAnnotation;

@property (strong, nonatomic) WXYTextAnnotation* selectedDestAnnotation;






#pragma mark - 叫车专用部分
@property (strong, nonatomic) DriverInfo* systemSelectDriver;
@property (strong, nonatomic) NSMutableArray* rejectDriversArray;
#pragma mark -




@end

@implementation WXYMapViewController

#pragma mark - Getter And Setter Method
- (WXYTextAnnotation*)destAnnotation
{
    if (!_destAnnotation)
    {
        _destAnnotation = [[WXYTextAnnotation alloc] init];
    }
    return _destAnnotation;
}
- (WXYTextAnnotation*)selectedDestAnnotation
{
    if (!_selectedDestAnnotation)
    {
        _selectedDestAnnotation = [[WXYTextAnnotation alloc] init];
    }
    return _selectedDestAnnotation;
}

- (WXYTextAnnotation*)currentAnnotation
{
    if (!_currentAnnotation)
    {
        _currentAnnotation = [[WXYTextAnnotation alloc] init];
        _currentAnnotation.title = @"当前位置";
    }
    return _currentAnnotation;
}
- (DriverInfoAnnotation*)driverAnnotation
{
    if (!_driverAnnotation)
    {
        _driverAnnotation = [[DriverInfoAnnotation alloc] init];
    }
    return _driverAnnotation;
}
- (NSMutableArray*)driverAnnotationArray
{
    if (!_driverAnnotationArray)
    {
        _driverAnnotationArray = [@[] mutableCopy];
    }
    return _driverAnnotationArray;
}

- (void)setDesLocation:(CLLocationCoordinate2D)desLocation
{
    [self.mapView removeAnnotation:self.selectedDestAnnotation];
    _desLocation = desLocation;
    self.selectedDestAnnotation.coordinate = desLocation;
    [self.mapView addAnnotation:self.selectedDestAnnotation];
}
- (void)setDesTitle:(NSString *)desTitle
{
    _desTitle = desTitle;
    self.selectedDestAnnotation.title = _desTitle;
    self.searchBar.text = desTitle;
}

#pragma mark - Timer

- (NSTimer*)updateNearCarTimer
{
    if (!_updateNearCarTimer)
    {
        _updateNearCarTimer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(updateNearCar) userInfo:nil repeats:YES];
    }
    return _updateNearCarTimer;
}

- (NSTimer*)updateOrderTimer
{
    if (!_updateOrderTimer)
    {
        _updateOrderTimer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(updateOrder) userInfo:nil repeats:YES];
    }
    return _updateOrderTimer;
}

- (void)updateNearCar
{
    if (!self.fFirstLocationUpdate)
    {
        [SHARE_NW_ENGINE customerGetNearDriver:self.currentAnnotation.coordinate
                                 deltaLatitude:10.f
                                deltaLongitude:10.f
                                     onSucceed:^(NSArray *resultArray)
         {
             [self.mapView removeAnnotations:self.driverAnnotationArray];
             [self.driverAnnotationArray removeAllObjects];
             for (DriverInfo* driver in resultArray)
             {
                 if (self.currentOrder.driver.driverId &&  [driver.driverId isEqualToNumber:self.currentOrder.driver.driverId])
                 {
                     continue;
                 }
                 DriverInfoAnnotation* a = [[DriverInfoAnnotation alloc] init];
                 a.driver = driver;
                 [self.driverAnnotationArray addObject:a];
             }
             [self.mapView addAnnotations:self.driverAnnotationArray];
         }
                                       onError:^(NSError *error)
         {
             
         }];
    }
}

- (void)updateOrder
{
    [SHARE_NW_ENGINE customerGetOrderOnSucceed:^(OrderEntity *order)
    {
        self.currentOrder = order;
        [self orderRefresh];
    }
                                       onError:^(NSError *error)
    {
        self.currentOrder = nil;
        [self orderRefresh];
    }];
}

- (void)orderRefresh
{
    [self.mapView removeAnnotation:self.driverAnnotation];
    [self.mapView removeAnnotation:self.destAnnotation];
    if (self.currentOrder)
    {
        self.driverAnnotation.driver = self.currentOrder.driver;
        [self.mapView addAnnotation:self.driverAnnotation];
        
        self.destAnnotation.coordinate = self.currentOrder.locationTo;
        [self.mapView addAnnotation:self.destAnnotation];
        self.destAnnotation.title = @"目的地";
    }
}

- (void)restartAllTimer
{
    [self.updateNearCarTimer setFireDate:[NSDate distantPast]];
    [self.updateOrderTimer setFireDate:[NSDate distantPast]];
}
- (void)stopAllTimer
{
    [self.updateNearCarTimer setFireDate:[NSDate distantFuture]];
    [self.updateOrderTimer setFireDate:[NSDate distantFuture]];
}

#pragma mark - Life Cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
    [self restartAllTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignKeyboardNotifications];
    [self stopAllTimer];
}

- (void)viewDidLoad
{
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:@"7b8460b48a80fdd39af6191245021353" Delegate:self];
    
    [super viewDidLoad];
    
    self.fFirstLocationUpdate = YES;
    
	// Do any additional setup after loading the view, typically from a nib.
    self.mapView = [[MAMapView alloc] initWithFrame:self.contentView.bounds];
    self.mapView.delegate = self;
    [self.contentView addSubview:self.mapView];
    

    //定义一个标注,放到 annotations 数组

    
    self.mapView.showsUserLocation = YES;

    [self.mapView setZoomLevel:12.f];
    
    self.bottomViewRect = self.bottomView.frame;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Map
//
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"DriverInfoSegue" sender:self];
}

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
//    MAPinAnnotationView* p = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"tttt"];
    MAPinAnnotationView* p = nil;
    
    if (!p)
    {
        p = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"tttt"];
    }
    
    
//    if (annotation == self.driver)
//    {
//        p.pinColor = MAPinAnnotationColorRed;
//        p.canShowCallout = YES;
//        p.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    }
//    else if (annotation == self.destination)
//    {
//        p.pinColor = MAPinAnnotationColorGreen;
//        p.canShowCallout = YES;
//
//    }
//    else
    p.canShowCallout = YES;
    if ([self.driverAnnotationArray containsObject:annotation])
    {
        p.pinColor = MAPinAnnotationColorPurple;

    }
    else if (annotation == self.currentAnnotation)
    {
        p.pinColor = MAPinAnnotationColorGreen;
    }
    else if (annotation == self.driverAnnotation ||
             annotation == self.destAnnotation ||
             annotation == self.selectedDestAnnotation)
    {
        p.pinColor = MAPinAnnotationColorRed;
    }


//    annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];    return annotationView;
    return p;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    self.currentAnnotation.coordinate = userLocation.coordinate;
//    CLLocationCoordinate2D userL = userLocation.coordinate;
//    self.location = userL;
    
//    [self.mapView setCenterCoordinate:userL animated:NO];
    
    if (self.fFirstLocationUpdate)
    {
        [self.mapView addAnnotation:self.currentAnnotation];
        self.fFirstLocationUpdate = NO;
        [self currentButtonPressed:nil];
    }

    
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

#pragma mark - Search
-(void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    self.polylines = [CommonUtility polylinesForPath:response.route.paths[0]];
    [self.mapView addOverlays:self.polylines];

}

#pragma mark - IBAction
- (IBAction)currentButtonPressed:(id)sender
{
    if (!self.fFirstLocationUpdate)
    {
        [self.mapView setCenterCoordinate:self.currentAnnotation.coordinate animated:YES];
    }
}
- (IBAction)rbt:(id)sender {
    if (self.fFirstLocationUpdate)
    {
        return;
    }
    CLLocationCoordinate2D userL = self.currentAnnotation.coordinate;
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviDrive;
    naviRequest.requireExtension = YES;
    
//    naviRequest.origin = [AMapGeoPoint locationWithLatitude:self.driver.coordinate.latitude longitude:self.driver.coordinate.longitude];
    
//    naviRequest.waypoints = @[[AMapGeoPoint locationWithLatitude:userL.latitude longitude:userL.longitude]];
    
//    naviRequest.destination = [AMapGeoPoint locationWithLatitude:self.destination.coordinate.latitude longitude:self.destination.coordinate.longitude];
    
//    [self.search AMapNavigationSearch: naviRequest];

}

- (IBAction)menuButtonPressed:(id)sender
{
    [self hideKeyboard];
    if (self.menuView.hidden)
    {
        self.menuView.hidden = NO;
        self.menuView.alpha = 0.f;
        [UIView animateWithDuration:0.3f animations:^
        {
            self.menuView.alpha = 1.f;
        } completion:^(BOOL finished) {
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3f animations:^
         {
             self.menuView.alpha = 0.f;
         } completion:^(BOOL finished)
        {
            self.menuView.hidden = YES;
             
         }];
    }
}

#pragma mark - Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
- (void)resignKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect rect = self.bottomViewRect;
    rect.origin.y = rect.origin.y - kbSize.height;
    
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.3f animations:^{
        self.bottomView.frame = self.bottomViewRect;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)hideKeyboard
{
    [self.maleNumberTextField resignFirstResponder];
    [self.femaleNumberTextField resignFirstResponder];
}
- (IBAction)showSearchView:(id)sender
{
    [self hideKeyboard];
    WXYSelectLocationViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WXYSelectLocationViewController"];
    vc.mapVC = self;
    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - IBAction
- (IBAction)createOrderButtonPressed:(id)sender
{
    OrderType type = 0;
    if (self.typeSegment.selectedSegmentIndex == 0)
    {
        type = OrderTypeDache;
    }
    else
    {
        type = OrderTypePingche;
    }
    
    MBProgressHUD* hud = [self showNetworkWaitingHud];
    
    [SHARE_NW_ENGINE customerCreateOrder:self.systemSelectDriver.driverId
                                    type:type
                              maleNumber:@(self.maleNumberTextField.text.intValue)
                            femaleNumber:@(self.femaleNumberTextField.text.intValue)
                                    from:self.currentAnnotation.coordinate
                                      to:self.desLocation
                               onSucceed:^(OrderEntity *order)
    {
        [hud hide:YES];
        [self showSuccessHudWithText:@"创建成功"];
        [self orderRefresh];
        self.customerResultNotifyView.hidden = YES;
        self.systemSelectDriver = nil;
        self.rejectDriversArray = nil;
    }
                                 onError:^(NSError *error)
    {
        [hud hide:YES];
        [self showErrorHudWithError:error];
    }];
}

- (IBAction)researchButtonPressed:(id)sender
{
    [self.rejectDriversArray addObject:self.systemSelectDriver.driverId];
    self.systemSelectDriver = nil;
    
    OrderType type = 0;
    if (self.typeSegment.selectedSegmentIndex == 0)
    {
        type = OrderTypeDache;
    }
    else
    {
        type = OrderTypePingche;
    }
    
    MBProgressHUD* hud = [self showNetworkWaitingHud];
    
    [SHARE_NW_ENGINE customerSearchDriver:self.currentAnnotation.coordinate to:self.desLocation type:OrderTypeDache reject:self.rejectDriversArray onSucceed:^(DriverInfo *driver) {
        [hud hide:YES];
        self.systemSelectDriver = driver;
        self.rejectDriversArray = [@[] mutableCopy];
        self.customerResultNotifyView.hidden = NO;
    }
                                  onError:^(NSError *error)
     {
         [self showErrorHudWithError:error];
     }];
    
}

- (IBAction)submitButtonPressed:(id)sender
{
    if (!self.maleNumberTextField.text.length
        || !self.maleNumberTextField.text.length
        || !self.desTitle.length)
    {
        return;
    }
    
    OrderType type = 0;
    if (self.typeSegment.selectedSegmentIndex == 0)
    {
        type = OrderTypeDache;
    }
    else
    {
        type = OrderTypePingche;
    }
    
    MBProgressHUD* hud = [self showNetworkWaitingHud];
        
    [SHARE_NW_ENGINE customerSearchDriver:self.currentAnnotation.coordinate to:self.desLocation type:OrderTypeDache reject:@[] onSucceed:^(DriverInfo *driver) {
        [hud hide:YES];
        self.systemSelectDriver = driver;
        self.rejectDriversArray = [@[] mutableCopy];
        self.customerResultNotifyView.hidden = NO;
    }
                                  onError:^(NSError *error)
    {
        [self showErrorHudWithError:error];
    }];
}


@end
