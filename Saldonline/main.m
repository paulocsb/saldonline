//
//  main.m
//  Saldonline
//
//  Created by Paulo Cesar on 18/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Pixate/Pixate.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [Pixate licenseKey:@"4SCIV-NUPO2-AADTB-AA5L2-H9PT9-EL5CH-LBS6C-D2GE2-L8KRP-951L4-66U40-2OCC0-U04H1-540LM-AGQUE-V2" forUser:@"paulo_csb@yahoo.com.br"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
