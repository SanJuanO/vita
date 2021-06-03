//
//  timelineCeldaConc.m
//  centrovita
//
//  Created by Guillermo on 10/01/16.
//  Copyright © 2016 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaConc.h"

@implementation timelineCeldaConc
@synthesize concepto=_concepto;
@synthesize timporte=_timporte;
@synthesize tdescuento=_tdescuento;
@synthesize ttotal=_ttotal;
@synthesize importe=_importe;
@synthesize descuento=_descuento;
@synthesize total=_total;
@synthesize botonPagar=_botonPagar;
@synthesize delegate=_delegate;

#import "color.h"
#import "globales.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    [self.vistaPrincipal setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo1"] withAlpha:1.0]];
    //[self.vistaSecundaria setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];

    [self.concepto setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorSubtitulo"] withAlpha:1.0]];
    //[self.timporte setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
//    [self.tdescuento setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
  //  [self.ttotal setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];

    [self.importe setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.descuento setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.total setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];

    [self.botonPagar setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];

    self.concepto.font = [self.concepto.font fontWithSize:18*multiplicadorFuente];
    self.timporte.font = [self.timporte.font fontWithSize:14*multiplicadorFuente];
    self.tdescuento.font = [self.concepto.font fontWithSize:14*multiplicadorFuente];
    self.ttotal.font = [self.concepto.font fontWithSize:14*multiplicadorFuente];
    self.importe.font = [self.importe.font fontWithSize:18*multiplicadorFuente];
    self.descuento.font = [self.descuento.font fontWithSize:18*multiplicadorFuente];
    self.total.font = [self.total.font fontWithSize:18*multiplicadorFuente];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)pagarAhoraAccion:(id)sender {
    [self.delegate concPagar:self.tag];
}
@end
