//
//  Cartoes.m
//  Saldonline
//
//  Created by Paulo Cesar on 25/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "Cartoes.h"
#import "TipoCartao.h"


@implementation Cartoes

@dynamic descricao;
@dynamic numero;
@dynamic tipo;

+ (NSArray *)obterItens
{
    @try
    {
        AppDelegate *myAppDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        request.entity = [NSEntityDescription entityForName:@"Cartoes" inManagedObjectContext:myAppDelegate.managedObjectContext];
        request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"descricao" ascending:YES]];
        
        NSError *error = nil;
        
        return [myAppDelegate.managedObjectContext executeFetchRequest:request error:&error];
        
        if(error)
        {
            if(error)
            {
                @throw [[NSException alloc]
                        initWithName:@"Erro"
                        reason:@"Não foi possível obter os dados."
                        userInfo:nil];
            }
        }
    }
    @catch (NSException *exception)
    {
        @throw exception;
    }
}

@end
