//
//  TipoCartao.m
//  Saldonline
//
//  Created by Paulo Cesar on 25/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "TipoCartao.h"

@implementation TipoCartao

@dynamic descricao;
@dynamic icon;
@dynamic empresa;
@dynamic codigo;

+ (NSArray *)obterItens
{
    @try
    {
        AppDelegate *sender = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"TipoCartao" inManagedObjectContext:sender.managedObjectContext];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"descricao" ascending:YES]];
        
        NSError *error = nil;
        
        NSArray *itens = [sender.managedObjectContext executeFetchRequest:request error:&error];
        
        if(error)
        {
            @throw [[NSException alloc]
                    initWithName:@"Erro"
                    reason:@"Não foi possível obter os dados."
                    userInfo:nil];
        }
        
        return itens;
    }
    @catch (NSException *exception)
    {
        @throw exception;
    }
}

@end
