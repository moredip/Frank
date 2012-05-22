#import "Carousel.h"

@implementation Carousel

@synthesize pageControl;
@synthesize images;

#pragma mark - Override images setter

- (void)setImages:(NSArray *)newImages
{
    if (newImages != images)
    {
        [newImages retain];
        [images release];
        images = newImages;
        
        [self setup];
    }
}

#pragma mark - Carousel setup

- (void)setup
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [scrollView setDelegate:self];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setPagingEnabled:YES];
    [scrollView setBounces:NO];
    
    CGSize scrollViewSize = scrollView.frame.size;
    
    for (NSInteger i = 0; i < [self.images count]; i++)
    {
        CGRect slideRect = CGRectMake(scrollViewSize.width * i, 0, scrollViewSize.width, scrollViewSize.height);
        
        UIView *slide = [[UIView alloc] initWithFrame:slideRect];
        [slide setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
        imageView.tag = 100+i;
        [imageView setImage:[UIImage imageNamed:[self.images objectAtIndex:i]]];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [slide addSubview:imageView];
        [imageView release];
        
        [scrollView addSubview:slide];
        [slide release];
    }
    
    UIPageControl *tempPageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollViewSize.height - 20, scrollViewSize.width, 20)];
    [self setPageControl:tempPageControll];
    [tempPageControll release];
    [self.pageControl setNumberOfPages:[self.images count]];
    [scrollView setContentSize:CGSizeMake(scrollViewSize.width * [self.images count], scrollViewSize.height)];
    
    [self addSubview:scrollView];
    [scrollView release];
    [self addSubview:self.pageControl];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self.pageControl setCurrentPage:page];
}

#pragma mark - Cleanup

- (void)dealloc
{
    [pageControl release];
    [images release];
    [super dealloc];
}

@end