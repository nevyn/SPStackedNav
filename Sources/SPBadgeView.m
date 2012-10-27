//
//  SPBadgeView.m
//  Spotify
//
//  Created by Joachim Bengtsson on 2010-04-14.
//  Copyright 2010 Spotify. All rights reserved.
//

#import "SPBadgeView.h"


@implementation SPBadgeView
+(UIFont*)badgeFont;
{
    return [UIFont boldSystemFontOfSize:15];
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame]))
        return nil;
    
    self.count = 0;
    self.opaque = NO;
    self.font = SPBadgeView.badgeFont;
    self.textColor = [UIColor blackColor];
    self.textTransparentOnHighlightedAndSelected = NO;
    self.userInteractionEnabled = NO;
    
    return self;
}

-(void)setCount:(NSInteger)count;
{
    _count = count;
    self.text = [NSString stringWithFormat:@"%d", count];
}

-(void)setText:(NSString *)text;
{
    _text = [text copy];
    // Resize to fit the badge
    CGRect r = self.frame;
    r.size = [self.text sizeWithFont:self.font];
    r.size.width += 16;
    r.size.height += 2;

    if(self.backgroundImage){
        if(r.size.width < self.backgroundImage.size.width)
            r.size.width = self.backgroundImage.size.width;
        if(r.size.height < self.backgroundImage.size.height)
            r.size.height = self.backgroundImage.size.height;
    }
    self.frame = CGRectIntegral(r);
    
    self.hidden = !text.length > 0;
    
    [self.superview setNeedsLayout];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    float r = self.bounds.size.height /2.;
    UIImage *image = self.backgroundImage;
    if(self.highlighted || self.selected){
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        image = self.highlightedBackgroundImage;
    } else {
        CGContextSetFillColor(ctx, (CGFloat[4]){0.369, 0.369, 0.369, 1});
    }
    
    if(image){
        [image drawInRect:self.bounds];
    } else {
        CGContextBeginPath(ctx);
        
        CGContextAddArc(ctx, r, r, r, M_PI / 2 , 3 * M_PI / 2, NO);
        CGContextAddArc(ctx, self.bounds.size.width - r, r, r, 3 * M_PI / 2, M_PI / 2, NO);
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
    }
    
    UIColor *textColor = self.textColor;
    if ((self.highlighted || self.selected) &&
        self.textTransparentOnHighlightedAndSelected) {
        CGContextSetBlendMode(ctx, kCGBlendModeDestinationOut);
        textColor = [UIColor blackColor];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextSetFillColorSpace(ctx, colorSpace);
    [textColor set];
    CGColorSpaceRelease(colorSpace);
    
    CGRect textRect = self.bounds;
    CGSize textSize = [self.text sizeWithFont:self.font];
    textRect.origin.y = textRect.size.height / 2 - textSize.height / 2;
    [self.text drawInRect:textRect
                 withFont:self.font
            lineBreakMode:UILineBreakModeClip
                alignment:UITextAlignmentCenter];
}

@end

