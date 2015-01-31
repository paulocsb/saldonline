//
//  MeusCartoesViewController.m
//  Saldonline
//
//  Created by Paulo Cesar on 29/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "MeusCartoesViewController.h"
#import "AppDelegate.h"
#import "Cartoes.h"
#import "ExtratoViewController.h"
#import "Utils.h"

@interface MeusCartoesViewController ()

@end

@implementation MeusCartoesViewController

@synthesize cartaoData;
@synthesize cartaoTableView;
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
    
//    self.cartaoTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    
    [self obterItens];
    [cartaoTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setCartaoData:nil];
    [self setCartaoTableView:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    if(animated)
    {
        [self obterItens];
        [cartaoTableView reloadData];
    }
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
    iAdBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, (contentFrame.size.height-(bannerSize.height+55)), GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
    iAdBannerView.delegate = self;
    iAdBannerView.hidden = YES;
    [self.view addSubview:iAdBannerView];
    
    gAdBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0, (contentFrame.size.height-(GAD_SIZE_320x50.height+55)), GAD_SIZE_320x50.width, GAD_SIZE_320x50.height)];
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

#pragma Events Controller

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1; // Valor fixo para apenas um seção
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    if([cartaoData count] == 0){
        return @"Nenhum cartão cadastrado";
    }
    else{
        if ([cartaoData count] == 1) {
            return [[NSString alloc] initWithFormat:@"Você possui %i cartão", [cartaoData count]];
        }
        else{
            return [[NSString alloc] initWithFormat:@"Você possui %i cartões", [cartaoData count]];
        }
    }
}

// retorna o tamanho da mutableArray
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([cartaoData count] == 0)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = NO;
        [cartaoTableView setEditing:NO animated:YES];
    }
    else
    {
        self.navigationItem.leftBarButtonItem.enabled = YES;
        
        if(!cartaoTableView.editing)
            self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    return [cartaoData count];
}

// implementação das células do tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idCell = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idCell];
    }
    
    if([cartaoData count] > 0)
    {
        Cartoes *cartoesEntity = [cartaoData objectAtIndex:[indexPath row]];
        
        //if([cartoesEntity.tipo.empresa isEqualToString:@"Visa"])
        //{
            cell.textLabel.text = cartoesEntity.descricao;
            cell.detailTextLabel.text = cartoesEntity.numero;
        
            UIImage *icon = [UIImage imageNamed:cartoesEntity.tipo.icon];
            cell.imageView.image = icon;
        //}
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cartaoTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self deleteItem:indexPath.row];
        [cartaoTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

// Obtem no momento que muda de view atraves de push (navigation bar)
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"extrato"])
    {
        NSIndexPath *indexPath = [self.cartaoTableView indexPathForSelectedRow];
        
        ExtratoViewController *controller = [segue destinationViewController];
        
        Cartoes *item = ((Cartoes *)[cartaoData objectAtIndex:indexPath.row]);
        
        controller.numeroCartao = item.numero;
        controller.codigoCartao = item.tipo.codigo;
        controller.empresaCartao = item.tipo.empresa;
        controller.labelText1 = @"Por favor aguarde...";
        controller.labelText2 = @"Finalizando...";
        controller.labelWidth = 140;
    }
}

-(IBAction)editTableForDeletingRow:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled = cartaoTableView.editing;
    
    [cartaoTableView setEditing:!cartaoTableView.editing animated:YES];
}

- (void)obterItens
{
    @try
    {
        cartaoData = [Cartoes obterItens];
    }
    @catch (NSException *exception)
    {
        [Utils exibirAlert:[exception name] Mensagem:[exception reason]];
    }
}

- (void)adicionarItem
{
    [self obterItens];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.cartaoTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
}

- (IBAction)deleteItem:(int)sender
{
    AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    Cartoes *cartaoEntity = [cartaoData objectAtIndex:sender];
    
    [myAppDelegate.managedObjectContext deleteObject:cartaoEntity];
    
    NSError *error = nil;
    if(![myAppDelegate.managedObjectContext save:&error])
    {
        NSLog(@"%@", error.description);
        cartaoData = nil;
    }
    
    [self obterItens];
}

@end
