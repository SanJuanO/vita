//
//  noticiasViewController.m
//  cut
//
//  Created by Guillermo on 26/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "noticiasViewController.h"

@interface noticiasViewController ()

@end

@implementation noticiasViewController
#import "color.h"
#import "globales.h"
@synthesize vistaBuscador=_vistaBuscador;
@synthesize textoBuscador=_textoBuscador;

-(void)mostrarAvisoNoInternet
{
    self.timelineDistancia.constant=0;
    [self.timeline layoutIfNeeded];
    [self.timeline mostrarAviso:@"NoInternet"];
}


-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    [refreshControl endRefreshing];
    jsonOriginal=[NSDictionary dictionaryWithDictionary:json];
    
    NSMutableArray *indiceTemporal=[[NSMutableArray alloc] init];
    //[self.timeline.contenedor.infiniteScrollingView stopAnimating];
    
    if([senderValue isEqualToString:@"noticias"])
    {
        if(pagina==1)
        {
            [indice removeAllObjects];
            [indiceTipos removeAllObjects];
            
        }
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        indiceTemporal=[APIConnection getArrayJSON:response withKey:@"noticias"];
        /*if([indiceTemporal count]<porpagina)
            self.timeline.contenedor.showsInfiniteScrolling=false;
        else self.timeline.contenedor.showsInfiniteScrolling=true;
        */
        if([indiceTemporal count]>0) // generamos los tipos
        {
            [indiceTipos removeAllObjects];
            for(int i=0; i<=[indiceTemporal count]-1; i++)
                [indiceTipos addObject:@"noticias"];
        }
        
        [self.timeline acomoda:indiceTemporal conTipos:indiceTipos conPagina:pagina conSeparador:false conVentana:@"noticias" conAudios:1];
        if(pagina==1)
            [self animarRegreso];
    }
    else if([senderValue isEqualToString:@"buscar"])
    {
        [indice removeAllObjects];
        [indiceTipos removeAllObjects];
        
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        indiceTemporal=[APIConnection getArrayJSON:response withKey:@"noticias"];
        
        NSMutableArray *indiceTiposBuscador=[[NSMutableArray alloc] init];
        
        if([indiceTemporal count]>0)
        {
            // generamos los tipos
            for(int i=0; i<=[indiceTemporal count]-1; i++)
                [indiceTiposBuscador addObject:@"noticias"];
            [self.timelineBuscador acomoda:indiceTemporal conTipos:indiceTiposBuscador conPagina:1 conSeparador:false conVentana:@"noticias" conAudios:1];
        }
        else
            [self.timelineBuscador limpia];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.headerPrincipal inicializa:@"Noticias" conSubtitulo:@"Inicio" conBotonBack:true conBuscador:true conTipoBotonHome:@"home"];
    
    selectorAltura=self.contenedorSelector.frame.size.height;
    selector2Altura=40;
    selectorArreglo =@[@"Destacadas", @"Todas"];
    selector = [[selectorClase alloc] initWithSectionTitles:selectorArreglo];
    [selector inicializa:self.contenedorSelector conAltura:selectorAltura];
    [selector addTarget:self action:@selector(cambioSelector:) forControlEvents:UIControlEventValueChanged];
    
    self.headerPrincipal.delegate=self;
    self.timeline.delegate=self;
    self.timelineDistancia.constant=700;
    [self.timeline layoutIfNeeded];
    
    [self.vistaBuscador setHidden:true];
    self.vistaBuscador.alpha=0;
    self.textoBuscador.delegate=self;
    self.timelineBuscador.delegate=self;
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(recargaContenido)
             forControlEvents:UIControlEventValueChanged];
    [self.timeline.contenedor addSubview:refreshControl];
    
   /* [self.timeline.contenedor addInfiniteScrollingWithActionHandler:^{
        pagina++;
        [self cargaContenido];
    }];*/
    pagina=1;
    self.ventanaActual=@"destacadas";
    [self cargaContenido];
    // Do any additional setup after loading the view.
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"noticias"
                                                          action:@"abre"
                                                           label:@""
                                                           value:nil] build]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)recargaContenido
{
    [refreshControl endRefreshing];
    pagina=1;
    [self cargaContenido];
}

