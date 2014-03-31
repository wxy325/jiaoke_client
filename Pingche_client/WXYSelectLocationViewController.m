//
//  WXYSelectLocationViewController.m
//  Pingche_client
//
//  Created by wxy325 on 3/8/14.
//  Copyright (c) 2014 wxy. All rights reserved.
//

#import "WXYSelectLocationViewController.h"
#import "WXYMapViewController.h"
#import "UIViewController+ShowHud.h"


@interface WXYSelectLocationViewController ()

@property (strong, nonatomic) NSMutableArray* resultArray;
@property (strong, nonatomic) AMapSearchAPI* search;

@property (strong, nonatomic) MBProgressHUD* hud;
@end

@implementation WXYSelectLocationViewController

#pragma mark - Getter And Setter Method
- (NSMutableArray*)resultArray
{
    if (!_resultArray)
    {
        _resultArray = [@[] mutableCopy];
    }
    return _resultArray;
}

#pragma mark - Init Method
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
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:@"7b8460b48a80fdd39af6191245021353" Delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITable View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 0)
//    {
//        return @"常用位置";
//    }
//    else
//    {
//        return @"搜索结果";
//    }
//}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"AAA"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AAA"];
    }
    AMapPOI *p = self.resultArray[indexPath.row];


    cell.textLabel.text = p.name;
    cell.detailTextLabel.text = p.address;
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapPOI *p = self.resultArray[indexPath.row];
    CLLocationCoordinate2D l;
    l.latitude = p.location.latitude;
    l.longitude = p.location.longitude;
    self.mapVC.desLocation = l;
    self.mapVC.desTitle = p.name;
    [self backButtonPressed:nil];
}

#pragma mark - UISearchBar Delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = searchBar.text;
    poiRequest.city = @[@"shanghai"];
    poiRequest.requireExtension = YES;
    [self.search AMapPlaceSearch: poiRequest];
    
    if (self.hud)
    {
        [self.hud hide:YES];
    }
    self.hud = [self showNetworkWaitingHud];
}

#pragma mark - AMapSearchDelegate
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    [self.hud hide:YES];
    self.hud = nil;
    [self.resultArray removeAllObjects];
    [self.resultArray addObjectsFromArray:response.pois];
    
    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
        strPoi = [NSString stringWithFormat:@"%@\nPOI: %@", strPoi, p.description]; }
    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
//    NSLog(@"Place: %@", result);
    [self.tableView reloadData];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
