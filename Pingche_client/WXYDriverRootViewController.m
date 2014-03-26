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
#import "POIAnnotation.h"


@interface WXYDriverRootViewController ()

@property (assign, nonatomic) int number;

@property (strong, nonatomic) MAMapView* mapView;
@property (strong, nonatomic) AMapSearchAPI* search;
@property (strong, nonatomic) POIAnnotation* driver;
@property (strong, nonatomic) POIAnnotation* siping;
@property (strong, nonatomic) POIAnnotation* jiading;
@property (strong, nonatomic) POIAnnotation* wujiao;

@property (strong, nonatomic) NSArray* polylines;
@property (assign, nonatomic) CLLocationCoordinate2D location;
@property (assign, nonatomic) BOOL fFirstLocationUpdate;
@end

@implementation WXYDriverRootViewController

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
    self.number = 1;
    self.fFirstLocationUpdate = NO;
    
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:@"7b8460b48a80fdd39af6191245021353" Delegate:self];
    
    self.mapView = [[MAMapView alloc] initWithFrame:self.contentView.bounds];
    self.mapView.delegate = self;
    [self.contentView addSubview:self.mapView];
 
    
    self.driver  = [[POIAnnotation alloc] init];
    self.driver.coordinate = CLLocationCoordinate2DMake(31.280092, 121.215714);
    self.driver.title = @"当前位置";

    self.siping = [[POIAnnotation alloc] init];
    self.siping.coordinate = CLLocationCoordinate2DMake(31.283131, 121.500832);
    self.siping.title = @"同济大学四平路校区";
    [self.mapView addAnnotations:@[self.driver, self.siping]];
    
    self.jiading = [[POIAnnotation alloc] init];
    self.jiading.coordinate = CLLocationCoordinate2DMake(31.284092, 121.215714);
    self.jiading.title = @"张先生（合乘）";
    
    self.wujiao = [[POIAnnotation alloc] init];
    self.wujiao.coordinate = CLLocationCoordinate2DMake(31.299059, 121.514160);
    self.wujiao.title = @"五角场";

    [self.mapView setZoomLevel:12.f];
    [self.mapView setCenterCoordinate:self.driver.coordinate animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView removeAnnotations:@[self.driver,self.jiading,self.siping,self.wujiao]];
    if (self.number == 1)
    {
        [self.mapView addAnnotations:@[self.driver, self.wujiao]];
    }
    else
    {
        [self.mapView addAnnotations:@[self.driver,self.jiading,self.siping,self.wujiao]];
    }
    
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
    
    
    //    annotationView.rightCalloutAccessoryView=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];    return annotationView;
    return p;
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (self.fFirstLocationUpdate)
    {
        CLLocationCoordinate2D userL = userLocation.coordinate;
        self.location = userL;
        
        [self.mapView setCenterCoordinate:userL animated:NO];
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
    [self.mapView removeOverlays:self.polylines];
    
    self.polylines = [CommonUtility polylinesForPath:response.route.paths[0]];
    [self.mapView addOverlays:self.polylines];
    
}
- (IBAction)currentButtonPressed:(id)sender
{
    [self.mapView setCenterCoordinate:self.driver.coordinate animated:YES];
}
- (IBAction)rbt:(id)sender {
//    CLLocationCoordinate2D userL = self.location;
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviDrive;
    naviRequest.requireExtension = YES;
    
    naviRequest.origin = [AMapGeoPoint locationWithLatitude:self.driver.coordinate.latitude longitude:self.driver.coordinate.longitude];
    if (self.number == 2)
    {
        naviRequest.waypoints = @[[AMapGeoPoint locationWithLatitude:self.jiading.coordinate.latitude longitude:self.jiading.coordinate.longitude], [AMapGeoPoint locationWithLatitude:self.siping.coordinate.latitude longitude:self.siping.coordinate.longitude] ];
    }

    
    naviRequest.destination = [AMapGeoPoint locationWithLatitude:self.wujiao.coordinate.latitude longitude:self.wujiao.coordinate.longitude];
    
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


@end
