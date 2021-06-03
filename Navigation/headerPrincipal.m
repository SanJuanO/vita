//
//  headerPrincipal.m
//  kiwilimon
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 16/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "headerPrincipal.h"
#import "PureLayout.h"
#import "UIImageView+AFNetworking.h"
#import <sqlite3.h>
@implementation headerPrincipal
@synthesize delegate=_delegate;
@synthesize botonBack=_botonBack;
@synthesize titulo=_titulo;
@synthesize imagenKiwi=_imagenKiwi;
@synthesize subtitulo=_subtitulo;
@synthesize vistaAbajo=_vistaAbajo;
@synthesize botonHome=_botonHome;
@synthesize botonBuscador=_botonBuscador;
@synthesize vistaHome=_vistaHome;

@synthesize fondo1=_fondo1;
@synthesize fondo1Linea=_fondo1Linea;
@synthesize botonLateral=_botonLateral;
@synthesize logoPrincipal=_logoPrincipal;
@synthesize fondo2Home=_fondo2Home;
@synthesize fondo2Abajo=_fondo2Abajo;
@synthesize fondo2Linea1=_fondo2Linea1;
@synthesize fondo2LineaHome=_fondo2LineaHome;

#import "globales.h"
#import "color.h"
#import "databaseOperations.h"
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
    [[NSBundle mainBundle] loadNibNamed:@"headerPrincipal" owner:self options:nil];
    [self addSubview:self.view];
    [self.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self setBackgroundColor:[UIColor clearColor]];
    [self.vistaHome setHidden:true];
    self.titulo.text=@"";
    self.subtitulo.text=@"";
    [self.botonBack setTitle:@"" forState:UIControlStateNormal];
}

- (IBAction)abrirMenuLateral:(id)sender {
    [self.delegate menuLateralMuestra];
}
- (IBAction)home:(id)sender {
    if([modoBotonHome isEqualToString:@"home"])
        [self.delegate veAlHome];
    else if([modoBotonHome isEqualToString:@"refrescar"])
        [self.delegate refrescarContenido];
}

-(void)inicializa:(NSString *)titulo conSubtitulo:(NSString *)subtitulo conBotonBack:(BOOL)botonBack conBuscador:(BOOL)buscador conTipoBotonHome:(NSString *)tipoBotonHome
{
    if([titulo isEqualToString:@"Aportaciones de Miembros"])
       [self.botonLateral setHidden:true];
    [self pintaElementos];
    modoBotonHome=tipoBotonHome;
    [self.botonBuscador setHidden:!buscador];
    if([tipoBotonHome isEqualToString:@"home"])
    {
        [self.vistaHome setHidden:true];

        [self.botonHome setHidden:false];
    }
    else if([tipoBotonHome isEqualToString:@"refrescar"])
    {
        [self.vistaHome setHidden:false];
        [self.botonHome setHidden:false];
        [self.botonHome setImage:[UIImage imageNamed:@"botonRefrescar"] forState:UIControlStateNormal];
    }
    else
        [self.botonHome setHidden:true];

    if([titulo isEqualToString:@"home"])
    {
        [self.imagenKiwi setHidden:false];
        self.titulo.text=@"";
        [self.vistaAbajo setHidden:true];
        [self.botonHome setHidden:true];
    }
    else if(![titulo isEqualToString:@""])
    {
        [self.titulo setHidden:false];

        [self.imagenKiwi setHidden:true];
        self.titulo.text=titulo;
    }
    else
    {
        [self.titulo setHidden:true];
        [self.imagenKiwi setHidden:FALSE];
    }
    
    if(![subtitulo isEqualToString:@""] || botonBack)
    {
        if(botonBack)
        {
            if([subtitulo isEqualToString:@""])
                subtitulo=@"Regresar";
            [self.botonBack setHidden:false];
            [self.subtitulo setHidden:true];
            [self.botonBack setTitle:subtitulo forState:UIControlStateNormal];
        }
        else
        {
            [self.botonBack setHidden:true];
            [self.subtitulo setHidden:false];
            self.subtitulo.text=subtitulo;
        }
    }
    else
    {
        [self.botonBack setHidden:true];
        [self.subtitulo setHidden:true];
    }
}
- (IBAction)cambiaFuenteAccion:(id)sender {
    [self.delegate cambiaFuente];
}
- (IBAction)cambiaColorAccion:(id)sender {
    [self.delegate cambiaColorFuente];
}
- (IBAction)botonBackOperacion:(id)sender {
    [self.delegate popViewController];
}
- (IBAction)abrebuscador:(id)sender {
    if ([self.delegate respondsToSelector:@selector(abreBuscador)]) {
        [self.delegate abreBuscador];
    }
}

- (IBAction)scroll:(id)sender {
    [self.delegate scrollToTop];
}

-(void)pintaElementos
{
    [self.fondo2Home setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondoTitulo"] withAlpha:1.0]];
    [self.fondo2Abajo setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondoTitulo"] withAlpha:1.0]];
    [self.fondo1 setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.fondo1Linea setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLinea"] withAlpha:1.0]];
    [self.fondo2Linea1 setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLinea"] withAlpha:1.0]];

    /*
    [self.fondo1 setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.fondo1Linea setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.titulo setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo1"] withAlpha:1.0]];
    [self.botonLateral setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorBotonFondo1"] withAlpha:1.0]];
    [self.botonHome setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorBotonFondo2"] withAlpha:1.0]];
    
    [self.fondo2Home setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];
    [self.fondo2Abajo setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];
    [self.fondo2Linea1 setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLineas"] withAlpha:1.0]];
    [self.fondo2LineaHome setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLineas"] withAlpha:1.0]];
    [self.subtitulo setTextColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo2"] withAlpha:1.0]];
    [self.botonBack setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorBotonFondo2"] withAlpha:1.0]];
    [self.botonBack setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoFondo2"] withAlpha:1.0] forState:UIControlStateNormal];
    [self.botonBuscador setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorBotonFondo1"] withAlpha:1.0]];
     */
    
    [self.logoPrincipal setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:[configPrincipal objectForKey:@"logoPrincipal1"] conModo:@"N"]]];
}
- (IBAction)clicCalendario:(id)sender {
    [self.delegate clicEnCalendario];
}

@end
