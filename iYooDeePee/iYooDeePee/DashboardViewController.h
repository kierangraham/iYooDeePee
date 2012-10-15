//
//  DashboardViewController.h
//  iYooDeePee
//
//  Created by Kieran Graham on 08/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GradientButton;
@interface DashboardViewController : UIViewController {
    IBOutlet GradientButton    *connectButton;
    IBOutlet UITextField *instrumentField;
	IBOutlet UITextField *ipField;
}

- (IBAction) connectAction:(UIButton *) button;

- (void) oscSendClientConnectionInfo;

@end
