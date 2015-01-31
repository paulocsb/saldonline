//
//  NovoViewController.m
//  Saldonline
//
//  Created by Paulo Cesar on 20/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "NovoViewController.h"
#import "TipoCartao.h"
#import "TiposViewController.h"
#import "AppDelegate.h"
#import "Cartoes.h"
#import "Utils.h"

@interface NovoViewController ()

@end

@implementation NovoViewController

@synthesize txtNumeroCartao;
@synthesize txtNomeCartao;
@synthesize tipoCartao;
@synthesize lblTipoCartao;
@synthesize imgCartao;
@synthesize iAdBannerView;
@synthesize gAdBannerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Inicializa o iAd e AdMob
    [self bannerInicializar];
    
    lblTipoCartao.text = [[NSString alloc] initWithFormat:@"%@ %@",tipoCartao.empresa,tipoCartao.descricao];
    UIImage *icon = [UIImage imageNamed:tipoCartao.icon];
    [imgCartao setImage:icon];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setLblTipoCartao:nil];
    [self setImgCartao:nil];
    [self setTipoCartao:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ADBanner
- (void)bannerInicializar
{
    CGRect contentFrame = self.view.bounds;
    CGSize bannerSize = [[ADBannerView alloc] sizeThatFits:contentFrame.size];
    iAdBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, (contentFrame.size.height-bannerSize.height)-14, bannerSize.width, bannerSize.height)];
    iAdBannerView.delegate = self;
    iAdBannerView.hidden = YES;
    [self.view addSubview:iAdBannerView];
    
    gAdBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, (contentFrame.size.height-GAD_SIZE_320x50.height)-14, GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    gAdBannerView.adUnitID = @"a15127b42f905a1";
    gAdBannerView.hidden = YES;
    gAdBannerView.rootViewController = self;
    [self.view addSubview:gAdBannerView];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [self hideTopBanner:gAdBannerView];
    [self showTopBanner:banner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [gAdBannerView loadRequest:[GADRequest request]];
    [self hideTopBanner:iAdBannerView];
    [self showTopBanner:gAdBannerView];
}

- (void) adView:(GADBannerView *)banner didFailToReceiveAdWithError:(GADRequestError *)error{
    [self hideTopBanner:banner];
}

- (void) adViewDidReceiveAd:(GADBannerView *)banner{
    if ([iAdBannerView isHidden]) {
        [self showTopBanner:banner];
    }
}

- (void)hideTopBanner:(UIView *)banner{
    if (banner && ![banner isHidden]) {
        [UIView beginAnimations:@"bannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = YES;
    }
}

- (void)showTopBanner:(UIView *)banner{
    if (banner && [banner isHidden]) {
        [UIView beginAnimations:@"bannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
        [UIView commitAnimations];
        banner.hidden = NO;
    }
}

#pragma mark - Events Controller

- (IBAction)textFieldReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouch
{
    [txtNomeCartao resignFirstResponder];
    [txtNumeroCartao resignFirstResponder];
}

- (IBAction)salvarCartao
{
    if(![txtNumeroCartao.text isEqualToString:@""] && ![txtNomeCartao.text isEqualToString:@""])
    {
        AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        Cartoes *cartoesEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Cartoes" inManagedObjectContext:myAppDelegate.managedObjectContext];
        
        cartoesEntity.numero = txtNumeroCartao.text;
        cartoesEntity.descricao = txtNomeCartao.text;
        cartoesEntity.tipo = tipoCartao;
        
        NSError *error = nil;
        if([myAppDelegate.managedObjectContext save:&error])
        {
            [Utils exibirAlert:@"Sucesso" Mensagem:@"Cartão cadastrado com sucesso!"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"%@", error.description);
            tipoCartao = nil;
        }
    }
    else
    {
        [Utils exibirAlert:@"Atenção" Mensagem:@"Preencha corretamente as informações do cartão!"];
    }
}

#define kOFFSET_FOR_KEYBOARD 80.0

-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:txtNomeCartao] || [sender isEqual:txtNumeroCartao])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
