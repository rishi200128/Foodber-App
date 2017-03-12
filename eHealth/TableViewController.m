//
//  TableViewController.m
//  eHealth
//
//  Created by Ezra Kirsh on 2017-03-12.
//  Copyright © 2017 Ezra Kirsh. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@end

#define METERS_PER_MILE 1000.344

@implementation TableViewController

- (void)viewDidLoad {
    currentItems = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"currentItems"]];
    NSLog(@"%@", currentItems);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISwipeGestureRecognizer *rec = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    rec.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rec];
    [tableView addGestureRecognizer:rec];
    
    locationManager = [[CLLocationManager alloc]init];
    //[locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    [self->mapView setShowsUserLocation:YES];
    
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    CLLocationDegrees lat1 = 43.656594;
    CLLocationDegrees longitude1 = -79.380556;
    
    CLLocationDegrees lat2 = 43.658698;
    CLLocationDegrees longitude2 = -79.382982;
    
    CLLocationDegrees lat3 = 43.657306;
    CLLocationDegrees longitude3 = -79.387427;
    
    CLLocationDegrees lat4 = 43.657700;
    CLLocationDegrees longitude4 = -79.381712;
    
    Truck *truck = [[Truck alloc]initWithTitle:@"Second Harvest" location:(CLLocationCoordinate2D){.latitude = lat1, .longitude = longitude1}];
     Truck *truck2 = [[Truck alloc]initWithTitle:@"Second Harvest #2" location:(CLLocationCoordinate2D){.latitude = lat2, .longitude = longitude2}];
     Truck *truck3 = [[Truck alloc]initWithTitle:@"Second Harvest #3" location:(CLLocationCoordinate2D){.latitude = lat3, .longitude = longitude3}];
     Truck *truck4 = [[Truck alloc]initWithTitle:@"Second Harvest #4" location:(CLLocationCoordinate2D){.latitude = lat4, .longitude = longitude4}];
    
    [mapView addAnnotation:truck];
    [mapView addAnnotation:truck2];
    [mapView addAnnotation:truck3];
    [mapView addAnnotation:truck4];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion mapRegion;
    mapRegion.center = mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.2;
    mapRegion.span.longitudeDelta = 0.2;
    
    [mapView setRegion:mapRegion animated: YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [currentItems removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:currentItems forKey:@"currentItems"];
    [tableView reloadData];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    _currentLocation = newLocation;
    
    CLLocationCoordinate2D coord;
    coord.latitude = _currentLocation.coordinate.latitude;
    NSLog(@"%f", coord.latitude);
    coord.longitude = _currentLocation.coordinate.longitude;
    NSLog(@"%f", coord.longitude);
    MKCoordinateRegion reg = MKCoordinateRegionMakeWithDistance(coord, METERS_PER_MILE*.5, METERS_PER_MILE*.5);
    
    [mapView setRegion:reg animated:YES];
    [mapView showsUserLocation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return currentItems.count;
}

-(void)swipeRight {
    [self performSegueWithIdentifier:@"swipeRight" sender:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [currentItems objectAtIndex:indexPath.row];
    
    if ([[currentItems objectAtIndex:indexPath.row] isEqual: @"Pure Life Spring Water"]) {
        cell.imageView.image = [UIImage imageNamed:@"water.jpg"];
    }
    else if ([[currentItems objectAtIndex:indexPath.row] isEqual: @"Candy, Fuzzy Peach"]) {
        cell.imageView.image = [UIImage imageNamed:@"peaches.jpg"];
    }
    else if ([[currentItems objectAtIndex:indexPath.row] isEqual: @"Oats 'N' Honey"]) {
        cell.imageView.image = [UIImage imageNamed:@"oats.jpg"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"pelle.jpg"];
    }
    
    return cell;
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[Truck class]]) {
        Truck *truck = (Truck *)annotation;
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Custom"];
        
        annotationView.annotation = annotation;
        annotationView.image = [UIImage imageNamed:@"car"];
        
        return annotationView;
    }
    else {
        return nil;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
