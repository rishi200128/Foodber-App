//
//  TableViewController.h
//  eHealth
//
//  Created by Ezra Kirsh on 2017-03-12.
//  Copyright © 2017 Ezra Kirsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Truck.h"

@interface TableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate> {
    NSMutableArray *currentItems;
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UITableView *tableView;
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) CLLocation *currentLocation;

@end
