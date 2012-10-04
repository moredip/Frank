//
//  MKMapView+FrankScrolling.m
//  Frank
//
//  Created by Olivier Larivain on 10/4/12.
//
//

#import "MKMapView+FrankScrolling.h"

@implementation MKMapView (FrankScrolling)

- (void) setVisibleMapRectAtX: (double) x
                            y: (double) y
                        width: (double) width
                       height: (double) height {
    MKMapRect mapRect = MKMapRectMake(x, y, width, height);
    [self setVisibleMapRect: mapRect];
}

@end
