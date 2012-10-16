//
//  PerformanceViewController.h
//  iYooDeePee
//
//  Created by Kieran Graham on 05/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GCDAsyncUdpSocket.h"
#import "WSOSCPacket.h"

#import "AsyncUdpSocket.h"

#import "OSCConnectionDelegate.h"
#import "OSCConnection.h"
#import "OSCDispatcher.h"
#import "OSCPacket.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

@class GradientButton;
@class PDColoredProgressView;

@interface PerformanceViewController : UIViewController {
    IBOutlet UILabel *ipAddressLabel;
    IBOutlet UILabel *instrumentIDLabel;
	IBOutlet UILabel *sectionNumberLabel;
	IBOutlet UILabel *countNumberLabel;
	IBOutlet UILabel *totalCountNumberLabel;
    IBOutlet PDColoredProgressView *progressIndicator;
    IBOutlet GradientButton *reconnectButton;
}

- (void) sendDeviceInfo;
- (IBAction) reconnectAction:(UIButton*) button;

@end
