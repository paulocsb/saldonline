//
//  InicialViewController.h
//  Saldonline
//
//  Created by Paulo Cesar on 20/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cartoes.h"
#import "GADBannerView.h"
#import "ActionSheetPicker.h"

@interface InicialViewController : UIViewController <ADBannerViewDelegate, GADBannerViewDelegate>
{
    UITextField *txtConsulta;
    UITextField *txtTipoCartao;
    NSArray *itensDatePicker;
    NSInteger selectedIndex;
    NSArray *tipoCartao;
    Cartoes *cartao;
    UISwitch *swSalvarCartao;
    UIScrollView *scrollView;
    UIView *mainView;
}
@property (nonatomic, strong) IBOutlet UIView *mainView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UITextField *txtConsulta;
@property (nonatomic, strong) IBOutlet UITextField *txtTipoCartao;
@property (nonatomic, retain) NSArray *itensDatePicker;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *tipoCartao;
@property (nonatomic, strong) Cartoes *cartao;
@property (nonatomic, strong) IBOutlet UISwitch *swSalvarCartao;
// ADBanner e ADMob
@property (nonatomic, strong) ADBannerView *iAdBannerView;
@property (nonatomic, strong) GADBannerView *gAdBannerView;

- (IBAction)selectTipoCartao:(id)sender;
- (IBAction)tipoCartaoButtonTapped:(UIBarButtonItem *)sender;
//- (IBAction)textFieldDidBeginEditing:(UITextField *)sender;

@end