-(void)cargaContenido
{
    BOOL loader=false;
    if(pagina==1)
        loader=true;
    
    [APIConnection connectAPI:[NSString stringWithFormat:@"noticias.php?modo=%@&numero_pagina=%ld",self.ventanaActual,pagina] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:loader onErrorReturn:false withSender:@"noticias" willContinueLoading:false];
    
}

- (IBAction)cambioSelector:(HMSegmentedControl *)sender
{
    // estan en baseVentana estas variables
    animarRegreso=false;
    abreSelector2=false;
    selectorCargarContenido=false;
    
    if(sender == selector)
    {
        NSString *segmentoActual=[selectorArreglo objectAtIndex:selector.selectedSegmentIndex];
        if([segmentoActual isEqualToString:@"Destacadas"])
        {
            pagina=1;
            self.ventanaActual=@"destacadas";
            selectorCargarContenido=true; // vamos a cargar u ordenar contenido
        }
        else if([segmentoActual isEqualToString:@"Todas"])
        {
            pagina=1;
            self.ventanaActual=@"todas";
            selectorCargarContenido=true; // vamos a cargar u ordenar contenido
        }
    }
    
    
    // realimzamos las animaciones necesarioas
    [self.timeline layoutIfNeeded];
    self.timelineDistancia.constant=self.view.frame.size.height;
    [UIView animateWithDuration:0.5 animations:^{
        [self.timeline layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(selectorCargarContenido)
            [self cargaContenido];
        
        if(animarRegreso)
            [self animarRegreso];
    }];
}

-(void)animarRegreso
{
    
    self.timelineDistancia.constant=0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.timeline layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if(pagina==1)
            [self.timeline.contenedor scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        
    }];
}


// buscador operaciones
-(void)abreBuscador
{
    if(self.vistaBuscador.hidden)
    {
        self.textoBuscador.text=@"";
        [self.timelineBuscador limpia];
        self.vistaBuscador.alpha=0;
        [self.vistaBuscador setHidden:false];
        [UIView animateWithDuration:0.5 animations:^{
            self.vistaBuscador.alpha=1;
        }];
        [self.textoBuscador becomeFirstResponder];
    }
    else
        [self ocultaBuscador:nil];
}

- (IBAction)ocultaBuscador:(id)sender {
    [self.textoBuscador resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.vistaBuscador.alpha=0;
    } completion:^(BOOL finished) {
        [self.vistaBuscador setHidden:true];
        
    }];
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [APIConnection connectionCancel];
    pagina=1;
    textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([textField.text length]>=3)
    {
        [APIConnection connectAPI:[NSString stringWithFormat:@"noticias.php?modo=todas&numero_pagina=%ld&palabra=%@",pagina,self.textoBuscador.text] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:false onErrorReturn:false withSender:@"buscar" willContinueLoading:false];
    }
    return false;
}

-(void)scrollToTop
{
    [self.timeline.contenedor scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:true];
}

-(void)detieneAudio:(BOOL)cerrar
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    if(cambioFuenteAhora || self.multiplicadorFuenteActual!=multiplicadorFuente || ![self.colorFuenteLocal isEqualToString:colorFuenteGlobal])
    {
        [self.headerPrincipal.fondo2Home setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondoTitulo"] withAlpha:1.0]];
        [self.headerPrincipal.fondo2Abajo setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondoTitulo"] withAlpha:1.0]];
        [self.headerPrincipal.fondo1 setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
        [self.headerPrincipal.fondo1Linea setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLinea"] withAlpha:1.0]];
        [self.headerPrincipal.fondo2Linea1 setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLinea"] withAlpha:1.0]];
        
        [self.view setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
         self.colorFuenteLocal=colorFuenteGlobal;

        self.multiplicadorFuenteActual=multiplicadorFuente;
        cambioFuenteAhora=false;
        [self.timeline.contenedor reloadData];
    }
}
@end
