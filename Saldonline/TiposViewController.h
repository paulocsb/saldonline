//
//  TiposViewController.h
//  Saldonline
//
//  Created by Paulo Cesar on 22/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface TiposViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate, GADBannerViewDelegate>
{
    NSArray *tipoCartaoData;
    IBOutlet UITableView *tipoCartaoTableView;
    NSArray *numSections;
}

@property(nonatomic,strong) NSArray *tipoCartaoData;
@property(nonatomic,strong) IBOutlet UITableView *tipoCartaoTableView;
@property(nonatomic,strong) NSArray *numSections;
// ADBanner e ADMob
@property (nonatomic, strong) ADBannerView *iAdBannerView;
@property (nonatomic, strong) GADBannerView *gAdBannerView;

- (IBAction)fecharModal:(id)sender;

@end
