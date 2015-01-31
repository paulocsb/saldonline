//
//  NovoViewController.h
//  Saldonline
//
//  Created by Paulo Cesar on 20/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TipoCartao.h"
#import "GADBannerView.h"

@interface NovoViewController : UIViewController <ADBannerViewDelegate, GADBannerViewDelegate>
{
    IBOutlet UITextField *txtNomeCartao;
    IBOutlet UITextField *txtNumeroCartao;
    IBOutlet UILabel *lblTipoCartao;
    IBOutlet UIImageView *imgCartao;
    TipoCartao *tipoCartao;
}

@property (strong, nonatomic) IBOutlet UITextField *txtNomeCartao;
@property (strong, nonatomic) IBOutlet UITextField *txtNumeroCartao;
@property (strong, nonatomic) TipoCartao *tipoCartao;
@property (strong, nonatomic) IBOutlet UILabel *lblTipoCartao;
@property (strong, nonatomic) IBOutlet UIImageView *imgCartao;
// ADBanner e ADMob
@property (nonatomic, strong) ADBannerView *iAdBannerView;
@property (nonatomic, strong) GADBannerView *gAdBannerView;

- (IBAction)textFieldReturn:(id)sender;
- (IBAction)backgroundTouch;
- (IBAction)salvarCartao;

@end
