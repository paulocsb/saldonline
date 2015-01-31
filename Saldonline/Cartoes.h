//
//  Cartoes.h
//  Saldonline
//
//  Created by Paulo Cesar on 25/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TipoCartao.h"

@class Cartoes;

@interface Cartoes : NSManagedObject

@property (nonatomic, retain) NSString * descricao;
@property (nonatomic, retain) NSString * numero;
@property (nonatomic, retain) TipoCartao *tipo;

+ (NSArray *)obterItens;

@end
