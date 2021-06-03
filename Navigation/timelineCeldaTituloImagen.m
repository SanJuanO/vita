//
//  timelineCeldaTituloImagen.m
//  cut
//
//  Created by Guillermo on 17/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaTituloImagen.h"

@implementation timelineCeldaTituloImagen
@synthesize posicionTitulo=_posicionTitulo;
#import "globales.h"
#import "color.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    [self.vistaFecha setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.vistaPrincipal setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo1"] withAlpha:1.0]];
    [self.vistaSecundaria setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];
    [self.titulo setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
    [self.intro setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorSubtitulo"] withAlpha:1.0]];
    [self.linea setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLinea"] withAlpha:1.0]];
    self.costo.font = [self.costo.font fontWithSize:24*multiplicadorFuente];
    self.titulo.font = [self.titulo.font fontWithSize:18*multiplicadorFuente];
    self.intro.font = [self.intro.font fontWithSize:16*multiplicadorFuente];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
