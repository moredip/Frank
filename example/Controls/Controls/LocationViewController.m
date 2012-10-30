//
//  LocationViewController.m
//  Controls
//
//  Created by Pete Hodgson on 10/30/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()
@property (retain, nonatomic) IBOutlet UILabel *locationLabel;

@end


@implementation LocationViewController{
    CLLocationManager *_locationManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [_locationManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [_locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_locationLabel release];
    [_locationManager release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setLocationLabel:nil];
    [super viewDidUnload];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    self.locationLabel.text = [NSString stringWithFormat:@"Current Location: %f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude];
}
@end
