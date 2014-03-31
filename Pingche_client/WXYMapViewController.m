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
#import "POIAnnotation.h"
#import "WXYSelectLocationViewController.h"
#import "WXYCustomerResultNotifyView.h"

@interface WXYMapViewController ()


@property (assign, nonatomic) BOOL fFirstLocationUpdate;

@property (strong, nonatomic) MAMapView* mapView;
@property (strong, nonatomic) AMapSearchAPI* search;
@property (strong, nonatomic) POIAnnotation* driver;
@property (strong, nonatomic) POIAnnotation* destination;

@property (strong, nonatomic) NSMutableArray* otherDrivers;

@property (assign, nonatomic) CGRect bottomViewRect;

//@property (strong, nonatomic) MAUserLocation* userLocation;
@property (assign, nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) POIAnnotation* userLocation;
@property (strong, nonatomic) NSArray* polylines;
@end

@implementation WXYMapViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignKeyboardNotifications];
}

- (void)viewDidLoad
{
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:@"7b8460b48a80fdd39af6191245021353" Delegate:self];
    
    
    
//    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init]; poiRequest.searchType = AMapSearchType_PlaceKeyword; poiRequest.keywords = @"五角场";
//    poiRequest.city = @[@"shanghai"];
//    poiRequest.requireExtension = YES;
//    [self.search AMapPlaceSearch: poiRequest];
    self.otherDrivers = [@[] mutableCopy];
    
    [super viewDidLoad];
    
    self.fFirstLocationUpdate = YES;
    
	// Do any additional setup after loading the view, typically from a nib.
    self.mapView = [[MAMapView alloc] initWithFrame:self.contentView.bounds];
    self.mapView.delegate = self;
    [self.contentView addSubview:self.mapView];
    

    //定义一个标注,放到 annotations 数组

    
    
//    MAPointAnnotation *red = [[MAPointAnnotation alloc] init];
//    red.coordinate = CLLocationCoordinate2DMake(39.911447, 116.406026);
//    red.title = @"Red";
//    [self.mapView addAnnotation:red];
//    self.mapView.showsUserLocation = YES;

    [self.mapView setZoomLevel:12.f];
    
    
    self.driver  = [[POIAnnotation alloc] init];
    self.driver.coordinate = CLLocationCoordinate2DMake(31.280092, 121.215714);
    self.driver.title = @"郭师傅";
    self.driver.subTitle = @"18817366967";
    self.destination = [[POIAnnotation alloc] init];
    self.destination.coordinate = CLLocationCoordinate2DMake(31.283131, 121.500832);
    self.destination.title = @"目的地";
    [self.mapView addAnnotations:@[self.driver, self.destination]];
    
    
    MAPointAnnotation* p = [[MAPointAnnotation alloc] init];
    p.coordinate = CLLocationCoordinate2DMake(31.283192, 121.211724);
    [self.otherDrivers addObject:p];
    p = [[MAPointAnnotation alloc] init];
    p.coordinate = CLLocationCoordinate2DMake(31.286492, 121.213734);
    [self.otherDrivers addObject:p];
    p = [[MAPointAnnotation alloc] init];
    p.coordinate = CLLocationCoordinate2DMake(31.289392, 121.218744);
    [self.otherDrivers addObject:p];
    p = [[MAPointAnnotation alloc] init];
    p.coordinate = CLLocationCoordinate2DMake(31.281292, 121.215974);
    [self.otherDrivers addObject:p];
    
    self.userLocation = [[POIAnnotation alloc] init];
    self.userLocation.coordinate = CLLocationCoordinate2DMake(31.284092, 121.215714);
    self.userLocation.title = @"当前位置";
    [self.mapView addAnnotation:self.userLocation];
    
    [self.mapView addAnnotations:self.otherDrivers];

    self.location = self.userLocation.coordinate;
    [self currentButtonPressed:nil];
    
    
    
    self.bottomViewRect = self.bottomView.frame;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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
    
    
    if (annotation == self.driver)
    {
        p.pinColor = MAPinAnnotationColorRed;
        p.canShowCallout = YES;
        p.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else if (annotation == self.destination)
    {
        p.pinColor = MAPinAnnotationColorGreen;
        p.canShowCallout = YES;

    }
    else if ([self.otherDrivers containsObject:annotation])
    {
        p.pinColor = MAPinAnnotationColorPurple;
    }
    else
    {
        p.pinColor = MAPinAnnotationColorGreen;
        p.canShowCallout = YES;
    }


//    annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];    return annotationView;
    return p;
}
//
//- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
//{
//    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
//    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
//    NSString *strPoi = @"";
//    for (AMapPOI *p in response.pois)
//    {
//        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description];
//    }
//    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
//    NSLog(@"Place: %@", result);
//
//}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (self.fFirstLocationUpdate)
    {
        CLLocationCoordinate2D userL = userLocation.coordinate;
        self.location = userL;
        
        [self.mapView setCenterCoordinate:self.location animated:NO];
        self.fFirstLocationUpdate = NO;
        
        
        
         
//        AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init]; naviRequest.searchType = AMapSearchType_NaviDrive;
//        naviRequest.requireExtension = YES;
//        naviRequest.origin = [AMapGeoPoint locationWithLatitude:39.994949 longitude:116.447265];
//        naviRequest.destination = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
//        [self.search AMapNavigationSearch: naviRequest];
    }

}

-(void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    self.polylines = [CommonUtility polylinesForPath:response.route.paths[0]];
    [self.mapView addOverlays:self.polylines];

}
- (IBAction)currentButtonPressed:(id)sender
{
    [self.mapView setCenterCoordinate:self.location animated:YES];
}
- (IBAction)rbt:(id)sender {
    CLLocationCoordinate2D userL = self.location;
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviDrive;
    naviRequest.requireExtension = YES;
    
    naviRequest.origin = [AMapGeoPoint locationWithLatitude:self.driver.coordinate.latitude longitude:self.driver.coordinate.longitude];
    
    naviRequest.waypoints = @[[AMapGeoPoint locationWithLatitude:userL.latitude longitude:userL.longitude]];
    
    naviRequest.destination = [AMapGeoPoint locationWithLatitude:self.destination.coordinate.latitude longitude:self.destination.coordinate.longitude];
    
    [self.search AMapNavigationSearch: naviRequest];

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
- (IBAction)createOrderButtonPressed:(id)sender {
}

- (IBAction)researchButtonPressed:(id)sender {
}

@end
