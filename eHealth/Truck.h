//
//  Truck.h
//  eHealth
//
//  Created by Ezra Kirsh on 2017-03-12.
//  Copyright © 2017 Ezra Kirsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Truck : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;

-(id)initWithTitle:(NSString *)title location:(CLLocationCoordinate2D)coordinate;
-(MKAnnotationView *)annotationView;

@end
