//
//  timelineCeldaTextoSeleccion.m
//  centrovita
//
//  Created by Guillermo on 23/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaTextoSeleccion.h"

@implementation timelineCeldaTextoSeleccion
@synthesize delegate=_delegate;

#import "globales.h"
#import "color.h"

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    [self.vistaPrincipal setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo1"] withAlpha:1.0]];

    [self.texto setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];

    
    

    self.texto.font = [self.texto.font fontWithSize:16*multiplicadorFuente];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)pintaChecado:(NSString *)checado conOcultaSelector:(NSString *)ocultaSelector conEditando:(BOOL)editando
{
    if([ocultaSelector isEqualToString:@"si"])
       [self.checado setHidden:true];
    else
    {
        [self.checado setHidden:false];
        if([checado isEqualToString:@"0"])
        {
            if(!editando) [self.checado setHidden:true];
            [self.checado setTintColor:[self colorDesdeString:@"#cccccc" withAlpha:1.0]];
            [self.checado setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
        }
        else if([checado isEqualToString:@"1"])
        {
            [self.checado setTintColor:[self colorDesdeString:@"#45a842" withAlpha:1.0]];
            [self.checado setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
            
        }
        else if([checado isEqualToString:@"11"])
        {
            [self.checado setTintColor:[self colorDesdeString:@"#45a842" withAlpha:1.0]];
            [self.checado setImage:[UIImage imageNamed:@"check1"] forState:UIControlStateNormal];
        }
        else if([checado isEqualToString:@"12"])
        {
            [self.checado setTintColor:[self colorDesdeString:@"#efaf3f" withAlpha:1.0]];
            [self.checado setImage:[UIImage imageNamed:@"bmenos"] forState:UIControlStateNormal];
        }
        else if([checado isEqualToString:@"13"])
        {
            [self.checado setTintColor:[self colorDesdeString:@"#ff0000" withAlpha:1.0]];
            [self.checado setImage:[UIImage imageNamed:@"bcancel"] forState:UIControlStateNormal];
        }
    }
    

}
- (IBAction)checadoAccion:(id)sender {
    [self.delegate seleccionarTextoSeleccion:self.tag];
}

@end
