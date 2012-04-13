#import <UIKit/UIKit.h>

@interface Carousel : UIView <UIScrollViewDelegate>
{
    UIPageControl *pageControl;
    NSArray *images;
}

@property (nonatomic, retain) UIPageControl *pageControl;
@property (nonatomic, retain) NSArray *images;

- (void)setup;

@end