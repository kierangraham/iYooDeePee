//
//  TKProgressView.m
//  PerformaSports
//
//  Created by Niall Kelly on 10/10/2012.
//  Copyright (c) 2012 Ecliptic Labs Ltd. All rights reserved.
//

#import "TKProgressView.h"

@implementation TKProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
		_lineWidth = 2.0;
    }
    return self;
}

- (id)initWithDefaultSize {
    return [self initWithFrame:CGRectMake(0.0f, 0.0f, 37.0f, 37.0f)];
}

- (void)drawRect:(CGRect)rect {
    CGRect allRect = self.bounds;
    CGRect circleRect = CGRectMake(allRect.origin.x + 2, allRect.origin.y + 2, allRect.size.width - 4,
                                   allRect.size.height - 4);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIColor *bgColor = _bgColor == nil ? [UIColor whiteColor] : _bgColor;
	UIColor *trackColor = _trackColor == nil ? [UIColor colorWithWhite:1.0 alpha:0.1] : _trackColor;
	UIColor *bgStrokeColor = _bgStrokeColor == nil ? [UIColor whiteColor] : _bgStrokeColor;
	UIColor *trackStrokeColor = _trackStrokeColor == nil ? [UIColor colorWithWhite:1.0 alpha:0.1] : _trackStrokeColor;
	
    // Draw background
	CGContextSetStrokeColorWithColor(context, bgStrokeColor.CGColor);
	CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextSetLineWidth(context, _lineWidth);
    CGContextFillEllipseInRect(context, circleRect);
    CGContextStrokeEllipseInRect(context, circleRect);
	
    // Draw progress
    float x = (allRect.size.width / 2);
    float y = (allRect.size.height / 2);
	
	CGContextSetStrokeColorWithColor(context, trackColor.CGColor);
	CGContextSetFillColorWithColor(context, trackStrokeColor.CGColor);
    CGContextMoveToPoint(context, x, y);
    CGContextAddArc(context, x, y, (allRect.size.width - 4) / 2, -(M_PI / 2), (self.progress * 2 * M_PI) - M_PI / 2, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

- (void)setBgColor:(UIColor *)bgColor {
#if !__has_feature(objc_arc)
	_bgColor = [bgColor retain];
#endif
	[self setNeedsDisplay];
}

- (void)setBgStrokeColor:(UIColor *)bgStrokeColor {
#if !__has_feature(objc_arc)
	_bgStrokeColor = [bgStrokeColor retain];
#endif
	[self setNeedsDisplay];
}

- (void)setTrackColor:(UIColor *)trackColor {
#if !__has_feature(objc_arc)
	_trackColor	= [trackColor retain];
#endif
	[self setNeedsDisplay];
}

- (void)setTrackStrokeColor:(UIColor *)trackStrokeColor {
#if !__has_feature(objc_arc)
	_trackStrokeColor	= [trackStrokeColor retain];
#endif
	[self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
	_lineWidth = lineWidth;
	[self setNeedsDisplay];
}

@end
