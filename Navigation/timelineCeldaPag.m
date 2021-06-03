//
//  timelineCeldaPag.m
//  centrovita
//
//  Created by Guillermo on 11/01/16.
//  Copyright © 2016 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaPag.h"

@implementation timelineCeldaPag
#import "color.h"
#import "globales.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    [self.vistaPrincipal setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo1"] withAlpha:1.0]];
    [self.vistaSecundaria setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];
    
    [self.fechapag setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorSubtitulo"] withAlpha:1.0]];
    //[self.statusNombrepag setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
    //[self.modoNombrepag setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
    //[self.confirmacionpag setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
    
    [self.totalpag setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];

    self.fechapag.font = [self.fechapag.font fontWithSize:18*multiplicadorFuente];
    self.statusNombrepag.font = [self.statusNombrepag.font fontWithSize:14*multiplicadorFuente];
    self.modoNombrepag.font = [self.modoNombrepag.font fontWithSize:14*multiplicadorFuente];
    self.confirmacionpag.font = [self.confirmacionpag.font fontWithSize:14*multiplicadorFuente];
    self.totalpag.font = [self.totalpag.font fontWithSize:22*multiplicadorFuente];

    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
