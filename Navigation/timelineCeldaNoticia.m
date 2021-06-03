//
//  timelineCeldaNoticia.m
//  cut
//
//  Created by Guillermo on 24/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaNoticia.h"
#import <QuartzCore/QuartzCore.h>

@implementation timelineCeldaNoticia
@synthesize precio=_precio;

#import "color.h"
#import "globales.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    
    [self.linea setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLinea"] withAlpha:1.0]];
    [self.titulo setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
    [self.intro setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorSubtitulo"] withAlpha:1.0]];
    [self.vistaPrincipal setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo1"] withAlpha:1.0]];

    self.titulo.font = [self.titulo.font fontWithSize:15*multiplicadorFuente];
    self.intro.font = [self.intro.font fontWithSize:12*multiplicadorFuente];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
