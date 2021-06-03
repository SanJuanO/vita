//
//  timelineCeldaTitulo.m
//  cut
//
//  Created by Guillermo on 26/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaTitulo.h"

@implementation timelineCeldaTitulo

#import "globales.h"
#import "color.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondoTitulo"] withAlpha:1.0]];
    [self.botonmas setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorBotoncitoTitulo"] withAlpha:1.0]];
    self.titulo.font = [self.titulo.font fontWithSize:18*multiplicadorFuente];
    self.botonmas.font = [self.botonmas.font fontWithSize:15*multiplicadorFuente];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)pintaInvertido
{
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];
    [self.titulo setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo2"] withAlpha:1.0]];
    [self.botonmas setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo2"] withAlpha:1.0]];
}

@end
