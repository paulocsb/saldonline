//
//  TipoCartao.h
//  Saldonline
//
//  Created by Paulo Cesar on 25/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@class TipoCartao;

@interface TipoCartao : NSManagedObject

@property (nonatomic, retain) NSString * descricao;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * empresa;
@property (nonatomic, retain) NSString * codigo;

+ (NSArray *)obterItens;

@end
