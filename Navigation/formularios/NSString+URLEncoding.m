//
//  NSString+URLEncoding.m
//  micartelera
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 12/09/14.
//  Copyright (c) 2014 Imagen Central. All rights reserved.
//

#import "NSString+URLEncoding.h"
@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
    NSString *temp=self;
    temp=[temp stringByReplacingOccurrencesOfString:@"á" withString:@"a"];
    temp=[temp stringByReplacingOccurrencesOfString:@"é" withString:@"e"];
    temp=[temp stringByReplacingOccurrencesOfString:@"í" withString:@"i"];
    temp=[temp stringByReplacingOccurrencesOfString:@"ó" withString:@"o"];
    temp=[temp stringByReplacingOccurrencesOfString:@"ú" withString:@"u"];
    
    temp=[temp stringByReplacingOccurrencesOfString:@"Á" withString:@"A"];
    temp=[temp stringByReplacingOccurrencesOfString:@"É" withString:@"E"];
    temp=[temp stringByReplacingOccurrencesOfString:@"Í" withString:@"I"];
    temp=[temp stringByReplacingOccurrencesOfString:@"Ó" withString:@"O"];
    temp=[temp stringByReplacingOccurrencesOfString:@"Ú" withString:@"U"];
    
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)temp,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}
@end