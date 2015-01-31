//
//  ExtratoViewController.m
//  Saldonline
//
//  Created by Paulo Cesar on 22/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "ExtratoViewController.h"
#import "DejalActivityView.h"
#import "Cartoes.h"
#import "Utils.h"

@interface ExtratoViewController ()

@end

@implementation ExtratoViewController

@synthesize jsonData, extratoTableView, saldoCartao, isException, numeroCartao, codigoCartao, empresaCartao;
@synthesize labelText1, labelText2, labelWidth;

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
	// Do any additional setup after loading the view, typically from a nib.
    
    //self.extratoTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];

    [self performSelector:@selector(displayActivityView) withObject:nil afterDelay:0.2];
    [self setIsException:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setJsonData:nil];
    [self setLabelText1:nil];
    [self setLabelText2:nil];
    [self setIsException:nil];
    [self setLabelWidth:nil];
    [self setSaldoCartao:nil];
    [self setExtratoTableView:nil];
    [self setNumeroCartao:nil];
    [self setCodigoCartao:nil];
    [self setEmpresaCartao:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    if([Utils connectedToInternet] == NO)
    {
        // Not connected to the internet
        [Utils exibirAlert:@"Erro" Mensagem:@"Sem conexão com a internet!\nTente novamente."];
    }
    else
    {
        // Connected to the internet
        [self performSelector:@selector(requestJson) withObject:nil afterDelay:0.8];
    }
}

- (void)viewDidDisappear:(BOOL)animated;
{
	[super viewDidDisappear:animated];
    
    [self removeActivityView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recarregar:(id)sender
{
    [self viewDidLoad];
    [self viewDidAppear:YES];
}

- (IBAction)displayActivityView;
{
    UIView *viewToUse = self.view;
    
    if (self.labelText1)
    {
        // Display the appropriate activity style, with custom label text.  The width can be omitted or zero to use the text's width:
        [DejalBezelActivityView activityViewForView:viewToUse withLabel:self.labelText1 width:self.labelWidth];
        //[DejalActivityView activityViewForView:viewToUse withLabel:self.labelText1 width:self.labelWidth];
    }
    else
    {
        // Display the appropriate activity style, with the default "Loading..." text:
        [DejalBezelActivityView activityViewForView:viewToUse];
        //[DejalActivityView activityViewForView:viewToUse];
    }
    
    // If this is YES, the network activity indicator in the status bar is shown, and automatically hidden when the activity view is removed.  This property can be toggled on and off as needed:
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
}

- (void)changeActivityView;
{
    // Change the label text for the currently displayed activity view:
    [DejalActivityView currentActivityView].activityLabel.text = self.labelText2;
    
    // Disable the network activity indicator in the status bar, e.g. after downloading data and starting parsing it (don't have to disable it if simply removing the view):
    //[DejalActivityView currentActivityView].showNetworkActivityIndicator = NO;
    
    [self performSelector:@selector(removeActivityView) withObject:nil afterDelay:1.0];
}

- (void)removeActivityView;
{
    // Remove the activity view, with animation for the two styles that support it:    
    [DejalActivityView removeView];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1; // Valor fixo para apenas um seção
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    // Padding in view
    headerView.bounds = CGRectInset(headerView.frame, -5.0f, -18.0f);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    label.text = saldoCartao;
    label.textColor = [UIColor colorWithRed:19/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
//    label.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:label];
    
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    return saldoCartao;
}

// retorna o tamanho da mutableArray
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [jsonData count];
}

// implementação das células do tableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idCell = @"0";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idCell];
    }
    
    NSArray *item = [jsonData objectAtIndex:[indexPath row]];
    
    if([item count] == 0)
        return cell;
  
    // define os textos primários da célula
    NSString *strValor = [[item objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *strDetalhe = [[NSString alloc] initWithCString:[[item objectAtIndex:1] cStringUsingEncoding:NSISOLatin1StringEncoding] encoding:NSUTF8StringEncoding];
    
    NSString *strData = [item objectAtIndex:0];

    cell.textLabel.text = strDetalhe;
    cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ - R$ %@", strData, strValor];
    cell.detailTextLabel.textColor = [UIColor brownColor];
    
    return cell;
}

// request json data
- (void)requestJson
{
    dispatch_async(BGQUEUE, ^{
        NSData *data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:[self prepareURL]]];
        
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [self changeActivityView];
        } );
    });
}

// obtem e armazena os dados via json
- (void)fetchedData:(NSData *)responseData
{
    @try
    {
        if([[empresaCartao lowercaseString] isEqualToString:@"ticket"])
        {
            @throw [[NSException alloc]
                    initWithName:@"Erro"
                    reason:@"Por motivos de notificação através da empresa Edenred (Ticket), a consulta de saldo dos cartões TICKET foi removida do aplicativo.\nSaiba mais em:\nhttp://saldonline.tresbits.com/"
                    userInfo:nil];
        }
        
        //parse out the json data
        NSError* error;
        NSDictionary* response = [NSJSONSerialization
                                  JSONObjectWithData:responseData
                                  options:kNilOptions
                                  error:&error];
        
        jsonData = [[NSMutableArray alloc] init];
        
        int cont = [response count];
        for(int i = 0; i < cont; i++)
        {
            if([response objectForKey:[NSString stringWithFormat:@"%i",i]] != nil)
            {
                NSArray* itens = [response objectForKey:[NSString stringWithFormat:@"%i",i]];
                [jsonData addObject:itens];
            }
        }
        if([response objectForKey:@"saldo"] != nil)
        {
            saldoCartao = [NSString stringWithFormat:@"SALDO ATUAL: R$ %@", [response objectForKey:@"saldo"]];
        }
        else if([jsonData count] == 0 && !self.isException)
        {
            @throw [[NSException alloc]
                    initWithName:@"Erro"
                    reason:@"Não foi possível obter o extrato do seu cartão."
                    userInfo:nil];
        }
    }
    @catch (NSException *exception)
    {
        [self setIsException:YES];
        [Utils exibirAlert:[exception name] Mensagem:[exception reason]];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    @finally
    {
        [self.extratoTableView reloadData];
    }
}

- (NSString *)prepareURL
{
    NSString *tipo = [[NSString alloc] init];
    
    if([codigoCartao isEqualToString:@"R"]){
        tipo = @"Ticket_Restaurante";
    }
    else if([codigoCartao isEqualToString:@"A"]){
        tipo = @"Ticket_Alimentacao";
    }
    
    return [[NSString alloc] initWithFormat:
           @"http://webservice.tresbits.com/api/saldonline/%@/id/%@-%@/format/json",
           [empresaCartao lowercaseString], numeroCartao, [tipo lowercaseString]];
}

@end
