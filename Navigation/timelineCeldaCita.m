//
//  timelineCeldaCita.m
//  centrovita
//
//  Created by Guillermo on 08/06/17.
//  Copyright © 2017 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaCita.h"

@implementation timelineCeldaCita
#import "globales.h"
#import "color.h"
- (void)awakeFromNib {
    
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    
    
    [self.vistaPrincipal setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo1"] withAlpha:1.0]];
    [self.vistaSecundaria setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];

    [self.titulo setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
    [self.subtitulo setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
   
    [self.sede setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTitulo"] withAlpha:1.0]];
    
    self.titulo.font = [self.titulo.font fontWithSize:20*multiplicadorFuente];
    self.subtitulo.font = [self.subtitulo.font fontWithSize:14*multiplicadorFuente];
    self.sede.font = [self.sede.font fontWithSize:14*multiplicadorFuente];
    
    
    [self.stara0 setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorEstrellas"] withAlpha:1.0]];
    [self.stara1 setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorEstrellas"] withAlpha:1.0]];
    [self.stara2 setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorEstrellas"] withAlpha:1.0]];
    [self.stara3 setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorEstrellas"] withAlpha:1.0]];
    [self.stara4 setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorEstrellas"] withAlpha:1.0]];
    

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)pintaCalificacion:(NSString *)valorProceso
{
    long valor=[valorProceso integerValue];
    
    [self.stara0 setImage:[UIImage imageNamed:@"star0"]];
    [self.stara1 setImage:[UIImage imageNamed:@"star0"]];
    [self.stara2 setImage:[UIImage imageNamed:@"star0"]];
    [self.stara3 setImage:[UIImage imageNamed:@"star0"]];
    [self.stara4 setImage:[UIImage imageNamed:@"star0"]];
    
    if(valor>=1)
        [self.stara0 setImage:[UIImage imageNamed:@"star1"]];
    if(valor>=2)
        [self.stara1 setImage:[UIImage imageNamed:@"star1"]];
    if(valor>=3)
        [self.stara2 setImage:[UIImage imageNamed:@"star1"]];
    if(valor>=4)
        [self.stara3 setImage:[UIImage imageNamed:@"star1"]];
    if(valor>=5)
        [self.stara4 setImage:[UIImage imageNamed:@"star1"]];
}
- (IBAction)pinta1:(id)sender {
    if(self.calificar)
    {
        [self.delegate calificaCita:self.tag conCalificacion:@"1"];
        [self pintaCalificacion:@"1"];
    }
}
- (IBAction)pinta2:(id)sender {
    if(self.calificar)
    {
        [self.delegate calificaCita:self.tag conCalificacion:@"2"];
        [self pintaCalificacion:@"2"];
    }
}
- (IBAction)pinta3:(id)sender {
    if(self.calificar)
    {
        [self.delegate calificaCita:self.tag conCalificacion:@"3"];
        [self pintaCalificacion:@"3"];
    }
}
- (IBAction)pinta4:(id)sender {
    if(self.calificar)
    {
        [self.delegate calificaCita:self.tag conCalificacion:@"4"];
        [self pintaCalificacion:@"4"];

    }
}
- (IBAction)pinta5:(id)sender {
    if(self.calificar)
    {
        [self.delegate calificaCita:self.tag conCalificacion:@"5"];
        [self pintaCalificacion:@"5"];
    }
}
- (IBAction)abreSede:(id)sender {
    [self.delegate abreSede:self.idsede];
}

@end
