//
//  CarouselViewController.m
//  Controls
//
//  Created by David van der Bokke on 4/13/12.
//  Copyright (c) 2012 ThoughtWorks. All rights reserved.
//

#import "CarouselViewController.h"
#import "Carousel.h"

@implementation CarouselViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Carousel";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Initialize carousel object with frame size of images
    Carousel *carousel = [[Carousel alloc] initWithFrame:self.view.bounds];
    
    // Add some images to carousel, we are passing autoreleased NSArray
    [carousel setImages:[NSArray arrayWithObjects:@"image0.png", @"image1.png", @"image2.png", @"image3.png", @"image4.png", nil]];
    
    // Add carousel to view
    [self.view addSubview:carousel];
    
    // Cleanup
    [carousel release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


@end
