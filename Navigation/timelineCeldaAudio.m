//
//  timelineCeldaAudio.m
//  centrovita
//
//  Created by Guillermo on 26/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "timelineCeldaAudio.h"
#import "AppDelegate.h"

@implementation timelineCeldaAudio
#import "color.h"
#import "globales.h"

- (void)awakeFromNib {
    [self.icono2 setImage:[UIImage imageNamed:@"botonReproducir"]];

    [[NSNotificationCenter defaultCenter] addObserver:self
       selector:@selector(receiveTestNotification:)
           name:@"cambioReproductor"
         object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(receiveTestNotification:)
        name:@"mostrarLoader"
      object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(receiveTestNotification:)
        name:@"ocultarLoader"
      object:nil];
    
    
     [self.loader setHidden:true];
    [self.contentView setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    // Initialization code
    [super awakeFromNib];
}

-(NSString *)convierteTiempo:(float)tiempo
{
    NSString *respuesta=@"";
    
    long segundos=round(tiempo);
    long minutos=floor(segundos/60);
    long segundosReales=segundos-minutos*60;
    respuesta=[NSString stringWithFormat:@"%02ld:%02ld",minutos,segundosReales];
    return respuesta;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)pintaBotones
{
    if([self.audioArchivo isEqualToString:audioArchivo] && audioReproduciendo)
    {
        if(audioReproduciendo)
        {
            [self.icono2 setImage:[UIImage imageNamed:@"botonDetener"]];
        }
        else  if(audioReproduciendo)
       {
           [self.icono2 setImage:[UIImage imageNamed:@"botonReproducir"]];
       }
    }
    else
    {
        [self ocultaLoader];
        [self.icono2 setImage:[UIImage imageNamed:@"botonReproducir"]];
    }
        
}
// leemos las notificaciones
- (void) receiveTestNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"cambioReproductor"])
    {
        if([self.audioArchivo isEqualToString:audioArchivo])
        {
            self.nombre.text=[NSString stringWithFormat:@"%@/%@ %@",[self convierteTiempo:audioProgreso],[self convierteTiempo:audioDuracion],self.titulo];
        }
        [self pintaBotones];
    }
    else if ([[notification name] isEqualToString:@"mostrarLoader"])
    {
        if([self.audioArchivo isEqualToString:audioArchivo])
       {
           [self.loader startAnimating];
           [self.loader setHidden:false];
           [self.icono2 setHidden:true];
       }
        else
        {
           [self ocultaLoader];
        }
    }
    else if ([[notification name] isEqualToString:@"ocultarLoader"])
    {
       
        [self ocultaLoader];
    }
    
}

-(void)ocultaLoader
{
    [self.loader stopAnimating];
    [self.loader setHidden:true];
    [self.icono2 setHidden:false];
}

- (IBAction)click:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    [appDelegate audioAccion:self.audioArchivo];
}


@end
