//
//  ViewController.h
//  iYooDeePee
//
//  Created by Kieran Graham on 05/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncUdpSocket.h"
#import "GCDAsyncSocket.h"

@interface ViewController : UIViewController {
    IBOutlet UILabel *ipAddresslabel;
	IBOutlet UILabel *sectionNumberLabel;
	IBOutlet UILabel *countNumberLabel;
	IBOutlet UILabel *totalCountNumberLabel;
}

@end
