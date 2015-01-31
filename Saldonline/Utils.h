//
//  Utils.h
//  Saldonline
//
//  Created by Paulo Cesar on 29/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Utils;

@interface Utils : NSObject 

+ (BOOL) connectedToInternet;
+ (void) exibirAlert:(NSString *)titulo Mensagem:(NSString *)mensagem;

@end
