//
//  ExtratoViewController.h
//  Saldonline
//
//  Created by Paulo Cesar on 22/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cartoes.h"

#define BGQUEUE dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface ExtratoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray* jsonData;
    IBOutlet UITableView *extratoTableView;
    NSString *saldoCartao;
    BOOL isException;
    NSString *numeroCartao;
    NSString *codigoCartao;
    NSString *empresaCartao;
}

@property(nonatomic,strong) IBOutlet UITableView *extratoTableView;
@property(nonatomic,strong) NSMutableArray *jsonData;
@property(nonatomic,strong) NSString *saldoCartao;
@property(nonatomic,readwrite) BOOL isException;
@property(nonatomic,strong) NSString *numeroCartao;
@property(nonatomic,strong) NSString *codigoCartao;
@property(nonatomic,strong) NSString *empresaCartao;
// DejalActivity Loading
@property (nonatomic, strong) NSString *labelText1;
@property (nonatomic, strong) NSString *labelText2;
@property (nonatomic) NSUInteger labelWidth;
// DejalActivity Loading
- (IBAction)displayActivityView;
- (void)changeActivityView;
- (void)removeActivityView;

- (IBAction)recarregar:(id)sender;
@end
