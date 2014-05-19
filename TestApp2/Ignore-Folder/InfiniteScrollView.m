//
//  InfiniteScrollView.m
//  Central
//
//  Created by Julie Soliman on 11/4/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "InfiniteScrollView.h"

@interface InfiniteScrollView ()
@property (nonatomic, strong) NSMutableArray *visibleBrands;
@property (nonatomic, strong) UIView *brandContainerView;
@property (nonatomic, strong) NSMutableArray *brandImageViews;
@property int imageIndex;

@end

@implementation InfiniteScrollView

- (void)doNotUseParameter:(int)i
{
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        self.contentSize = CGSizeMake(5000, self.frame.size.height);
        
        _visibleBrands = [[NSMutableArray alloc] init];
        
        _brandContainerView = [[UIView alloc] init];
        self.brandContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
        [self addSubview:self.brandContainerView];
        
        [self.brandContainerView setUserInteractionEnabled:NO];
        
        // hide horizontal scroll indicator so our recentering trick is not revealed
        [self setShowsHorizontalScrollIndicator:NO];
        
        [self initImageViews];
    }
    return self;
}

-(void) initImageViews{
    _brandImageViews = [[NSMutableArray alloc] init];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_a1.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_coolwhip.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_planters.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_caprisun.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_philadelphia.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_cheezwhiz.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_Clauseen.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_countrytimelemonade.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_jell-o.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_kool-aid.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_miraclewhip.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_oscarmayer.jpg"]];
    [self.brandImageViews addObject:[UIImage imageNamed:@"logo_gevalia.jpg"]];

    self.imageIndex = 0;
}

#pragma mark - Layout

// recenter content periodically to achieve impression of infinite scrolling
- (void)recenterIfNecessary
{
    CGPoint currentOffset = [self contentOffset];
    CGFloat contentWidth = [self contentSize].width;
    CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (distanceFromCenter > (contentWidth / 4.0))
    {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        
        // move content by the same amount so it appears to stay still
        for (UIImageView *imageView in self.visibleBrands) {
            CGPoint center = [self.brandContainerView convertPoint:imageView.center toView:self];
            center.x += (centerOffsetX - currentOffset.x);
            imageView.center = [self convertPoint:center toView:self.brandContainerView];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self recenterIfNecessary];
    
    // tile content in visible bounds
    CGRect visibleBounds = [self convertRect:[self bounds] toView:self.brandContainerView];
//    NSLog(@"visible bounds: %@", visibleBounds);
    CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
    CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
    
    [self tileImageViewsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
}


- (void)tileImageViewsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([self.visibleBrands count] == 0)
    {
        [self placeNewImageViewOnRight:minimumVisibleX];
    }
    
    // add labels that are missing on right side
    UIImageView *lastImageView = [self.visibleBrands lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastImageView frame]);
    while (rightEdge < maximumVisibleX)
    {
        rightEdge = [self placeNewImageViewOnRight:rightEdge];
    }
    
    // add labels that are missing on left side
    UIImageView *firstImageView = self.visibleBrands[0];
    CGFloat leftEdge = CGRectGetMinX([firstImageView frame]);
    while (leftEdge > minimumVisibleX)
    {
        leftEdge = [self placeNewImageViewOnLeft:leftEdge];
    }
    
    // remove labels that have fallen off right edge
    lastImageView = [self.visibleBrands lastObject];
    while ([lastImageView frame].origin.x > maximumVisibleX)
    {
        [lastImageView removeFromSuperview];
        [self.visibleBrands removeLastObject];
        lastImageView = [self.visibleBrands lastObject];
    }
    
    // remove labels that have fallen off left edge
    firstImageView = self.visibleBrands[0];
    while (CGRectGetMaxX([firstImageView frame]) < minimumVisibleX)
    {
        [firstImageView removeFromSuperview];
        [self.visibleBrands removeObjectAtIndex:0];
        firstImageView = self.visibleBrands[0];
    }
}

- (UIImageView *)insertImageView
{
    self.imageIndex = self.imageIndex % [self.brandImageViews count];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 50)];
    
    [imageView setImage:self.brandImageViews[self.imageIndex]];
    [self.brandContainerView addSubview:imageView];
    
    self.imageIndex++;
    return imageView;
}

- (CGFloat)placeNewImageViewOnRight:(CGFloat)rightEdge
{
    UIImageView *imageView = [self insertImageView];
    [self.visibleBrands addObject:imageView]; // add rightmost label at the end of the array
    
    CGRect frame = [imageView frame];
    frame.origin.x = rightEdge;
    frame.origin.y = [self.brandContainerView bounds].size.height - frame.size.height;
    [imageView setFrame:frame];
    
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewImageViewOnLeft:(CGFloat)leftEdge
{
    UIImageView *imageView = [self insertImageView];
    [self.visibleBrands insertObject:imageView atIndex:0]; // add leftmost label at the beginning of the array
    
    CGRect frame = [imageView frame];
    frame.origin.x = leftEdge - frame.size.width;
    frame.origin.y = [self.brandContainerView bounds].size.height - frame.size.height;
    [imageView setFrame:frame];
    
    return CGRectGetMinX(frame);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
