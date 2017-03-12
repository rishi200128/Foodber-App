//
//  Truck.m
//  eHealth
//
//  Created by Ezra Kirsh on 2017-03-12.
//  Copyright © 2017 Ezra Kirsh. All rights reserved.
//

#import "Truck.h"

@implementation Truck

-(id)initWithTitle:(NSString *)title location:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    
    if (self) {
        _title = title;
        _coordinate = coordinate;
    }
    
    return self;
}

-(MKAnnotationView *)annotationView {
    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"custom"];
    
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"car"];
    
    return annotationView;
}

@end
