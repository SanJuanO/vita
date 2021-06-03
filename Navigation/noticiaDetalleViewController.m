//
//  noticiaDetalleViewController.m
//  cut
//
//  Created by Guillermo on 26/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//


#import "noticiaDetalleViewController.h"

@interface noticiaDetalleViewController ()

@end

@implementation noticiaDetalleViewController
#import "color.h"
#import "globales.h"
@synthesize timelineDistancia=_timelineDistancia;

-(void)mostrarAvisoNoInternet
{
    self.timelineDistancia.constant=80;
    [self.timeline layoutIfNeeded];
    [self.timeline mostrarAviso:@"NoInternet"];
}


-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    [refreshControl endRefreshing];
    jsonOriginal=[NSDictionary dictionaryWithDictionary:json];
    
    NSMutableArray *indiceTemporal=[[NSMutableArray alloc] init];
    //[self.timeline.contenedor.infiniteScrollingView stopAnimating];
    
    if([senderValue isEqualToString:@"noticia"])
    {
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        indiceTemporal=[APIConnection getArrayJSON:response withKey:@"noticias"];
        //self.timeline.contenedor.showsInfiniteScrolling=false;
        
        NSMutableArray *indiceProcesando=[[NSMutableArray alloc] init];
        NSMutableArray *fotos=[[NSMutableArray alloc] init];
        fotos=[APIConnection getArrayJSON:response withKey:@"fotos"];
        
        // generamos los tipos
        if([indiceTemporal count]>0)
        {
            [indiceTipos removeAllObjects];
            URLCompartir=[NSString stringWithFormat:@"%@%@",GAPIShare,[APIConnection getStringJSON:[indiceTemporal objectAtIndex:0] withKey:@"urlAmigablenoti" widthDefValue:@""]];

            if([fotos count]==0)
            {
                NSString *imagen=[APIConnection getStringJSON:[indiceTemporal objectAtIndex:0] withKey:@"imagennoti" widthDefValue:@""];

                if(![imagen isEqualToString:@""])
                {
                    NSDictionary *diccionario=[NSDictionary dictionaryWithObjectsAndKeys:imagen,@"archivofoto",@"",@"titulofoto", nil];
                    [fotos addObject:diccionario];
                }
            }

            if([fotos count]>0)
            {
                // agregamos el nodo de galeria
                [indiceTipos addObject:@"galeria"];
                [indiceProcesando addObject:[NSDictionary dictionaryWithObjectsAndKeys:fotos,@"galeria", nil]];
            }
            
            // agregamos el nodo de titulo
            [indiceTipos addObject:@"titulo"];
            [indiceProcesando addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [APIConnection getStringJSON:[indiceTemporal objectAtIndex:0] withKey:@"titulonoti" widthDefValue:@""],@"titulo", nil]];
            
            subirTexto=@"";
            subirImagen1=@"";
            subirImagen2=@"";
            NSString *textoBase=[APIConnection getStringJSON:[indiceTemporal objectAtIndex:0] withKey:@"textonoti" widthDefValue:@""];
            if(![textoBase isEqualToString:@""])
            {
                [indiceTipos addObject:@"texto"];
                [indiceProcesando addObject:[NSDictionary dictionaryWithObjectsAndKeys:textoBase,@"texto", nil]];
            }
            
            textoBase=[APIConnection getStringJSON:[indiceTemporal objectAtIndex:0] withKey:@"urlnoti" widthDefValue:@""];
            if(![textoBase isEqualToString:@""])
            {
                [indiceTipos addObject:@"textoPeque"];
                [indiceProcesando addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Fuente: %@",textoBase],@"texto", nil]];
            }
            
            textoBase=[APIConnection getStringJSON:[indiceTemporal objectAtIndex:0] withKey:@"autornoti" widthDefValue:@""];
            if(![textoBase isEqualToString:@""])
            {
                [indiceTipos addObject:@"textoPeque"];
                [indiceProcesando addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Autor: %@",textoBase],@"texto", nil]];
            }
            
            textoBase=[APIConnection getStringJSON:[indiceTemporal objectAtIndex:0] withKey:@"fechanoti" widthDefValue:@""];
            if(![textoBase isEqualToString:@""])
            {
                [indiceTipos addObject:@"textoPeque"];
                [indiceProcesando addObject:[NSDictionary dictionaryWithObjectsAndKeys:textoBase,@"texto", nil]];
            }

            [self.barraSocial inicializa:@"noti" conIdreal:self.idreal
                               conTgusta:[APIConnection getStringJSON:[indiceTemporal objectAtIndex:0] withKey:@"tgusta" widthDefValue:@"0"]
                         conTcomentarios:[APIConnection getStringJSON:[indiceTemporal objectAtIndex:0] withKey:@"tcomentarios" widthDefValue:@"0"]
                              conMegusta:[APIConnection getStringJSON:response withKey:@"megusta" widthDefValue:@"0"]];
            
        }
        [self.timeline acomoda:indiceProcesando conTipos:indiceTipos conPagina:pagina conSeparador:false conVentana:@"noticiaDetalle" conAudios:1];
        if(pagina==1)
            [self animarRegreso];
    }
    else if([senderValue isEqualToString:@"comentarioAgregar"])
    {
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        indiceTemporal=[APIConnection getArrayJSON:response withKey:@"timeline"];
        
        if([indiceTemporal count]==1)
        {
            URLCompartirPost=[NSString stringWithFormat:@"%@%@",GAPIShare,[APIConnection getStringJSON:[indiceTemporal objectAtIndex:0] withKey:@"urlAmigabletim" widthDefValue:@""]];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Foto publicada correctamente" message:@"¿Deseas compartir en redes sociales?" delegate:self cancelButtonTitle:@"No por ahora" otherButtonTitles:@"Si ¡Hagámoslo!", nil];
            av.delegate=self;
            av.tag=992;
            [av show];
        }
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==992)
        if(buttonIndex==1)
            [self compartirDesdeTimeLine:URLCompartirPost];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.headerPrincipal inicializa:@"Noticias" conSubtitulo:@"Regresar" conBotonBack:true conBuscador:false conTipoBotonHome:@"home"];
    self.headerPrincipal.delegate=self;
    self.timeline.delegate=self;
    
    self.timelineDistancia.constant=700;
    [self.timeline layoutIfNeeded];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(recargaContenido)
             forControlEvents:UIControlEventValueChanged];
    [self.timeline.contenedor addSubview:refreshControl];
    /*
    [self.timeline.contenedor addInfiniteScrollingWithActionHandler:^{
        pagina++;
        [self cargaContenido];
    }];
    */
    pagina=1;
    self.ventanaActual=@"noticia";
    
    self.barraSocial.delegate=self;
    URLCompartir=[NSString stringWithFormat:@"%@noti/%@",GAPIShare,self.idreal];
    subirRegistro=self.idreal;
    subirTabla=@"noti";
    [self cargaContenido];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"noticiaDetalle"
                                                          action:@"abre"
                                                           label:self.idreal
                                                           value:nil] build]];
    // Do any additional setup after loading the view.
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
    
    if([self.ventanaActual isEqualToString:@"noticia"])
    {
        //self.timeline.contenedor.showsInfiniteScrolling=false;
        [APIConnection connectAPI:[NSString stringWithFormat:@"noticias.php?idnoticia=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:loader onErrorReturn:false withSender:@"noticia" willContinueLoading:false];
    }
}

-(void)animarRegreso
{
    self.timelineDistancia.constant=80;
    [UIView animateWithDuration:0.5 animations:^{
        [self.timeline layoutIfNeeded];
    } completion:^(BOOL finished) {
        if(pagina==1)
            [self.timeline.contenedor scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    }];
}

// delegate que actualiza la barra social
-(void)actualizaComentarios:(long)comentarios
{
    [self.barraSocial actualizaComentarios:comentarios];
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

