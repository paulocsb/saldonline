//
//  InicialViewController.m
//  Saldonline
//
//  Created by Paulo Cesar on 20/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "InicialViewController.h"
#import "AppDelegate.h"
#import "TipoCartao.h"
#import "ExtratoViewController.h"
#import "Utils.h"

@interface InicialViewController ()

- (void)tipoCartaoWasSelected:(NSNumber *)selectedIndex element:(id)element;

@end

@implementation InicialViewController

@synthesize txtConsulta;
@synthesize txtTipoCartao;
@synthesize selectedIndex;
@synthesize cartao;
@synthesize itensDatePicker;
@synthesize tipoCartao;
@synthesize iAdBannerView;
@synthesize gAdBannerView;
@synthesize swSalvarCartao;
@synthesize scrollView;
@synthesize mainView;

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
    
//    if([self ExibirAviso])
//    {
//        [Utils exibirAlert:@"Atenção" Mensagem:@"Por motivos de notificação através da empresa Edenred (Ticket), a consulta de saldo dos cartões TICKET foi removida do aplicativo.\nSaiba mais em:\nhttp://saldonline.tresbits.com/"];
//    }
    
//    self.scrollView.contentSize = CGSizeMake(320, 100);
    
    // Inicializa o iAd e AdMob
    [self bannerInicializar];
    
    // Verifica se será necessário realizar a carga de dados inicial
    if([self isCargaInicial])
        [self executeCargaInicial];
    
    [self setItensDatePicker:nil];
    [self setSelectedIndex:nil];
    
    swSalvarCartao.on = NO;
    
    // Seta o Background da View
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setItensDatePicker:nil];
    [self setSelectedIndex:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self setItensDatePicker:nil];
    [self setSelectedIndex:nil];
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
    [txtConsulta resignFirstResponder];
}

- (IBAction)consultar:(id)sender
{
    if(![txtConsulta.text isEqualToString:@""] && ![txtTipoCartao.text isEqualToString:@""])
    {
        if(swSalvarCartao.on)
        {
            AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
            
            Cartoes *cartoesEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Cartoes" inManagedObjectContext:myAppDelegate.managedObjectContext];
            
            // Captura a linha que está sendo criada (texto)
            NSMutableArray *sectionValues = [[NSMutableArray alloc] init];
            
            NSArray *tipoCartaoData = [TipoCartao obterItens];
            
            for (TipoCartao *str in tipoCartaoData)
            {
                NSString *tipo = [[NSString alloc] initWithFormat:@"%@ %@", str.empresa, str.descricao];
                if([tipo isEqualToString:txtTipoCartao.text])
                    [sectionValues addObject:str];
            }
            
            cartoesEntity.numero = txtConsulta.text;
            cartoesEntity.descricao = [[NSString alloc] initWithFormat:@"%@ %@", ((TipoCartao *)[sectionValues objectAtIndex:0]).empresa, ((TipoCartao *)[sectionValues objectAtIndex:0]).descricao];
            cartoesEntity.tipo = (TipoCartao *)[sectionValues objectAtIndex:0];
            
            NSError *error = nil;
            [myAppDelegate.managedObjectContext save:&error];
        }
            
        [self performSegueWithIdentifier:@"extrato" sender:sender];
    }
    else
    {
        [Utils exibirAlert:@"Atenção" Mensagem:@"Preencha corretamente as informações do cartão!"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

// Obtem no momento que muda de view atraves de push (navigation bar)
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"extrato"])
    {
        ExtratoViewController *controller = [segue destinationViewController];
        
        TipoCartao *itemTipoCartao = (TipoCartao *)[tipoCartao objectAtIndex:self.selectedIndex];
        
        controller.numeroCartao = txtConsulta.text;
        controller.codigoCartao = itemTipoCartao.codigo;
        controller.empresaCartao = itemTipoCartao.empresa;
        controller.labelText1 = @"Por favor aguarde...";
        controller.labelText2 = @"Finalizando...";
        controller.labelWidth = 140;
    }

    [self backgroundTouch];
}

- (IBAction)selectTipoCartao:(UIControl *)sender
{
    self.tipoCartao = [TipoCartao obterItens];
    
    NSMutableArray *item = [[NSMutableArray alloc] init];
    
    for (TipoCartao *str in self.tipoCartao)
    {
        [item addObject:[[NSString alloc] initWithFormat:@"%@ %@", str.empresa, str.descricao]];
    }
    
    self.itensDatePicker = item;
    
    [ActionSheetStringPicker showPickerWithTitle:@"Selecione um cartão" rows:self.itensDatePicker initialSelection:self.selectedIndex target:self successAction:@selector(tipoCartaoWasSelected:element:) cancelAction:@selector(actionPickerCancelled:) origin:sender];
}

