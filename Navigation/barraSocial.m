//
//  barraSocial.m
//  cut
//
//  Created by Guillermo on 06/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//



#import "barraSocial.h"
#import "PureLayout.h"
#import "SVProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

@implementation barraSocial
@synthesize delegate=_delegate;
@synthesize botonNotificacion=_botonNotificacion;
@synthesize botonGusta=_botonGusta;
@synthesize botonComentario=_botonComentario;
@synthesize botonCompartir=_botonCompartir;
@synthesize izquierdaGusta=_izquierdaGusta;
@synthesize cuadroGusta=_cuadroGusta;
@synthesize textoGusta=_textoGusta;
@synthesize cuadroComentarios=_cuadroComentarios;
#import "globales.h"
#import "color.h"

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
        [self setup];
        
    }
    return self;
}

-(void)setup
{
    //currentInstall = [PFInstallation currentInstallation];
    NSLog(@"f");
    [[NSBundle mainBundle] loadNibNamed:@"barraSocial" owner:self options:nil];
    [self addSubview:self.view];
    [self.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    
    self.cuadroGusta.layer.cornerRadius=8;
    self.cuadroGusta.clipsToBounds=YES;
    
    self.cuadroComentarios.layer.cornerRadius=8;
    self.cuadroComentarios.clipsToBounds=YES;
    
    APIConnection=[[iwantooAPIConnection alloc] init];
    APIConnection.delegationListener=self;
    
    [self.view setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo3"] withAlpha:1.0]];
    [self.botonNotificacion setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo3"] withAlpha:1.0]];
    [self.botonGusta setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo3"] withAlpha:1.0]];
    [self.botonComentario setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo3"] withAlpha:1.0]];
    [self.botonCompartir setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo3"] withAlpha:1.0]];
    [self.botonfoto setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo3"] withAlpha:1.0]];
    [self.botonvideo setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo3"] withAlpha:1.0]];
    
    [self.cuadroGusta setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.cuadroComentarios setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.textoGusta setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0]];
    [self.textoComentarios setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0]];
    
    
    
}

-(void)inicializa:(NSString *)modo conIdreal:(NSString *)idreal conTgusta:(NSString *)tgusta conTcomentarios:(NSString *)tcomentarios conMegusta:(NSString *)meGusta
{
    modoInterno=modo;
    idrealInterno=idreal;
    if([modoInterno isEqualToString:@""] || [modoInterno isEqualToString:@"noti"])
    {
        self.izquierdaGusta.constant=0;
        [self.botonGusta layoutIfNeeded];
        [self.botonNotificacion setHidden:true];
    }
    else
    {
        self.izquierdaGusta.constant=15;
        [self.botonGusta layoutIfNeeded];
        [self.botonNotificacion setHidden:false];
    }
    
    // cosas para notificacion
    channelActual=[NSString stringWithFormat:@"%@%@",modoInterno,idrealInterno];
    NSLog(@"b");
    /*if([currentInstall channels] && [[currentInstall channels] indexOfObject:channelActual]!= NSNotFound)
        self.botonNotificacion.tag=1;
    else  self.botonNotificacion.tag=0;*/
    [self pintaNotificacion];
    self.textoComentarios.text=tcomentarios;
    
    totalGusta=[tgusta integerValue];
    if([meGusta isEqualToString:@"1"])
        self.botonGusta.tag=1;
    else self.botonGusta.tag=0;
    [self pintaMeGusta];
    
    if(tcomentarios<0) tcomentarios=0;
    totalComentarios=[tcomentarios integerValue];
    
}

// Herramienas para notificación
- (IBAction)botonNotificacionAccion:(id)sender {
    NSLog(@"a");
    if(self.botonNotificacion.tag==0)
        self.botonNotificacion.tag=1;
    else
        self.botonNotificacion.tag=0;
    long actual=self.botonNotificacion.tag;
    
    [self pintaNotificacion];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    /*if(actual==1)
    {
        if(![currentInstall channels])
            [currentInstall setChannels:@[channelActual]];
        else
            [currentInstall addUniqueObject:channelActual forKey:@"channels"];
        [currentInstall saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [SVProgressHUD showSuccessWithStatus:@"Recibirás notificaciones"];
        }];
        
    }
    else
    {
        if([currentInstall channels] && [[currentInstall channels] indexOfObject:channelActual]!= NSNotFound)
        {
            [currentInstall removeObject:channelActual forKey:@"channels"];
            [currentInstall saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [SVProgressHUD showSuccessWithStatus:@"No recibirás notificaciones"];
            }];
            
        }
    }*/
}

-(void)pintaNotificacion
{
    UIImage *imagen=[[UIImage alloc] init];
    if(self.botonNotificacion.tag==0)
        imagen=[UIImage imageNamed:@"notificacion0"];
    else
        imagen=[UIImage imageNamed:@"notificacion1"];
    //imagen = [imagen imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.botonNotificacion setImage:imagen forState:UIControlStateNormal];
}

-(void)pintaMeGusta
{
    UIImage *imagen=[[UIImage alloc] init];
    if(self.botonGusta.tag==0)
        imagen=[UIImage imageNamed:@"gusta0"];
    else
        imagen=[UIImage imageNamed:@"gusta1"];
    self.textoGusta.text=[NSString stringWithFormat:@"%ld",totalGusta];
    //imagen = [imagen imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [self.botonGusta setImage:imagen forState:UIControlStateNormal];
}

- (IBAction)gusta:(id)sender {
    if(![token isEqualToString:@""])
    {
        long operacion=0;
        if(self.botonGusta.tag==0)
        {
            self.botonGusta.tag=1;
            totalGusta++;
            operacion=1;
        }
        else
        {
            self.botonGusta.tag=0;
            totalGusta--;
            operacion=0;
        }
        
        [self pintaMeGusta];
        
        [APIConnection connectAPI:[NSString stringWithFormat:@"operaciones.php?operacion=megusta&valor=%ld&tabla=%@&registro=%@",operacion,modoInterno,idrealInterno] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"megusta" willContinueLoading:false];
    }
    else [self.delegate abreFirma];
    
}

- (IBAction)compartir:(id)sender {
    [self.delegate compartirBoton];
}

- (IBAction)abrirComentarios:(id)sender {
    [self.delegate abreVentanacomentarios:idrealInterno conTabla:modoInterno conModo:@"comentarios" conRow:-1];
}

-(void)actualizaComentarios:(long)comentarios
{
    totalComentarios+=comentarios;
    self.textoComentarios.text=[NSString stringWithFormat:@"%ld",totalComentarios];

}
- (IBAction)subirfoto:(id)sender {
    [self.delegate subirFoto];
}
- (IBAction)subirVideo:(id)sender {
    [self.delegate subirVideo];
}

-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    
}
@end
