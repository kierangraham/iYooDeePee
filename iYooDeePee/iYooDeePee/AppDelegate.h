//
//  AppDelegate.h
//  iYooDeePee
//
//  Created by Kieran Graham on 05/10/2012.
//  Copyright (c) 2012 Ecliptic Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OSCConnectionDelegate.h"
#import "OSCConnection.h"
#import "OSCDispatcher.h"
#import "OSCPacket.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow       *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) NSString       *instrumentID;
@property (strong, nonatomic) NSString       *ipAddress;

+ (UIWindow *) window;
+ (AppDelegate *) delegate;

- (NSString *) ipAddress;

@end
