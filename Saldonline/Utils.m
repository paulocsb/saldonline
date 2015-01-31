//
//  Utils.m
//  Saldonline
//
//  Created by Paulo Cesar on 29/01/13.
//  Copyright (c) 2013 Paulo Cesar. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (BOOL)connectedToInternet
{
    NSString *urlString = @"http://www.google.com/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    
    return ([response statusCode] == 200) ? YES : NO;
}

+ (void) exibirAlert:(NSString *)titulo Mensagem:(NSString *)mensagem
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titulo
                                                    message:mensagem
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

@end
