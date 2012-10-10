//
//  DashboardViewController.h
//  iYooDeePee
//
//  Created by Kieran Graham on 08/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewController : UIViewController {
    IBOutlet UIButton    *connectButton;
    IBOutlet UITextField *instrumentField;
}

- (IBAction) connectAction:(UIButton *) button;

- (void) oscSendClientConnectionInfo;

@end
