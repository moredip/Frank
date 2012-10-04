//
//  MKMapView+FrankScrolling.h
//  Frank
//
//  Created by Olivier Larivain on 10/4/12.
//
//
#import <MapKit/MapKit.h>


@interface MKMapView (FrankScrolling)

- (void) frank_setVisibleMapRectAtX: (double) x
                                  y: (double) y
                              width: (double) width
                             height: (double) height;

@end
