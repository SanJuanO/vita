//
//  timelineCeldaBoton.m
//  cut
//
//  Created by Guillermo on 05/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaBoton.h"

@implementation timelineCeldaBoton
@synthesize texto=_texto;
@synthesize fondo=_fondo;

#import "globales.h"
#import "color.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    [self.fondo setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.texto setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0]];

    self.texto.font = [self.texto.font fontWithSize:18*multiplicadorFuente];

    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
