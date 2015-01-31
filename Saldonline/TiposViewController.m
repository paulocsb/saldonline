//
//  TiposViewController.m
//  Saldonline
//
//  Created by Paulo Cesar on 22/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "TiposViewController.h"
#import "AppDelegate.h"
#import "NovoViewController.h"
#import "TipoCartao.h"
#import "Utils.h"

@interface TiposViewController ()

@end

@implementation TiposViewController

@synthesize numSections;
@synthesize tipoCartaoData;
@synthesize tipoCartaoTableView;
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
    
    numSections = [[NSArray alloc] initWithObjects:@"Visa",@"Ticket", nil];
    
    [self obterItens];
    
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
//    self.tipoCartaoTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setTipoCartaoData:nil];
    [self setTipoCartaoTableView:nil];
    [self setNumSections:nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
//    if([tipoCartaoData count] > 0)
//        return 2;
//    else
        return 1; // Valor fixo para apenas um seção
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
//    if([[numSections objectAtIndex:section] isEqualToString:@"Visa"])
//    {
        return [[[NSString alloc] initWithFormat:@"cartões %@-vale", [numSections objectAtIndex:section]] uppercaseString];
//    }
//    else
//    {
//        return [[[NSString alloc] initWithFormat:@"cartões %@", [numSections objectAtIndex:section]] uppercaseString];
//    }
}

// retorna o tamanho da mutableArray
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tipoCartaoData count] > 0)
    {
        int contador = 0;

        NSString *Key = [numSections objectAtIndex:section];
        
        for(TipoCartao *str in tipoCartaoData)
        {
            if([str.empresa isEqualToString:Key])
                contador++;
        }
        
        return contador;
    }
    else
        return [tipoCartaoData count];
}

// implementação das células do tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idCell = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idCell];
    }
    
    // Captura a linha que está sendo criada (número)
    NSInteger row = [indexPath row];
    
    if([tipoCartaoData count] > 0)
    {
        // Captura a seção que está sendo acessada
        NSInteger section = [indexPath section];

        // Captura o nome da seção (índice)
        NSString *key = [numSections objectAtIndex:section];
        
        // Captura a linha que está sendo criada (texto)
        NSMutableArray *sectionValues = [[NSMutableArray alloc] init];
        
        for (TipoCartao *str in tipoCartaoData)
        {
            if([str.empresa isEqualToString:key])
                [sectionValues addObject:str];
        }
        
        TipoCartao *tipocartaoEntity = [sectionValues objectAtIndex:row];
        
        cell.textLabel.text = tipocartaoEntity.descricao;
        
        UIImage *icon = [UIImage imageNamed:tipocartaoEntity.icon];
        cell.imageView.image = icon;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tipoCartaoTableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Obtem no momento que muda de view atraves de push (navigation bar)
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Novo"])
    {
        NSIndexPath *indexPath = [self.tipoCartaoTableView indexPathForSelectedRow];
        
        NovoViewController *controller = [segue destinationViewController];
        
        // Captura o nome da seção (índice)
        NSString *key = [numSections objectAtIndex:indexPath.section];
        // Captura a linha que está sendo criada (texto)
        NSMutableArray *sectionValues = [[NSMutableArray alloc] init];
    
        for (TipoCartao *str in tipoCartaoData)
        {
            if([str.empresa isEqualToString:key])
                [sectionValues addObject:str];
        }
        
        controller.tipoCartao = (TipoCartao *)[sectionValues objectAtIndex:indexPath.row];
    }
}

- (void)obterItens
{
    @try
    {
        tipoCartaoData = [TipoCartao obterItens];
    }
    @catch (NSException *exception)
    {
        [Utils exibirAlert:[exception name] Mensagem:[exception reason]];
    }
    @finally
    {
        [tipoCartaoTableView reloadData];
    }
}

- (IBAction)fecharModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
