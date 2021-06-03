//
//  timelineCeldaTituloInterno.m
//  centrovita
//
//  Created by Guillermo on 26/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaTituloInterno.h"

@implementation timelineCeldaTituloInterno
@synthesize posicionTitulo=_posicionTitulo;
#import "globales.h"
#import "color.h"
- (void)awakeFromNib {
    
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    
    
    [self.vistaPrincipal setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo1"] withAlpha:1.0]];
    
    [self.titulo setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
    


    self.titulo.font = [self.titulo.font fontWithSize:18*multiplicadorFuente];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