- (IBAction)tipoCartaoButtonTapped:(UIBarButtonItem *)sender
{
    [self selectTipoCartao:sender];
}

- (void)tipoCartaoWasSelected:(NSNumber *)index element:(id)element
{
    self.selectedIndex = [index intValue];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    self.txtTipoCartao.text = [self.itensDatePicker objectAtIndex:self.selectedIndex];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

- (BOOL)isCargaInicial
{
    AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"TipoCartao" inManagedObjectContext:myAppDelegate.managedObjectContext];
    
    NSError *error = nil;
    
    NSArray *data = [myAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
    
    return ([data count] > 0) ? false : true;
}

- (BOOL)ExibirAviso
{
    NSDictionary *plist = [self LerPlist];
    
    int cont = ((NSArray*)[plist objectForKey:@"ContadorExibirAviso"]).count;
    
    if(cont < 3)
    {
        cont++;
        
        NSMutableArray *array = [NSMutableArray new];
        
        for (int i = 0; i<cont; i++) {
            [array addObject:[NSNumber numberWithInt:cont]];
        }
        
        [plist setValue:array forKey:@"ContadorExibirAviso"];
            
        NSString *localizedPath = [[NSBundle mainBundle] pathForResource:@"Configuracoes" ofType:@"plist"];
        [plist writeToFile:localizedPath atomically:YES];
        
        plist = [self LerPlist];
    }
    
    NSLog(@"%@ => %i", plist, ((NSArray*)[plist objectForKey:@"ContadorExibirAviso"]).count);
    
    return ((NSArray*)[plist objectForKey:@"ContadorExibirAviso"]).count > 3 ? NO : YES;
}

- (id)LerPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Configuracoes" ofType:@"plist"];
    NSData *plistData = [NSData dataWithContentsOfFile:filePath];
    
    // Error object that will be populated if there was a parsing error
    NSError *error = nil;
    // Property list format (see below)
    NSPropertyListFormat format = NSPropertyListXMLFormat_v1_0;
    
    return [NSPropertyListSerialization propertyListWithData:plistData
                                                         options:NSPropertyListXMLFormat_v1_0
                                                          format:&format error:&error];
}

- (void)executeCargaInicial
{
    AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    NSArray *visaRefeicao = [[NSArray alloc] initWithObjects:
                             @"Refeição", @"ctVisaValeRefeicao.png", @"R", @"Visa", nil];
    NSArray *visaAlimentacao = [[NSArray alloc] initWithObjects:
                                @"Alimentação", @"ctVisaValeAlimentacao.png", @"A", @"Visa", nil];
//    NSArray *ticketRestaurante = [[NSArray alloc] initWithObjects:
//                                  @"Restaurante", @"ctTicketRestaurante.png",@"R", @"Ticket", nil];
//    NSArray *ticketAlimentacao = [[NSArray alloc] initWithObjects:
//                                  @"Alimentação", @"ctTicketAlimentacao.png", @"A", @"Ticket", nil];
//    
//    NSArray *matriz = [[NSArray alloc] initWithObjects:visaRefeicao, visaAlimentacao, ticketRestaurante, ticketAlimentacao, nil];
    
    NSArray *matriz = [[NSArray alloc] initWithObjects:visaRefeicao, visaAlimentacao, nil];
    
    for(int i = 0; i < [matriz count]; i++)
    {
        TipoCartao *tipocartaoEntity = (TipoCartao *)[NSEntityDescription insertNewObjectForEntityForName:@"TipoCartao" inManagedObjectContext:myAppDelegate.managedObjectContext];
        
        tipocartaoEntity.descricao = [matriz objectAtIndex:i][0];
        tipocartaoEntity.icon = [matriz objectAtIndex:i][1];
        tipocartaoEntity.codigo = [matriz objectAtIndex:i][2];
        tipocartaoEntity.empresa = [matriz objectAtIndex:i][3];
        
        NSError *error = nil;
        if(![myAppDelegate.managedObjectContext save:&error])
        {
            NSLog(@"%@", error.description);
        }
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
    if ([sender isEqual:txtConsulta] || [sender isEqual:txtTipoCartao])
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
