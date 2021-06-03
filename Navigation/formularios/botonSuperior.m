//
//  botonSuperior.m
//  baseFinal
//
//  Created by Guillermo on 06/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//


#import "botonSuperior.h"
#import <QuartzCore/QuartzCore.h>

@implementation botonSuperior
#import "color.h"
#import "globales.h"

-(void)awakeFromNib
{
    //self.layer.cornerRadius = 15;
    //self.clipsToBounds = YES;[self.terminos setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo1"] withAlpha:1.0] forState:UIControlStateNormal];
    [self setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0] forState:UIControlStateNormal];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
