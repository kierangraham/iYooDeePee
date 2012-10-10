//
//  TKProgressView.h
//  PerformaSports
//
//  Created by Niall Kelly on 10/10/2012.
//  Copyright (c) 2012 Ecliptic Labs Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKProgressView : UIProgressView

@property (nonatomic, strong)	UIColor	*bgColor;
@property (nonatomic, strong)	UIColor	*bgStrokeColor;

@property (nonatomic, strong)	UIColor	*trackStrokeColor;
@property (nonatomic, strong)	UIColor	*trackColor;

@property (nonatomic)			CGFloat	lineWidth;

@end
