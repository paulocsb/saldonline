//
//  MeusCartoesViewController.h
//  Saldonline
//
//  Created by Paulo Cesar on 29/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"

@interface MeusCartoesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ADBannerViewDelegate, GADBannerViewDelegate>
{
    NSArray* cartaoData;
    IBOutlet UITableView *cartaoTableView;
}

@property (nonatomic,strong) NSArray *cartaoData;
@property (nonatomic,strong) IBOutlet UITableView *cartaoTableView;
// ADBanner e ADMob
@property (nonatomic, strong) ADBannerView *iAdBannerView;
@property (nonatomic, strong) GADBannerView *gAdBannerView;

- (void)adicionarItem;
- (IBAction)editTableForDeletingRow:(id)sender;

@end
