//
//  timeline.m
//  cut
//
//  Created by Guillermo on 24/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "timeline.h"
#import "PureLayout.h"
#import "GAI.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+calculaCosas.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"

#import <sqlite3.h>
@implementation timeline
@synthesize delegate=_delegate;
@synthesize noinfo=_noinfo;
@synthesize idence=_idence;
#import "databaseOperations.h"
#import "globales.h"
#import "color.h"

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
    [[NSBundle mainBundle] loadNibNamed:@"timeline" owner:self options:nil];
    [self addSubview:self.view];
    [self.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    [self setBackgroundColor:[self colorDesdeString:@"#f8f8f8" withAlpha:1.0]];
    [self.noinfo setHidden:true];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.delegate ocultaTeclado];

}

-(void)pintaEsperaMinutoXMinuto
{
    [indice removeAllObjects];
    [indiceTipos removeAllObjects];
    
    [self.noinfo setHidden:false];
    [self.contenedor setHidden:true];
    self.textoAviso.text=@"El partido está a punto de empezar. Espera unos minutos.";
    [self.contenedor reloadData];
}

-(void)acomoda:(NSMutableArray *)indicePasado conTipos:(NSMutableArray *)tipos conPagina:(long)pagina conSeparador:(BOOL)separador conVentana:(NSString *)ventana conAudios:(int)numAudios
{
    [self.botonAviso setHidden:true];
    ventanaActual=ventana;
    numeroAudios = numAudios;
    if(!separador)
        [self.contenedor setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    else [self.contenedor setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    if(pagina==1) // es la página 1, limpiamos el arreglo
    {
        [indice removeAllObjects];
        [indiceTipos removeAllObjects];
        if(([indicePasado count]==0 || [indicePasado count]!=[tipos count]) && ![ventanaActual isEqualToString:@"seleccionaSubir"] )
        {
            [self.noinfo setHidden:false];
            [self.contenedor setHidden:true];
            self.textoAviso.text=@"No encontramos información en este momento.";
            [self.contenedor reloadData];
        }
        else
        {
            [indice addObjectsFromArray:indicePasado];
            [indiceTipos addObjectsFromArray:tipos];
            cargado=false;
            if(!cargado)
            {
                cargado=true;[self.contenedor reloadData];
            }
            else
                [self.contenedor reloadRowsAtIndexPaths:self.contenedor.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];            [self.noinfo setHidden:true];
            [self.contenedor setHidden:false];
        }
    }
    else if([indicePasado count]>0 && [indicePasado count]==[tipos count])
    {
        [indice addObjectsFromArray:indicePasado];
        [indiceTipos addObjectsFromArray:tipos];
        [self.contenedor reloadData];
        [self.noinfo setHidden:true];
        [self.contenedor setHidden:false];
    }
    
}

-(void)inserta:(NSMutableArray *)indicePasado conTipos:(NSMutableArray *)tipos conPosicion:(long)posicion
{
    if([indicePasado count]>0 && [indicePasado count]==[tipos count])
    {
        NSRange range = NSMakeRange(posicion, [indicePasado count]);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [indice insertObjects:indicePasado atIndexes:indexSet];
        [indiceTipos insertObjects:tipos atIndexes:indexSet];
        
        
        
        NSMutableArray *indiceInsertar=[[NSMutableArray alloc] init];
        for(int i=0; i<=[indicePasado count]-1; i++)
            [indiceInsertar addObject:[NSIndexPath indexPathForRow:i+posicion inSection:0]];
        
        
        [self.contenedor beginUpdates];
        [self.contenedor insertRowsAtIndexPaths:indiceInsertar withRowAnimation:UITableViewRowAnimationLeft];
        [self.contenedor endUpdates];
        
        //[self.contenedor reloadData];
        [self.noinfo setHidden:true];
        [self.contenedor setHidden:false];
        
        
        if([indice count]>4)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                    inSection:0];
        
            [self.contenedor scrollToRowAtIndexPath:indexPath
                                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        
        

        
    }
}

-(void)quita:(long)cual
{
    long cuantos=1;
    NSDictionary *elemento = [indice objectAtIndex:cual];
    NSString *cuantosEliminar=[APIConnection getStringJSON:elemento withKey:@"cuantosEliminar" widthDefValue:@""];
    
    cuantos=[cuantosEliminar integerValue];

    NSMutableArray *indiceBorrar=[[NSMutableArray alloc] init];
    for(int i=0; i<=cuantos-1; i++)
    {
        [indice removeObjectAtIndex:cual];
        [indiceTipos removeObjectAtIndex:cual];
        [indiceBorrar addObject:[NSIndexPath indexPathForRow:cual+i inSection:0]];
    }
    [self.contenedor beginUpdates];
    [self.contenedor deleteRowsAtIndexPaths:indiceBorrar withRowAnimation:UITableViewRowAnimationFade];
    [self.contenedor endUpdates];

}
-(void)limpia
{
    [indice removeAllObjects];
    [indiceTipos removeAllObjects];
    [self.contenedor reloadData];
    
}

-(void)awakeFromNib
{
    cargado=false;
    indice = [[NSMutableArray alloc] init];
    indiceTipos = [[NSMutableArray alloc] init];
    self.contenedor.delegate=self;
    self.contenedor.dataSource=self;
    [self.view setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    
    [self.contenedor setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    

    APIConnection = [[iwantooAPIConnection alloc] init];
    APIConnection.delegationListener=self;
    
    APIConnection2 = [[iwantooAPIConnection alloc] init];
    APIConnection2.delegationListener=self;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [indice count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *elementoTipo = [indiceTipos objectAtIndex:indexPath.row];
    if(![elementoTipo isEqualToString:@"vacio"] && ![elementoTipo isEqualToString:@"generalSeparador"])
    {
        NSMutableDictionary *elemento = [NSMutableDictionary dictionaryWithDictionary:[indice objectAtIndex:indexPath.row]];
        
        if([elementoTipo isEqualToString:@"textoPeque"]) // es textoPeque
        {
            NSString *texto=[APIConnection getStringJSON:elemento withKey:@"texto" widthDefValue:@""];
            if ([texto rangeOfString:@"http://"].location != NSNotFound || [texto rangeOfString:@"https://"].location != NSNotFound)
            {
                [self.delegate abreURLDirecta:texto conModo:@"web" conOperacion:[APIConnection getStringJSON:elemento withKey:@"operacion" widthDefValue:@""] conIdreal:[APIConnection getStringJSON:elemento withKey:@"idreal" widthDefValue:@""]];
            }
        }
        else if([elementoTipo isEqualToString:@"pag"]) // es textoSeleccion
        {
            [self.delegate abreVentana:@"pag" conDiccionario:elemento conIDreal:[APIConnection getStringJSON:elemento withKey:@"idreal" widthDefValue:@"0"]];
        }
        else if([elementoTipo isEqualToString:@"conc"]) // es textoSeleccion
        {
            NSString *statusconc=[APIConnection getStringJSON:elemento withKey:@"statusconc" widthDefValue:@"0"];
            if([statusconc isEqualToString:@"1"]) // solo los pagados
                [self.delegate abreVentana:@"conc" conDiccionario:elemento conIDreal:[APIConnection getStringJSON:elemento withKey:@"ipagconc" widthDefValue:@"0"]];
        }
        else if([elementoTipo isEqualToString:@"textoSeleccion"]) // es textoSeleccion
        {
            BOOL abrir=[APIConnection getBOOLJSON:elemento withKey:@"abrir" widthDefValue:false];
            if(abrir)
            {
                [self.delegate abreVentana:@"cat" conDiccionario:elemento conIDreal:[APIConnection getStringJSON:elemento withKey:@"idcat<" widthDefValue:@""]];
            }
        }
        else if([elementoTipo isEqualToString:@"selecciona"])
        {
            if(![ventanaActual isEqualToString:@"buscarCartelera"] && ![ventanaActual isEqualToString:@""])
            {
                NSString *marcado=[APIConnection getStringJSON:elemento withKey:@"marcado" widthDefValue:@"0"];
                
                if([marcado isEqualToString:@"1"]) marcado=@"0";
                else marcado=@"1";
                
                [elemento setObject:marcado forKey:@"marcado"];
                [indice replaceObjectAtIndex:indexPath.row withObject:elemento];
                [self.contenedor beginUpdates];
                [self.contenedor reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                [self.contenedor endUpdates];
                [self.delegate actualizaSeleccion:elemento conMarcado:marcado];
            }
            else
            {
                NSString *tipo=[APIConnection getStringJSON:elemento withKey:@"tipo" widthDefValue:@""];
                NSString *idreal=[APIConnection getStringJSON:elemento withKey:@"idreal" widthDefValue:@""];
                if(![tipo isEqualToString:@""])
                {
                    [self.delegate abreVentana:tipo conDiccionario:elemento conIDreal:idreal];
                }
            }
            
        }
        else if([elementoTipo isEqualToString:@"titulo"])
        {
            NSDictionary *abrirSeccion=[APIConnection getDictionaryJSON:elemento withKey:@"abrirSeccion"];
            if(abrirSeccion)
            {
                NSString *ventana=[APIConnection getStringJSON:abrirSeccion withKey:@"ventana" widthDefValue:@""];
                NSString *operacion=[APIConnection getStringJSON:abrirSeccion withKey:@"operacion" widthDefValue:@""];
                if([ventana isEqualToString:@"actividades"])
                {
                    [self.delegate abreHerramienta:operacion conDiccionario:abrirSeccion];
                }
            }            
        }
        else
        {
            if(![elementoTipo isEqualToString:@"audio"])
            {
                NSString *operacion=[APIConnection getStringJSON:elemento withKey:@"operacion" widthDefValue:@""];
                    NSString *idreal=[APIConnection getStringJSON:elemento withKey:@"idreal" widthDefValue:@""];
                    if([operacion isEqualToString:@"pdfDetalle"]){
                        
                        NSString *url=[APIConnection getStringJSON:elemento withKey:@"url" widthDefValue:@""];
                        
                        if ([url rangeOfString:@"http://"].location == NSNotFound && [url rangeOfString:@"https://"].location == NSNotFound) {
                            url = [NSString stringWithFormat:@"%@%@",GAPIURLImages,url];
                        }
                        
                        [self.delegate abreURLDirecta:url conModo:@"web" conOperacion:operacion conIdreal:idreal];
                    }
                    else if([operacion isEqualToString:@"abrirURL"])
                    {
                        [self.delegate abreVentana:elementoTipo conDiccionario:elemento conIDreal:[APIConnection getStringJSON:elemento withKey:@"idreal" widthDefValue:@""]];

                    }
                    else if ([operacion rangeOfString:@"Detalle"].location != NSNotFound)
                    {
                        [elemento setObject:@"actividades" forKey:@"ventana"];
                        [self.delegate abreVentanaNavigation:operacion conDiccionario:elemento];
                    }
                    else
                        [self.delegate abreVentana:elementoTipo conDiccionario:elemento conIDreal:[APIConnection getStringJSON:elemento withKey:@"idreal" widthDefValue:@""]];
                
                
            }
        }

    }
}

-(void)abreFotoVideoDesdeGaleria:(NSDictionary *)elemento
{    
    [self.delegate abreVentana:@"generalFoto" conDiccionario:elemento conIDreal:[APIConnection getStringJSON:elemento withKey:@"idreal" widthDefValue:@""]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    NSDictionary *elemento = [indice objectAtIndex:indexPath.row];
    NSString *elementoTipo = [indiceTipos objectAtIndex:indexPath.row];
    if([indice count]>indexPath.row && [indiceTipos count]>indexPath.row)
    {
        elemento = [indice objectAtIndex:indexPath.row];
        elementoTipo = [indiceTipos objectAtIndex:indexPath.row];
    }
    else
        elementoTipo=@"vacio";
    
    if([elementoTipo isEqualToString:@"noticias"]) // es noticia
    {
        static NSString *cellMainNibID = @"timelineCeldaNoticia";
        
        self.timelineCeldaNoticia = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaNoticia == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaNoticia" owner:self options:nil];
        }
        self.timelineCeldaNoticia.titulo.text=[APIConnection getStringJSON:elemento withKey:@"titulo" widthDefValue:@""];
        self.timelineCeldaNoticia.intro.text=[APIConnection getStringJSON:elemento withKey:@"intro" widthDefValue:@""];
        [self.timelineCeldaNoticia.titulo setNumberOfLines:0];
        [self.timelineCeldaNoticia.intro setNumberOfLines:0];
        
        
        
        self.timelineCeldaNoticia.precio.text=[APIConnection getStringJSON:elemento withKey:@"costo" widthDefValue:@""];
        
        
        [self.timelineCeldaNoticia.imagen setImage:nil];
        NSString *imagen=[APIConnection getStringJSON:elemento withKey:@"imagen" widthDefValue:@""];
        if([imagen isEqualToString:@""])
            imagen=@"stock/noImagen.png";
        
        if ([imagen rangeOfString:@"http://"].location == NSNotFound && [imagen rangeOfString:@"https://"].location == NSNotFound) {
            [self.timelineCeldaNoticia.imagen setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:imagen conModo:@"N"]]];
        } else {
            [self.timelineCeldaNoticia.imagen setImageWithURL:[NSURL URLWithString:imagen]];
        }
        [self.timelineCeldaNoticia awakeFromNib];
       
        return self.timelineCeldaNoticia;
    }
    else if([elementoTipo isEqualToString:@"noticias2"]) // es noticia
    {
        static NSString *cellMainNibID = @"timelineCeldaNoticia2";
        
        self.timelineCeldaNoticia2 = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaNoticia2 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaNoticia" owner:self options:nil];
        }
        self.timelineCeldaNoticia2.titulo.text=[APIConnection getStringJSON:elemento withKey:@"titulo" widthDefValue:@""];
        
        self.timelineCeldaNoticia2.intro.attributedText = [self construyeHTML:[APIConnection getStringJSON:elemento withKey:@"intro" widthDefValue:@""]];
        
        [self.timelineCeldaNoticia2.titulo setNumberOfLines:0];
        [self.timelineCeldaNoticia2.intro setNumberOfLines:0];
        
        [self.timelineCeldaNoticia2.imagen setImage:nil];
        NSString *imagen=[APIConnection getStringJSON:elemento withKey:@"imagen" widthDefValue:@""];
        if([imagen isEqualToString:@""])
            imagen=@"stock/noImagen.png";
        
        if ([imagen rangeOfString:@"http://"].location == NSNotFound && [imagen rangeOfString:@"https://"].location == NSNotFound) {
            [self.timelineCeldaNoticia2.imagen setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:imagen conModo:@"M"]]];
        } else {
            [self.timelineCeldaNoticia2.imagen setImageWithURL:[NSURL URLWithString:imagen]];
        }
        
        [self.timelineCeldaNoticia2 awakeFromNib];
        
        return self.timelineCeldaNoticia2;
    }
    else if([elementoTipo isEqualToString:@"noticias3"]) // es noticia
    {
        static NSString *cellMainNibID = @"timelineCeldaNoticia3";
        
        self.timelineCeldaNoticia3 = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaNoticia3 == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaNoticia" owner:self options:nil];
        }
        self.timelineCeldaNoticia3.titulo.text=[APIConnection getStringJSON:elemento withKey:@"titulo" widthDefValue:@""];
        
        [self.timelineCeldaNoticia3.imagen setImage:nil];
        NSString *imagen=[APIConnection getStringJSON:elemento withKey:@"imagen" widthDefValue:@""];
        if([imagen isEqualToString:@""])
            imagen=@"stock/noImagen.png";
        
        if ([imagen rangeOfString:@"http://"].location == NSNotFound && [imagen rangeOfString:@"https://"].location == NSNotFound) {
            [self.timelineCeldaNoticia3.imagen setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:imagen conModo:@"M"]]];
        } else {
            [self.timelineCeldaNoticia3.imagen setImageWithURL:[NSURL URLWithString:imagen]];
        }
        
        [self.timelineCeldaNoticia3 awakeFromNib];
        
        return self.timelineCeldaNoticia3;
    }
    else if([elementoTipo isEqualToString:@"reflexion"]) // es noticia
    {
        static NSString *cellMainNibID = @"timelineCeldaReflexion";
        
        self.timelineCeldaReflexion = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaReflexion == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaNoticia" owner:self options:nil];
        }
        self.timelineCeldaReflexion.titulo.text=[APIConnection getStringJSON:elemento withKey:@"titulo" widthDefValue:@""];
        
        [self.timelineCeldaReflexion.imagen setImage:nil];
        NSString *imagen=[APIConnection getStringJSON:elemento withKey:@"imagen" widthDefValue:@""];
        if([imagen isEqualToString:@""])
            imagen=@"stock/noImagen.png";
        
        if ([imagen rangeOfString:@"http://"].location == NSNotFound && [imagen rangeOfString:@"https://"].location == NSNotFound) {
            [self.timelineCeldaReflexion.imagen setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:imagen conModo:@"N"]]];
        } else {
            [self.timelineCeldaReflexion.imagen setImageWithURL:[NSURL URLWithString:imagen]];
        }
        
        [self.timelineCeldaReflexion awakeFromNib];
        [self.timelineCeldaReflexion.titulo setTextColor:[self colorDesdeString:@"#FFFFFF" withAlpha:1.0]];
      
        return self.timelineCeldaReflexion;
    }
    
    else if([elementoTipo isEqualToString:@"titulo"]) // es titulo
    {
        static NSString *cellMainNibID = @"timelineCeldaTitulo";
        self.timelineCeldaTitulo = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaTitulo == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        
        self.timelineCeldaTitulo.titulo.text=[APIConnection getStringJSON:elemento withKey:@"titulo" widthDefValue:@""];
        [self.timelineCeldaTitulo.titulo setNumberOfLines:0];
        
        self.timelineCeldaTitulo.botonmas.text=[APIConnection getStringJSON:elemento withKey:@"botonVerMas" widthDefValue:@""];
        
        if([[APIConnection getStringJSON:elemento withKey:@"modoFondo" widthDefValue:@""] isEqualToString:@"invertido"])
            [self.timelineCeldaTitulo pintaInvertido];
        else [self.timelineCeldaTitulo awakeFromNib];
        
        return self.timelineCeldaTitulo;
    }
    else if([elementoTipo isEqualToString:@"tituloImagen"]) // es titulo
    {
        static NSString *cellMainNibID = @"timelineCeldaTituloImagen";
        
        self.timelineCeldaTituloImagen = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaTituloImagen == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        self.timelineCeldaTituloImagen.titulo.text=[APIConnection getStringJSON:elemento withKey:@"titulo" widthDefValue:@""];
        self.timelineCeldaTituloImagen.intro.attributedText = [self construyeHTML:[APIConnection getStringJSON:elemento withKey:@"intro" widthDefValue:@""]];
        NSString *imagen=[APIConnection getStringJSON:elemento withKey:@"imagen" widthDefValue:@""];
        if([imagen isEqualToString:@""])
            imagen=@"stock/noImagen.png";

        self.timelineCeldaTituloImagen.imagen.image=NULL;
        [self.timelineCeldaTituloImagen.imagen setHidden:false];
        if ([imagen rangeOfString:@"http://"].location == NSNotFound && [imagen rangeOfString:@"https://"].location == NSNotFound) {
            [self.timelineCeldaTituloImagen.imagen setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:imagen conModo:@"N"]]];
        } else {
            [self.timelineCeldaTituloImagen.imagen setImageWithURL:[NSURL URLWithString:imagen]];
        }
        
        NSString *dia=[APIConnection getStringJSON:elemento withKey:@"dia" widthDefValue:@""];
        if(![dia isEqualToString:@""])
        {
            self.timelineCeldaTituloImagen.dia.text=dia;
            self.timelineCeldaTituloImagen.mes.text=[APIConnection getStringJSON:elemento withKey:@"mes" widthDefValue:@""];
            [self.timelineCeldaTituloImagen.vistaFecha setHidden:false];
            self.timelineCeldaTituloImagen.posicionTitulo.constant=60;
            [self.timelineCeldaTituloImagen.contentView setNeedsLayout];
        }
        else
        {
            [self.timelineCeldaTituloImagen.vistaFecha setHidden:true];
            self.timelineCeldaTituloImagen.posicionTitulo.constant=10;
            [self.timelineCeldaTituloImagen.contentView setNeedsLayout];
        }
        self.timelineCeldaTituloImagen.costo.text=[APIConnection getStringJSON:elemento withKey:@"costo" widthDefValue:@""];
        if([[APIConnection getStringJSON:elemento withKey:@"costo" widthDefValue:@""] isEqualToString:@""])
            self.timelineCeldaTituloImagen.costoFonto.hidden = true;
        else
            self.timelineCeldaTituloImagen.costoFonto.hidden = false;
        
        [self.timelineCeldaTituloImagen.titulo setNumberOfLines:0];
        [self.timelineCeldaTituloImagen.intro setNumberOfLines:0];
        [self.timelineCeldaTituloImagen awakeFromNib];
        
        NSString *fechaReal=[APIConnection getStringJSON:elemento withKey:@"fechaReal" widthDefValue:@""];
        NSString *colorCuadrito=@"";
        if(![fechaReal isEqualToString:@""]) // viene fecha real
        {
            NSDateFormatter *dateFormatter=[NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Mexico_City"]];
            NSDate *dateOfEvent=[dateFormatter dateFromString:fechaReal];
            NSString *dateOfToday=[dateFormatter stringFromDate:[NSDate date]];
            NSDate *dateOfToday2=[dateFormatter dateFromString:dateOfToday];

            if([dateOfEvent compare:dateOfToday2]== NSOrderedSame)
                colorCuadrito=@"";
            else if([dateOfEvent compare:dateOfToday2]==NSOrderedAscending)
                colorCuadrito=@"gris";
            else
                colorCuadrito=@"";
        }

        if([colorCuadrito isEqualToString:@"gris"])
            [self.timelineCeldaTituloImagen.vistaFecha setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacadoOpaco"] withAlpha:1.0]];
        else
             [self.timelineCeldaTituloImagen.vistaFecha setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];

        return self.timelineCeldaTituloImagen;
    }
    else if([elementoTipo isEqualToString:@"tituloInterno"]) // es titulo
    {
        static NSString *cellMainNibID = @"timelineCeldaTituloInterno";
        
        self.timelineCeldaTituloInterno = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaTituloInterno == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        self.timelineCeldaTituloInterno.titulo.text=[APIConnection getStringJSON:elemento withKey:@"titulo" widthDefValue:@""];
        
        NSString *dia=[APIConnection getStringJSON:elemento withKey:@"dia" widthDefValue:@""];
        if(![dia isEqualToString:@""])
        {
            self.timelineCeldaTituloInterno.dia.text=dia;
            self.timelineCeldaTituloInterno.mes.text=[APIConnection getStringJSON:elemento withKey:@"mes" widthDefValue:@""];
            [self.timelineCeldaTituloInterno.vistaFecha setHidden:false];
            self.timelineCeldaTituloInterno.posicionTitulo.constant=60;
            [self.timelineCeldaTituloInterno.contentView setNeedsLayout];
        }
        else
        {
            [self.timelineCeldaTituloInterno.vistaFecha setHidden:true];
            self.timelineCeldaTituloInterno.posicionTitulo.constant=10;
            [self.timelineCeldaTituloInterno.contentView setNeedsLayout];
        }
        
        [self.timelineCeldaTituloInterno.titulo setNumberOfLines:0];
        
        NSString *fechaReal=[APIConnection getStringJSON:elemento withKey:@"fechaReal" widthDefValue:@""];
        NSString *colorCuadrito=@"";
        if(![fechaReal isEqualToString:@""]) // viene fecha real
        {
            NSDateFormatter *dateFormatter=[NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Mexico_City"]];
            NSDate *dateOfEvent=[dateFormatter dateFromString:fechaReal];
            NSString *dateOfToday=[dateFormatter stringFromDate:[NSDate date]];
            NSDate *dateOfToday2=[dateFormatter dateFromString:dateOfToday];
            
            if([dateOfEvent compare:dateOfToday2]== NSOrderedSame)
                colorCuadrito=@"";
            else if([dateOfEvent compare:dateOfToday2]==NSOrderedAscending)
                colorCuadrito=@"gris";
            else
                colorCuadrito=@"";

        }
       
        if([colorCuadrito isEqualToString:@"gris"])
            [self.timelineCeldaTituloInterno.vistaFecha setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacadoOpaco"] withAlpha:1.0]];
        else
            [self.timelineCeldaTituloInterno.vistaFecha setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
        

        [self.timelineCeldaTituloInterno awakeFromNib];
        return self.timelineCeldaTituloInterno;
    }
    else if([elementoTipo isEqualToString:@"texto"]) // es texto
    {
        static NSString *cellMainNibID = @"timelineCeldaTexto";
        
        self.timelineCeldaTexto = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaTexto == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        NSString *texto=[APIConnection getStringJSON:elemento withKey:@"texto" widthDefValue:@""];
        
        /*NSString *color=[APIConnection getStringJSON:elemento withKey:@"color" widthDefValue:@""];
        if(![color isEqualToString:@""])
        {
            [self.timelineCeldaTexto.contentView setBackgroundColor:[self colorDesdeString:color withAlpha:1.0]];
            [self.timelineCeldaTexto.fondo setBackgroundColor:[self colorDesdeString:color withAlpha:1.0]];
        }*/
        //self.timelineCeldaTexto.texto.userInteractionEnabled = YES;
        
        self.timelineCeldaTexto.texto.attributedText = [self construyeHTML:texto];
        [self.timelineCeldaTexto awakeFromNib];
        return self.timelineCeldaTexto;
    }
    else if([elementoTipo isEqualToString:@"textoSeleccion"]) // es texto
    {
        static NSString *cellMainNibID = @"timelineCeldaTextoSeleccion";
        
        self.timelineCeldaTextoSeleccion = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaTextoSeleccion == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        NSString *texto=[APIConnection getStringJSON:elemento withKey:@"texto" widthDefValue:@""];
        
        NSString *color=[APIConnection getStringJSON:elemento withKey:@"color" widthDefValue:@""];
        if(![color isEqualToString:@""])
        {
            [self.timelineCeldaTextoSeleccion.contentView setBackgroundColor:[self colorDesdeString:color withAlpha:1.0]];
            [self.timelineCeldaTextoSeleccion.fondo setBackgroundColor:[self colorDesdeString:color withAlpha:1.0]];
        }
        
        self.timelineCeldaTextoSeleccion.texto.attributedText = [self construyeHTML:texto];
        [self.timelineCeldaTextoSeleccion awakeFromNib];
        self.timelineCeldaTextoSeleccion.delegate=self;
        self.timelineCeldaTextoSeleccion.tag=indexPath.row;
            
        [self.timelineCeldaTextoSeleccion pintaChecado:[APIConnection getStringJSON:elemento withKey:@"seleccionado" widthDefValue:@"0"] conOcultaSelector:[APIConnection getStringJSON:elemento withKey:@"ocultarSelector" widthDefValue:@"no"] conEditando:self.editando];
        return self.timelineCeldaTextoSeleccion;
    }
    else if([elementoTipo isEqualToString:@"galeria"]) // es texto
    {
        if([[APIConnection getStringJSON:elemento withKey:@"modo" widthDefValue:@""] isEqualToString:@"mini"])
        {
            static NSString *cellMainNibID = @"timelineCeldaGaleria2";
            
            self.timelineCeldaGaleria2 = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
            if (self.timelineCeldaGaleria2 == nil)
            {
                [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaGaleria" owner:self options:nil];
                self.timelineCeldaGaleria2.galeria.modo=[APIConnection getStringJSON:elemento withKey:@"modo" widthDefValue:@""];
                [self.timelineCeldaGaleria2.galeria pintaGaleria:[APIConnection getArrayJSON:elemento withKey:@"galeria"] enTabla:false conPaginaActual:0 conCampoImagen:@"archivofoto" conCampoTexto:@"titulofoto"   conCostoTexto:[APIConnection getStringJSON:elemento withKey:@"costotexto" widthDefValue:@""]];
                self.timelineCeldaGaleria2.galeria.delegate=self;
                [self.timelineCeldaGaleria2 awakeFromNib];
            }
            
            return self.timelineCeldaGaleria2;
        }
        else
        {
            static NSString *cellMainNibID = @"timelineCeldaGaleria";
            self.timelineCeldaGaleria = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
            if (self.timelineCeldaGaleria == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaGaleria" owner:self options:nil];
                self.timelineCeldaGaleria.galeria.modo=[APIConnection getStringJSON:elemento withKey:@"modo" widthDefValue:@""];
                [self.timelineCeldaGaleria.galeria pintaGaleria:[APIConnection getArrayJSON:elemento withKey:@"galeria"] enTabla:false conPaginaActual:0 conCampoImagen:@"archivofoto" conCampoTexto:@"titulofoto"   conCostoTexto:[APIConnection getStringJSON:elemento withKey:@"costotexto" widthDefValue:@""]];
                self.timelineCeldaGaleria.galeria.delegate=self;
                [self.timelineCeldaGaleria awakeFromNib];
            }
            
            return self.timelineCeldaGaleria;
        }
        
    }
    else if([elementoTipo isEqualToString:@"textoPeque"]) // es textoPeque
    {
        static NSString *cellMainNibID = @"timelineCeldaTextoPeque";
        
        self.timelineCeldaTextoPeque = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaTextoPeque == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        self.timelineCeldaTextoPeque.texto.text=[APIConnection getStringJSON:elemento withKey:@"texto" widthDefValue:@""];
        [self.timelineCeldaTextoPeque.texto setNumberOfLines:0];

        [self.timelineCeldaTextoPeque awakeFromNib];
        return self.timelineCeldaTextoPeque;
    }
    else if([elementoTipo isEqualToString:@"boton"]) // es texto
    {
        static NSString *cellMainNibID = @"timelineCeldaBoton";
        
        self.timelineCeldaBoton = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaBoton == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        [self.timelineCeldaBoton awakeFromNib];
        
        NSString *colorBoton=[APIConnection getStringJSON:elemento withKey:@"colorBoton" widthDefValue:[configPrincipal objectForKey:@"colorDestacado"]];
        [self.timelineCeldaBoton.fondo setBackgroundColor:[self colorDesdeString:colorBoton withAlpha:1.0]];

        self.timelineCeldaBoton.texto.text = [APIConnection getStringJSON:elemento withKey:@"titulo" widthDefValue:@""];
        return self.timelineCeldaBoton;
    }
    
    else if([elementoTipo isEqualToString:@"vacio"]) // es vacio
    {
        static NSString *cellMainNibID = @"timelineCeldaTextoPeque";
        
        self.timelineCeldaTextoPeque = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaTextoPeque == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        self.timelineCeldaTextoPeque.texto.text=@"";
        [self.timelineCeldaTextoPeque awakeFromNib];
        return self.timelineCeldaTextoPeque;
    }
    
    else if([elementoTipo isEqualToString:@"generalSeparador"]) // es noticia
    {
        static NSString *cellMainNibID = @"timelineGeneral";
        
        self.timelineGeneralSeparador = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineGeneralSeparador == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineGeneral" owner:self options:nil];
        }
        [self.timelineGeneralSeparador pintaFondo:[APIConnection getStringJSON:elemento withKey:@"colorFondo" widthDefValue:@""]];
        
        if([[APIConnection getStringJSON:elemento withKey:@"linea" widthDefValue:@"no"] isEqualToString:@"si"])
            [self.timelineGeneralSeparador.linea setHidden:false];
        else [self.timelineGeneralSeparador.linea setHidden:true];
        return self.timelineGeneralSeparador;
    }
    else if([elementoTipo isEqualToString:@"generalFoto"]) // es noticia
    {
        static NSString *cellMainNibID = @"timelineGeneralFoto";
        
        self.timelineGeneralFoto = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineGeneralFoto == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineGeneralFoto" owner:self options:nil];
        }
        self.timelineGeneralFoto.imagen.alpha=0;
        [self.timelineGeneralFoto.imagen setImage:nil];
        NSString *imagen=[APIConnection getStringJSON:elemento withKey:@"imagen" widthDefValue:@""];
        if([imagen isEqualToString:@""])
            imagen=@"stock/noImagen.png";
        
        if ([imagen rangeOfString:@"http://"].location == NSNotFound && [imagen rangeOfString:@"https://"].location == NSNotFound) {
            [self.timelineGeneralFoto.imagen setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:imagen conModo:@"N"]]];
        } else {
            [self.timelineGeneralFoto.imagen setImageWithURL:[NSURL URLWithString:imagen]];
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.timelineGeneralFoto.imagen.alpha=1;
        }];
        if([[APIConnection getStringJSON:elemento withKey:@"tipotimeline" widthDefValue:@""] isEqualToString:@"video"])
        {

            [self.timelineGeneralFoto.botonplay setHidden:false];
        }
        else
            [self.timelineGeneralFoto.botonplay setHidden:true];
        [self.timelineGeneralFoto awakeFromNib];
        return self.timelineGeneralFoto;
    }
    
    else if([elementoTipo isEqualToString:@"selecciona"])
    {
        static NSString *cellMainNibID = @"timelineCeldaSelecciona";
        
        self.timelineCeldaSelecciona = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaSelecciona == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaSelecciona" owner:self options:nil];
        }
       
        self.timelineCeldaSelecciona.titulo.text=[APIConnection getStringJSON:elemento withKey:@"titulo" widthDefValue:@""];
        [self.timelineCeldaSelecciona.imagen1 setImage:nil];
        if(![[APIConnection getStringJSON:elemento withKey:@"visual" widthDefValue:@""] isEqualToString:@"perfil"])
        {
            self.timelineCeldaSelecciona.subtitulo.text=[APIConnection getStringJSON:elemento withKey:@"subtitulo" widthDefValue:@""];
            [self.timelineCeldaSelecciona.imagen1 setImage:nil];
            [self.timelineCeldaSelecciona.imagen2 setImage:nil];
           
            NSString *imagen2=[APIConnection getStringJSON:elemento withKey:@"imagen2" widthDefValue:@""];
            if([imagen2 isEqualToString:@""])
                imagen2=@"stock/noImagen.png";
            
            if ([imagen2 rangeOfString:@"http://"].location == NSNotFound && [imagen2 rangeOfString:@"https://"].location == NSNotFound) {
                [self.timelineCeldaSelecciona.imagen2 setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:imagen2 conModo:@"M"]]];
            } else {
                [self.timelineCeldaSelecciona.imagen2 setImageWithURL:[NSURL URLWithString:imagen2]];
            }
            
            [self.timelineCeldaSelecciona.imagen1 setHidden:false];
            [self.timelineCeldaSelecciona.imagen2 setHidden:false];
        }
        else
        {
            self.timelineCeldaSelecciona.subtitulo.text=@"";
            [self.timelineCeldaSelecciona.titulo setFont:[self.timelineCeldaSelecciona.titulo.font fontWithSize:20]];
            
            if([ventanaActual isEqualToString:@"equipos"])
            {
                self.timelineCeldaSelecciona.alturatitulo.constant=30;
                self.timelineCeldaSelecciona.izquierdatitulo.constant=-30;
                [self.timelineCeldaSelecciona.imagen1 setHidden:false];
                NSString *imagen=[APIConnection getStringJSON:elemento withKey:@"imagen" widthDefValue:@""];
                if([imagen isEqualToString:@""])
                    imagen=@"stock/noImagen.png";
                [self.timelineCeldaSelecciona.imagen1 setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:imagen conModo:@"M"]]];
                [self.timelineCeldaSelecciona.titulo setNeedsLayout];
            }
            else
            {
                self.timelineCeldaSelecciona.alturatitulo.constant=30;
                self.timelineCeldaSelecciona.izquierdatitulo.constant=-60;
                [self.timelineCeldaSelecciona.imagen1 setHidden:true];
                [self.timelineCeldaSelecciona.imagen2 setHidden:true];
                [self.timelineCeldaSelecciona.imagen1 setImage:nil];
                [self.timelineCeldaSelecciona.imagen2 setImage:nil];
                [self.timelineCeldaSelecciona.titulo setNeedsLayout];
                
            }

            

        }
        
        NSString *marcado=[APIConnection getStringJSON:elemento withKey:@"marcado" widthDefValue:@"0"];
        if([marcado isEqualToString:@"1"])
            self.timelineCeldaSelecciona.accessoryType = UITableViewCellAccessoryCheckmark;
        else
            self.timelineCeldaSelecciona.accessoryType = UITableViewCellAccessoryNone;
        
        if([[APIConnection getStringJSON:elemento withKey:@"tipo" widthDefValue:@"jug"] isEqualToString:@"equ"])
            [self.timelineCeldaSelecciona.imagen1 setHidden:true];
        else [self.timelineCeldaSelecciona.imagen1 setHidden:false];
        
        return self.timelineCeldaSelecciona;
    }
    else if([elementoTipo isEqualToString:@"renglon"]) // es titulo
    {
        static NSString *cellMainNibID = @"timelineCeldaRenglon";
        
        self.timelineCeldaRenglon = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaRenglon == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        
        self.timelineCeldaRenglon.texto.text=[APIConnection getStringJSON:elemento withKey:@"texto" widthDefValue:@""];
        
        return self.timelineCeldaRenglon;
    }
    else if([elementoTipo isEqualToString:@"botones"]) // es titulo
    {
        static NSString *cellMainNibID = @"timelineCeldaBotones";
        
        self.timelineCeldaBotones = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaBotones == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaBotones" owner:self options:nil];
        }
        self.timelineCeldaBotones.diccionario=[NSDictionary dictionaryWithDictionary:[APIConnection getDictionaryJSON:elemento withKey:@"botones"]];
        [self.timelineCeldaBotones pintaBotones];
        self.timelineCeldaBotones.delegate=self;
        return self.timelineCeldaBotones;
    }
    else if([elementoTipo isEqualToString:@"mapa"]) // es titulo
    {
        static NSString *cellMainNibID = @"timelineCeldaMapa";
        
        self.timelineCeldaMapa = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaMapa == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaMapa" owner:self options:nil];
        }
        self.timelineCeldaMapa.diccionario=[NSDictionary dictionaryWithDictionary:elemento];
        self.timelineCeldaMapa.delegate=self;
        self.timelineCeldaMapa.tag=indexPath.row;
        [self.timelineCeldaMapa pintaMapa];
        
        return self.timelineCeldaMapa;
    }
    else if([elementoTipo isEqualToString:@"audio"]) // es titulo
    {
        static NSString *cellMainNibID = @"timelineCeldaAudio";
        
        self.timelineCeldaAudio = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaAudio == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaAudio" owner:self options:nil];
        }
        if(numeroAudios==1)
        {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            self.timelineCeldaAudio.audioArchivo=[APIConnection getStringJSON:elemento withKey:@"audio" widthDefValue:@""];
            self.timelineCeldaAudio.titulo = @"";

            [appDelegate cargaAudio:[APIConnection getStringJSON:elemento withKey:@"audio" widthDefValue:@""]];
            [self.timelineCeldaAudio pintaBotones];
            
        }
        else{
            NSString *titulo=[APIConnection getStringJSON:elemento withKey:@"nombreactm" widthDefValue:@""];
            self.timelineCeldaAudio.titulo = titulo;
            self.timelineCeldaAudio.nombre.text=titulo;
            self.timelineCeldaAudio.nombre.hidden = false;
            self.timelineCeldaAudio.icono1.hidden = false;
            self.timelineCeldaAudio.icono2.hidden = false;
            
            self.timelineCeldaAudio.audioArchivo=[APIConnection getStringJSON:elemento withKey:@"audio" widthDefValue:@""];
            [self.timelineCeldaAudio pintaBotones];
            
        }
        
        [self.timelineCeldaAudio awakeFromNib];
        return self.timelineCeldaAudio;
    }
   
    else if([elementoTipo isEqualToString:@"aviso"]) // es titulo
    {
        static NSString *cellMainNibID = @"timelineCeldaAviso";
        
        self.timelineCeldaAviso = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaAviso == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaAviso" owner:self options:nil];
        }
        
        self.timelineCeldaAviso.aviso.text=[APIConnection getStringJSON:elemento withKey:@"aviso" widthDefValue:@""];
        
        return self.timelineCeldaAviso;
    }
    else if([elementoTipo isEqualToString:@"calificacion"]) // es titulo
    {
        static NSString *cellMainNibID = @"timelineCeldaCalificacion";
        
        self.timelineCeldaCalificacion = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaCalificacion == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaCalificacion" owner:self options:nil];
        }
        self.timelineCeldaCalificacion.tag=indexPath.row;
        self.timelineCeldaCalificacion.delegate=self;
        [self.timelineCeldaCalificacion pintaCalificacion:[APIConnection getStringJSON:elemento withKey:@"calificacion" widthDefValue:@"0"]];
        
        return self.timelineCeldaCalificacion;
    }
    else if([elementoTipo isEqualToString:@"conc"]) // es concepto
    {
        static NSString *cellMainNibID = @"timelineCeldaConc";
        
        self.timelineCeldaConc = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaConc == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaConc" owner:self options:nil];
        }
        self.timelineCeldaConc.tag=indexPath.row;
        self.timelineCeldaConc.concepto.text=[APIConnection getStringJSON:elemento withKey:@"concepto" widthDefValue:@""];

        NSString *descuento=[APIConnection getStringJSON:elemento withKey:@"descuentoconc" widthDefValue:@""];
        if(![descuento isEqualToString:@""] && ![descuento isEqualToString:@"0"])
        {
            [self.timelineCeldaConc.descuento setHidden:false];
            [self.timelineCeldaConc.tdescuento setHidden:false];
            [self.timelineCeldaConc.importe setHidden:false];
            [self.timelineCeldaConc.timporte setHidden:false];
            self.timelineCeldaConc.descuento.text=[NSString stringWithFormat:@"%@%%",descuento];
            self.timelineCeldaConc.importe.text=[self generaMoneda:[APIConnection getStringJSON:elemento withKey:@"importeconc" widthDefValue:@"0"]];

        }
        else
        {
            [self.timelineCeldaConc.descuento setHidden:true];
            [self.timelineCeldaConc.tdescuento setHidden:true];
            [self.timelineCeldaConc.importe setHidden:true];
            [self.timelineCeldaConc.timporte setHidden:true];
        }
        self.timelineCeldaConc.total.text=[self generaMoneda:[APIConnection getStringJSON:elemento withKey:@"totalconc" widthDefValue:@"0"]];

    
        NSString *statusconc=[APIConnection getStringJSON:elemento withKey:@"statusconc" widthDefValue:@"0"];
        if(![statusconc isEqualToString:@"0"] || 1==1)
        {
            [self.timelineCeldaConc.botonPagar setTitle:[APIConnection getStringJSON:elemento withKey:@"statusconcNombre" widthDefValue:@""] forState:UIControlStateNormal];
            [self.timelineCeldaConc.botonPagar setBackgroundColor:[self colorDesdeString:@"#cccccc" withAlpha:1.0]];
            [self.timelineCeldaConc.botonPagar setTitleColor:[self colorDesdeString:@"#ffffff" withAlpha:1.0] forState:UIControlStateNormal];

        }
        else
        {
            [self.timelineCeldaConc.botonPagar setTitle:[NSString stringWithFormat:@"%@. Pagar ahora",[APIConnection getStringJSON:elemento withKey:@"statusconcNombre" widthDefValue:@""]] forState:UIControlStateNormal];
            [self.timelineCeldaConc.botonPagar setTitleColor:[self colorDesdeString:@"#ffffff" withAlpha:1.0] forState:UIControlStateNormal];
            
            NSString *statusconcInterno=[APIConnection getStringJSON:elemento withKey:@"statusconcInterno" widthDefValue:@"0"];

            if([statusconcInterno isEqualToString:@"0"])
                [self.timelineCeldaConc.botonPagar setBackgroundColor:[self colorDesdeString:@"#808080" withAlpha:1.0]];
            else
                [self.timelineCeldaConc.botonPagar setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];

        }
        self.timelineCeldaConc.delegate=self;
        return self.timelineCeldaConc;
    }
    else if([elementoTipo isEqualToString:@"pag"]) // es pago
    {
        static NSString *cellMainNibID = @"timelineCeldaPag";
        
        self.timelineCeldaPag = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaPag == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaConc" owner:self options:nil];
        }
        self.timelineCeldaPag.tag=indexPath.row;
        self.timelineCeldaPag.fechapag.text=[APIConnection getStringJSON:elemento withKey:@"fechapag" widthDefValue:@""];
        
        self.timelineCeldaPag.totalpag.text=[self generaMoneda:[APIConnection getStringJSON:elemento withKey:@"totalpag" widthDefValue:@"0"]];
        self.timelineCeldaPag.statusNombrepag.text=[APIConnection getStringJSON:elemento withKey:@"statusNombrepag" widthDefValue:@""];
        self.timelineCeldaPag.modoNombrepag.text=[NSString stringWithFormat:@"Forma de pago: %@",[APIConnection getStringJSON:elemento withKey:@"modoNombrepag" widthDefValue:@""]];
        if(![[APIConnection getStringJSON:elemento withKey:@"confirmacionpag" widthDefValue:@""] isEqualToString:@""])
            self.timelineCeldaPag.confirmacionpag.text=[NSString stringWithFormat:@"Confirmación: %@",[APIConnection getStringJSON:elemento withKey:@"confirmacionpag" widthDefValue:@""]];
        else self.timelineCeldaPag.confirmacionpag.text=@"";
        
        return self.timelineCeldaPag;
    }
    else if([elementoTipo isEqualToString:@"textoPantallaCompleta"]) // es textoPeque
    {
        static NSString *cellMainNibID = @"timelineCeldatextoPantallaCompleta";
        
        self.timelineCeldatextoPantallaCompleta = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldatextoPantallaCompleta == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        self.timelineCeldatextoPantallaCompleta.texto.text=[APIConnection getStringJSON:elemento withKey:@"texto" widthDefValue:@""];
        [self.timelineCeldatextoPantallaCompleta.texto setNumberOfLines:0];
        
        [self.timelineCeldatextoPantallaCompleta awakeFromNib];
        return self.timelineCeldatextoPantallaCompleta;
    }
    else if([elementoTipo isEqualToString:@"cita"]) // es titulo
    {
        static NSString *cellMainNibID = @"timelineCeldaCita";
        
        self.timelineCeldaCita = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaCita == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        self.timelineCeldaCita.titulo.text=[APIConnection getStringJSON:elemento withKey:@"titulo" widthDefValue:@""];
        self.timelineCeldaCita.subtitulo.text=[APIConnection getStringJSON:elemento withKey:@"subtitulo" widthDefValue:@""];
        self.timelineCeldaCita.sede.text=[NSString stringWithFormat:@"%@ +",[APIConnection getStringJSON:elemento withKey:@"sede" widthDefValue:@""]];
        
        NSString *dia=[APIConnection getStringJSON:elemento withKey:@"dia" widthDefValue:@""];
        self.timelineCeldaCita.dia.text=dia;
        self.timelineCeldaCita.mes.text=[APIConnection getStringJSON:elemento withKey:@"mes" widthDefValue:@""];
        [self.timelineCeldaCita.vistaFecha setHidden:false];
        
        
        NSString *fechaReal=[APIConnection getStringJSON:elemento withKey:@"fechaReal" widthDefValue:@""];
        NSString *colorCuadrito=@"";
        if(![fechaReal isEqualToString:@""]) // viene fecha real
        {
            NSDateFormatter *dateFormatter=[NSDateFormatter new];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"America/Mexico_City"]];
            NSDate *dateOfEvent=[dateFormatter dateFromString:fechaReal];
            NSString *dateOfToday=[dateFormatter stringFromDate:[NSDate date]];
            NSDate *dateOfToday2=[dateFormatter dateFromString:dateOfToday];
            
            if([dateOfEvent compare:dateOfToday2]== NSOrderedSame)
                colorCuadrito=@"";
            else if([dateOfEvent compare:dateOfToday2]==NSOrderedAscending)
                colorCuadrito=@"gris";
            else
                colorCuadrito=@"";
            
        }
        
        if([colorCuadrito isEqualToString:@"gris"])
        {
            [self.timelineCeldaCita.vistaFecha setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacadoOpaco"] withAlpha:1.0]];
            [self.timelineCeldaCita.asistencia setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacadoOpaco"] withAlpha:1.0]];
        }
        else
        {
            [self.timelineCeldaCita.asistencia setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
            [self.timelineCeldaCita.vistaFecha setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
        }
        
        NSString *asistencia=[APIConnection getStringJSON:elemento withKey:@"asistencia" widthDefValue:@""];

        if([asistencia isEqualToString:@"0"])
        {
            [self.timelineCeldaCita.asistencia setHidden:true];
            [self.timelineCeldaCita.calificacion setHidden:true];
        }
        else
        {
            [self.timelineCeldaCita.calificacion setHidden:false];
            [self.timelineCeldaCita.asistencia setHidden:false];
            if([asistencia isEqualToString:@"1"])
                [self.timelineCeldaCita.asistencia setImage:[UIImage imageNamed:@"check1"]];
            else [self.timelineCeldaCita.asistencia setImage:[UIImage imageNamed:@"bcancel"]];

        }
        self.timelineCeldaCita.idsede=[APIConnection getStringJSON:elemento withKey:@"idsede" widthDefValue:@"0"];
        self.timelineCeldaCita.tag=indexPath.row;
        self.timelineCeldaCita.delegate=self;
        NSString *calificacionActual=[APIConnection getStringJSON:elemento withKey:@"calificacion" widthDefValue:@"0"];
        if([calificacionActual isEqualToString:@"0"])
            self.timelineCeldaCita.calificar=true;
        else self.timelineCeldaCita.calificar=false;
        
        [self.timelineCeldaCita pintaCalificacion:calificacionActual];
        
        
        [self.timelineCeldaCita awakeFromNib];
        return self.timelineCeldaCita;
    }
    else if([elementoTipo isEqualToString:@"subtitulo"]) // es titulo
    {
        static NSString *cellMainNibID = @"timelineCeldaSubtitulo";
        
        self.timelineCeldaSubtitulo = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaSubtitulo == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        self.timelineCeldaSubtitulo.subtitulo.text=[APIConnection getStringJSON:elemento withKey:@"subtitulo" widthDefValue:@""];
            [self.timelineCeldaSubtitulo awakeFromNib];
        return self.timelineCeldaSubtitulo;
    }
    else return nil;
}





-(void)concPagar:(long)cual
{
    NSMutableDictionary *elemento=[NSMutableDictionary dictionaryWithDictionary:[indice objectAtIndex:cual]];
    
    NSString *statusconc=[APIConnection getStringJSON:elemento withKey:@"statusconc" widthDefValue:@""];
    if([statusconc isEqualToString:@"0"])
    {
        NSString *statusconcInterno=[APIConnection getStringJSON:elemento withKey:@"statusconcInterno" widthDefValue:@"0"];
        if([statusconcInterno isEqualToString:@"0"])
        {
            [elemento setObject:@"1" forKey:@"statusconcInterno"];
        }
        else
        {
            [elemento setObject:@"0" forKey:@"statusconcInterno"];
        }
        
        // generamos arreglo y total de pagos
        NSMutableArray *indicePasar=[[NSMutableArray alloc] init];
        float total=0;
        [indice replaceObjectAtIndex:cual withObject:elemento];
        for(int i=0; i<=[indice count]-1; i++)
        {
            elemento=[indice objectAtIndex:i];
            statusconcInterno=[APIConnection getStringJSON:elemento withKey:@"statusconcInterno" widthDefValue:@"0"];
            if([statusconcInterno isEqualToString:@"1"]) // pagaremos este
            {
                total+=[APIConnection getFloatJSON:elemento withKey:@"totalconc" widthDefValue:@"0"];
                [indicePasar addObject:elemento];
            }
            
        }
        [self.delegate actualizaTotalPagar:indicePasar conTotal:total];
        [self.contenedor reloadData];
    }
}

-(void)califica:(long)cual conCalificacion:(NSString *)calificacion
{
    NSMutableDictionary *diccionario=[NSMutableDictionary dictionaryWithDictionary:[indice objectAtIndex:cual]];
    [diccionario setObject:calificacion forKey:@"calificacion"];
    [indice replaceObjectAtIndex:cual withObject:diccionario];
    [APIConnection2 connectAPI:[NSString stringWithFormat:@"catPuntaje.php?idreal=%@&valor=%@",[APIConnection getStringJSON:diccionario withKey:@"idreal" widthDefValue:@""],calificacion] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"catPuntaje" willContinueLoading:false];
}

-(void)calificaCita:(long)cual conCalificacion:(NSString *)calificacion
{
    NSMutableDictionary *diccionario=[NSMutableDictionary dictionaryWithDictionary:[indice objectAtIndex:cual]];
    [diccionario setObject:calificacion forKey:@"calificacion"];
    [indice replaceObjectAtIndex:cual withObject:diccionario];
    [self.delegate calificaCita:[APIConnection getStringJSON:diccionario withKey:@"idreal" widthDefValue:@"0"] conCalificacion:calificacion];
   
}

-(void)abreSede:(NSString *)idsede
{
    [self.delegate abreVentana:@"sede" conDiccionario:NULL conIDreal:idsede];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *elementoTipo=@"",*elementoTipo2=@"";
    if([indiceTipos count]>0)
        elementoTipo = [indiceTipos objectAtIndex:0];
    if([indiceTipos count]>1)
        elementoTipo2 = [indiceTipos objectAtIndex:1];
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
    
    
}

- (void)abreEquivalencias:(UITapGestureRecognizer *)recognizer {
    [self.delegate abreURLDirecta:[NSString stringWithFormat:@"%@equivalencias.php",GAPIURL] conModo:@"web" conOperacion:@"equivalencias" conIdreal:@""];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *elementoActual;
    NSString *elementoTipo;
    if([indice count]>indexPath.row && [indiceTipos count]>indexPath.row)
    {
        elementoActual = [indice objectAtIndex:indexPath.row];
        elementoTipo = [indiceTipos objectAtIndex:indexPath.row];
    }
    else
        elementoTipo=@"vacio";
    
    //NSLog(@"elementoTipo %@",elementoTipo);
    if([elementoTipo isEqualToString:@"noticias"])
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            static NSString *cellMainNibID = @"timelineCeldaNoticia";
            self.timelineCeldaNoticia = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
            if (self.timelineCeldaNoticia == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaNoticia" owner:self options:nil];
            }
            
            self.timelineCeldaNoticia.titulo.text=[APIConnection getStringJSON:elementoActual withKey:@"titulonoti" widthDefValue:@""];
            self.timelineCeldaNoticia.intro.text=[APIConnection getStringJSON:elementoActual withKey:@"intronoti" widthDefValue:@""];
            [self.timelineCeldaNoticia.titulo setPreferredMaxLayoutWidth:self.timelineCeldaNoticia.titulo.frame.size.width];
            [self.timelineCeldaNoticia.intro setPreferredMaxLayoutWidth:self.timelineCeldaNoticia.titulo.frame.size.width];
            
            [self.timelineCeldaNoticia.titulo setNumberOfLines:0];
            [self.timelineCeldaNoticia.intro setNumberOfLines:0];
            [self.timelineCeldaNoticia setNeedsLayout];
            [self.timelineCeldaNoticia layoutIfNeeded];
            CGFloat height = [self.timelineCeldaNoticia.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            
            if(height<60) height=161;
            return height;

            
        }
        else
            return UITableViewAutomaticDimension;
    }
    else if([elementoTipo isEqualToString:@"noticias2"])
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            static NSString *cellMainNibID = @"timelineCeldaNoticia";
            self.timelineCeldaNoticia2 = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
            if (self.timelineCeldaNoticia2 == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaNoticia" owner:self options:nil];
            }
            
            self.timelineCeldaNoticia2.titulo.text=[APIConnection getStringJSON:elementoActual withKey:@"titulonoti" widthDefValue:@""];
            
            self.timelineCeldaNoticia2.intro.attributedText = [self construyeHTML:[APIConnection getStringJSON:elementoActual withKey:@"intro" widthDefValue:@""]];
            
            [self.timelineCeldaNoticia2.titulo setPreferredMaxLayoutWidth:self.timelineCeldaNoticia2.titulo.frame.size.width];
            [self.timelineCeldaNoticia2.intro setPreferredMaxLayoutWidth:self.timelineCeldaNoticia2.titulo.frame.size.width];
            
            [self.timelineCeldaNoticia2.titulo setNumberOfLines:0];
            [self.timelineCeldaNoticia2.intro setNumberOfLines:0];
            [self.timelineCeldaNoticia2 setNeedsLayout];
            [self.timelineCeldaNoticia2 layoutIfNeeded];
            CGFloat height = [self.timelineCeldaNoticia2.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            
            if(height<135) height=135;
            return height;
            
            
        }
        else
            return UITableViewAutomaticDimension;
    }
    else if([elementoTipo isEqualToString:@"noticias3"])
        return UITableViewAutomaticDimension;
    else if([elementoTipo isEqualToString:@"titulo"])
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            static NSString *cellMainNibID = @"timelineCeldaTitulo";
            self.timelineCeldaTitulo = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
            if (self.timelineCeldaTitulo == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
            }
            self.timelineCeldaTitulo.titulo.text=[APIConnection getStringJSON:elementoActual withKey:@"titulo" widthDefValue:@""];
            [self.timelineCeldaTitulo.titulo setPreferredMaxLayoutWidth:self.timelineCeldaTitulo.titulo.frame.size.width];
            
            [self.timelineCeldaTitulo.titulo setNumberOfLines:0];
            [self.timelineCeldaTitulo setNeedsLayout];
            [self.timelineCeldaTitulo layoutIfNeeded];
            CGFloat height = [self.timelineCeldaTitulo.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            if(height<30) height=30;
            return height;
            
        }
        else
            return UITableViewAutomaticDimension;
    }
    else if([elementoTipo isEqualToString:@"conc"])
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            static NSString *cellMainNibID = @"timelineCeldaConc";
            self.timelineCeldaConc = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
            if (self.timelineCeldaConc == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaConc" owner:self options:nil];
            }
            self.timelineCeldaConc.concepto.text=[APIConnection getStringJSON:elementoActual withKey:@"concepto" widthDefValue:@""];
            [self.timelineCeldaConc.concepto setPreferredMaxLayoutWidth:self.timelineCeldaConc.concepto.frame.size.width];
            
            [self.timelineCeldaConc.concepto setNumberOfLines:0];
            [self.timelineCeldaConc setNeedsLayout];
            [self.timelineCeldaConc layoutIfNeeded];
            CGFloat height = [self.timelineCeldaConc.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            if(height<135) height=135;
            return height;
            
        }
        else
            return UITableViewAutomaticDimension;
    }
    else if([elementoTipo isEqualToString:@"reflexion"])
        return 180;
    else if([elementoTipo isEqualToString:@"tituloImagen"])
       return UITableViewAutomaticDimension;
    else if([elementoTipo isEqualToString:@"tituloInterno"])
        return UITableViewAutomaticDimension;
    else if([elementoTipo isEqualToString:@"audio"])
        return 39;
    else if([elementoTipo isEqualToString:@"texto"])
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            static NSString *cellMainNibID = @"timelineCeldaTexto";
            self.timelineCeldaTexto = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
            if (self.timelineCeldaTexto == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
            }
            
            self.timelineCeldaTexto.texto.attributedText = [self construyeHTML:[APIConnection getStringJSON:elementoActual withKey:@"texto" widthDefValue:@""]];
            //[self.timelineCeldaTexto.texto setPreferredMaxLayoutWidth:self.timelineCeldaTexto.texto.frame.size.width];
            //[self.timelineCeldaTexto.texto setNumberOfLines:0];
            [self.timelineCeldaTexto setNeedsLayout];
            [self.timelineCeldaTexto layoutIfNeeded];
            
            
            CGFloat height = [self.timelineCeldaTexto.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            if(height<48) height=48;
            return height;
            
        }
        else
            return UITableViewAutomaticDimension;
    }
    else if([elementoTipo isEqualToString:@"textoSeleccion"])
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
        {
            static NSString *cellMainNibID = @"timelineCeldaTextoSeleccion";
            self.timelineCeldaTextoSeleccion = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
            if (self.timelineCeldaTextoSeleccion == nil) {
                [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
            }
            
            self.timelineCeldaTextoSeleccion.texto.attributedText = [self construyeHTML:[APIConnection getStringJSON:elementoActual withKey:@"texto" widthDefValue:@""]];
            [self.timelineCeldaTextoSeleccion.texto setPreferredMaxLayoutWidth:self.timelineCeldaTexto.texto.frame.size.width];
            [self.timelineCeldaTextoSeleccion.texto setNumberOfLines:0];
            [self.timelineCeldaTextoSeleccion setNeedsLayout];
            [self.timelineCeldaTextoSeleccion layoutIfNeeded];
            CGFloat height = [self.timelineCeldaTextoSeleccion.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            
            
            if(height<70) height=70;
            return height;
            
        }
        else
            return UITableViewAutomaticDimension;
    }
    else if([elementoTipo isEqualToString:@"galeria"])
    {
        NSString *modo=[APIConnection getStringJSON:elementoActual withKey:@"modo" widthDefValue:@""];
        if([modo isEqualToString:@"mini"])
            return 90;
        else return 240;
    
    }
    else if([elementoTipo isEqualToString:@"textoPeque"])
    {
        
        static NSString *cellMainNibID = @"timelineCeldaTextoPeque";
        self.timelineCeldaTextoPeque = [tableView dequeueReusableCellWithIdentifier:cellMainNibID];
        if (self.timelineCeldaTextoPeque == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"timelineCeldaTitulo" owner:self options:nil];
        }
        self.timelineCeldaTextoPeque.texto.text=[APIConnection getStringJSON:elementoActual withKey:@"titulo" widthDefValue:@""];
        [self.timelineCeldaTextoPeque.texto setPreferredMaxLayoutWidth:self.timelineCeldaTextoPeque.texto.frame.size.width];
        
        [self.timelineCeldaTextoPeque.texto setNumberOfLines:0];
        [self.timelineCeldaTextoPeque setNeedsLayout];
        [self.timelineCeldaTextoPeque layoutIfNeeded];
        CGFloat height = [self.timelineCeldaTextoPeque.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        if(height<21) height=21;
        return height;
    }
    else if([elementoTipo isEqualToString:@"vacio"])
        return 18;
    else if([elementoTipo isEqualToString:@"boton"])
        return 40;
    else if([elementoTipo isEqualToString:@"generalSeparador"])
        return 11;
    else if([elementoTipo isEqualToString:@"generalFoto"])
        return 240;
    else if([elementoTipo isEqualToString:@"selecciona"])
        return 44;
    else if([elementoTipo isEqualToString:@"renglon"])
        return 30;
    else if([elementoTipo isEqualToString:@"botones"])
        return 44;
    else if([elementoTipo isEqualToString:@"mapa"])
        return 200;
    else if([elementoTipo isEqualToString:@"aviso"])
        return 100;
    else if([elementoTipo isEqualToString:@"calificacion"])
        return 50;
    else if([elementoTipo isEqualToString:@"pag"]) // es pago
        return 125;
    else if([elementoTipo isEqualToString:@"textoPantallaCompleta"])
        return self.contenedor.frame.size.height;
    else if([elementoTipo isEqualToString:@"cita"])
    {
        NSString *asistencia=[APIConnection getStringJSON:elementoActual withKey:@"asistencia" widthDefValue:@""];
        
        if([asistencia isEqualToString:@"0"])
            return 75;
        else
            return 100;
    }
    else if([elementoTipo isEqualToString:@"subtitulo"])
        return 28;

    else return 70;
}

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *elementoTipo;
    NSDictionary *elementoActual;
    if([indice count]>indexPath.row && [indiceTipos count]>indexPath.row)
    {
        elementoTipo = [indiceTipos objectAtIndex:indexPath.row];
        elementoActual = [indice objectAtIndex:indexPath.row];
    }
    else
        elementoTipo=@"vacio";
    
    if([elementoTipo isEqualToString:@"noticias"])
        return 161;
    else  if([elementoTipo isEqualToString:@"noticias2"])
        return 135;
    else if([elementoTipo isEqualToString:@"reflexion"])
        return 180;
    else if([elementoTipo isEqualToString:@"tituloImagen"])
        return 250;
    else if([elementoTipo isEqualToString:@"tituloInterno"])
        return 50;
    else if([elementoTipo isEqualToString:@"conc"])
        return 135;
    else if([elementoTipo isEqualToString:@"audio"])
        return 39;
    else if([elementoTipo isEqualToString:@"galeria"])
    {
        NSString *modo=[APIConnection getStringJSON:elementoTipo withKey:@"modo" widthDefValue:@""];
        if([modo isEqualToString:@"mini"])
            return 90;
        else return 240;
    }
    else if([elementoTipo isEqualToString:@"textoPeque"] || [elementoTipo isEqualToString:@"vacio"])
        return 18;
    else if([elementoTipo isEqualToString:@"boton"])
        return 40;
    else if([elementoTipo isEqualToString:@"generalSeparador"])
        return 10;
    else if([elementoTipo isEqualToString:@"generalFoto"])
        return 240;
    else if([elementoTipo isEqualToString:@"selecciona"])
        return 44;
    else if([elementoTipo isEqualToString:@"renglon"])
        return 30;
    else if([elementoTipo isEqualToString:@"botones"])
        return 44;
    else if([elementoTipo isEqualToString:@"mapa"])
        return 200;
    else if([elementoTipo isEqualToString:@"mapa"])
        return 100;
    else if([elementoTipo isEqualToString:@"calificacion"])
        return 50;
    else if([elementoTipo isEqualToString:@"pag"]) // es pago
        return 125;
    else if([elementoTipo isEqualToString:@"textoPantallaCompleta"])
        return self.contenedor.frame.size.height;
    else return 70;
}

-(NSMutableAttributedString *)construyeHTML:(NSString *)texto
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"string" ofType:@"html"];
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    html = [html stringByReplacingOccurrencesOfString:@"<contenido>" withString:texto];
    html = [html stringByReplacingOccurrencesOfString:@"<colorFondo1>" withString:[configPrincipal objectForKey:@"colorFondo1"]];
    html = [html stringByReplacingOccurrencesOfString:@"<colorTexto>" withString:[configPrincipal objectForKey:@"colorTexto"]];
    NSString* filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* fileName = @"archivoGuardado.html";
    NSString* fileAtPath = [filePath stringByAppendingPathComponent:fileName];

    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    // The main act...
    
  //  [html dataUsingEncoding:NSUnicodeStringEncoding]
    
    [[html dataUsingEncoding:NSUnicodeStringEncoding] writeToFile:fileAtPath atomically:NO];
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    NSString *soundPath = [documentsDirectory stringByAppendingPathComponent:@"archivoGuardado.html"];
    
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath isDirectory:NO];
    NSMutableAttributedString *stringWithHTMLAttributes = [[NSMutableAttributedString alloc] initWithFileURL:soundURL
                                                                                                     options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                                                                          documentAttributes:nil
                                                                                                       error:nil];
    return stringWithHTMLAttributes;
}


-(void)abrePerfil:(long)cual
{
    [self.delegate abrePerfil:cual conDiccionario:[indice objectAtIndex:cual]];
}

-(NSString *)extraeTabla:(NSString *)tipotimeline
{
    NSString *tabla=@"";
    if([tipotimeline isEqualToString:@"foto"]) tabla=@"fotos";
    else if([tipotimeline isEqualToString:@"noticias"]) tabla=@"noti";
    else if([tipotimeline isEqualToString:@"video"]) tabla=@"vid";
    else if([tipotimeline isEqualToString:@"comentario"]) tabla=@"com";
    else if([tipotimeline isEqualToString:@"lug"]) tabla=@"lug";
    return tabla;
}

-(void)actualizaBarraSocial:(long)cual conValor:(long)valor
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:[indice objectAtIndex:cual]];
    long tcomentarios=[APIConnection getIntJSON:dic withKey:@"tcomentarios" widthDefValue:@"0"];
    tcomentarios+=valor;
    [dic setObject:[NSString stringWithFormat:@"%ld",tcomentarios] forKey:@"tcomentarios"];
    [indice replaceObjectAtIndex:cual withObject:dic];
    [self.contenedor beginUpdates];
    [self.contenedor reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cual inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.contenedor endUpdates];
}

-(void)compartirTimeline:(long)cual
{
    NSDictionary *elemento=[indice objectAtIndex:cual];
    NSString *urlAmigabletim=[APIConnection getStringJSON:elemento withKey:@"urlAmigabletim" widthDefValue:@""];

    [self.delegate compartirDesdeTimeLine:[NSString stringWithFormat:@"%@%@",GAPIShare,urlAmigabletim]];
}

-(void)abreFirma
{
    [self.delegate abreFirma];
}

- (IBAction)tapBotonAviso:(id)sender {
    if([modoInternoAviso isEqualToString:@"NoFavoritos"])
    {
        [self.delegate abreMiPerfil];
    }
    else if([modoInternoAviso isEqualToString:@"NoActividad"])
    {
        [self.delegate subirFoto];
    }
    else
    {
        [self.delegate recargaContenido];
    }
}

-(void)mostrarAviso:(NSString *)modo
{
    modoInternoAviso=modo;
    [indice removeAllObjects];
    [indiceTipos removeAllObjects];
    [self.contenedor reloadData];
    [self.botonAviso setHidden:false];

    if([modo isEqualToString:@"NoInternet"])
        self.textoAviso.text=@"La conexión internet no está funcionando correctamente. Intenta otra vez presionando aquí";
    else if([modo isEqualToString:@"NoFavoritos"])
        self.textoAviso.text=@"No encontramos información de tus favoritos. Puedes registrar que te gustan Equipos tocando AQUÍ. También puedes hacerlo en la hoja de cada Jugador, Equipo o Juego.";
    else if([modo isEqualToString:@"NoActividad"])
    {
        [self.botonAviso setHidden:false];
        self.textoAviso.text=@"No tienes actividad. Puedes comentar y subir fotos y videos. Puedes subir una foto tocando AQUÍ. ¡Participa ya!";
    }
    [self.noinfo setHidden:false];
    [self.contenedor setHidden:true];
}

-(void)cargaMapa:(long)tagActual
{
    NSDictionary *elemento=[indice objectAtIndex:tagActual];
    [self.delegate abreVentana:@"mapa" conDiccionario:elemento conIDreal:@""];
}

-(void)abreBotones:(NSString *)cadena conModo:(NSString *)modo
{
    if([modo isEqualToString:@"url"])
        [self.delegate abreURLDirecta:cadena conModo:@"web" conOperacion:@"web" conIdreal:@""];
    else if([modo isEqualToString:@"email"])
        [self.delegate abreURLDirecta:cadena conModo:@"email" conOperacion:@"email" conIdreal:@""];
    else if([modo isEqualToString:@"telefono"])
    {
        cadena = [@"tel://" stringByAppendingString:cadena];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:cadena]];
    }
}

-(void)calculaSeleccionActual
{
    self.seleccionActual=0;
    for(NSDictionary *elemento in indice)
    {
        if(![[APIConnection getStringJSON:elemento withKey:@"seleccionado" widthDefValue:@"0"] isEqualToString:@"0"])
            self.seleccionActual++;
    }
}
-(void)seleccionarTextoSeleccion:(long)cual
{
    if(self.editando)
    {
        NSMutableArray *indiceTemporal=[[NSMutableArray alloc] init];
        [self calculaSeleccionActual];
        long cuenta=0;
        long actualNumero=-1,anteriorNumero=-1;
        NSString *actualSeleccionado=@"",*anteriorSeleccionado=@"";
        for(NSDictionary *elemento in indice)
        {
            NSMutableDictionary *elemento2=[NSMutableDictionary dictionaryWithDictionary:elemento];
            NSString *tipotimeline=[APIConnection getStringJSON:elemento2 withKey:@"tipotimeline" widthDefValue:@""];
            if([tipotimeline isEqualToString:@"textoSeleccion"])
            {
                if(self.seleccionMaximo==1) // solo se permite uno, entonces tenemos que desmarcar todo
                {
                    if(cuenta!=cual) // no es el actual y solo permitimos 1
                    {
                        NSString *seleccionadoActual=[APIConnection getStringJSON:elemento2 withKey:@"seleccionado" widthDefValue:@"0"];
                        if([seleccionadoActual isEqualToString:@"1"])
                        {
                            anteriorNumero=cuenta;
                            anteriorSeleccionado=seleccionadoActual;
                        }
                        [elemento2 setObject:@"0" forKey:@"seleccionado"];
                    }
                    else
                    {
                        actualNumero=cual;
                        actualSeleccionado=[APIConnection getStringJSON:elemento2 withKey:@"seleccionado" widthDefValue:@"0"];
                        if([actualSeleccionado isEqualToString:@"1"])
                            [elemento2 setObject:@"0" forKey:@"seleccionado"];
                        else [elemento2 setObject:@"1" forKey:@"seleccionado"];
                    }
                }
                else // permitimos varios, entonces solo operamos el actual
                {
                    if(cuenta==cual)
                    {
                        actualNumero=cual;
                        NSString *subtipotimeline=[APIConnection getStringJSON:elemento2 withKey:@"subtipotimeline" widthDefValue:@""];
                        if([subtipotimeline isEqualToString:@"textoSeleccionMultiple"]) // es de seleccion multiple
                        {
                            actualSeleccionado=[APIConnection getStringJSON:elemento2 withKey:@"seleccionado" widthDefValue:@"0"];
                            if([actualSeleccionado isEqualToString:@"0"]) [elemento2 setObject:@"11" forKey:@"seleccionado"];
                            else if([actualSeleccionado isEqualToString:@"11"]) [elemento2 setObject:@"12" forKey:@"seleccionado"];
                            else if([actualSeleccionado isEqualToString:@"12"]) [elemento2 setObject:@"13" forKey:@"seleccionado"];
                            else if([actualSeleccionado isEqualToString:@"13"]) [elemento2 setObject:@"0" forKey:@"seleccionado"];
                        }
                        else
                        {
                            actualSeleccionado=[APIConnection getStringJSON:elemento2 withKey:@"seleccionado" widthDefValue:@"0"];

                            if([actualSeleccionado isEqualToString:@"1"])
                            {
                                [elemento2 setObject:@"0" forKey:@"seleccionado"];
                            }
                            else
                            {
                                if(self.seleccionMaximo<=self.seleccionActual) // no puedes dar de alta más
                                {
                                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"No puedes seleccionar más" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                    [av show];
                                }
                                else
                                    [elemento2 setObject:@"1" forKey:@"seleccionado"];
                            }
                            
                        }
                    }
                }
            }
            [indiceTemporal addObject:elemento2];
            cuenta++;
        }
        indice=[NSMutableArray arrayWithArray:indiceTemporal];
        [self.contenedor reloadData];
        
        
        NSDictionary *elementoActual=[indice objectAtIndex:actualNumero];
        [APIConnection2 connectAPI:[NSString stringWithFormat:@"enceVotos.php?idence=%@&idcat=%@&seleccionado=%@&actualNumero=%ld&actualSeleccionado=%@&anteriorNumero=%ld&anteriorSeleccionado=%@",self.idence,[APIConnection getStringJSON:elementoActual withKey:@"idcat" widthDefValue:@"0"],[APIConnection getStringJSON:elementoActual withKey:@"seleccionado" widthDefValue:@"0"],actualNumero,actualSeleccionado,anteriorNumero,anteriorSeleccionado] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"enceVotos" willContinueLoading:false];
        

    }
}

-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    if([senderValue isEqualToString:@"enceVotos"])
    {
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        NSDictionary *status=[APIConnection getDictionaryJSON:response withKey:@"status"];
        NSString *codigo=[APIConnection getStringJSON:status withKey:@"codigo" widthDefValue:@"ERROR"];
        if(![codigo isEqualToString:@"OK"]) // ocurrio un error
        {
            self.editando=false;
            long actualNumero=[APIConnection getIntJSON:status withKey:@"actualNumero" widthDefValue:@"-1"];
            NSString *actualSeleccionado=[APIConnection getStringJSON:status withKey:@"actualSeleccionado" widthDefValue:@"0"];
            
            long anteriorNumero=[APIConnection getIntJSON:status withKey:@"anteriorNumero" widthDefValue:@"-1"];
            NSString *anteriorSeleccionado=[APIConnection getStringJSON:status withKey:@"anteriorSeleccionado" widthDefValue:@"0"];
            
            
            if(actualNumero != -1)
            {
                NSMutableDictionary *diccionarioCambio=[indice objectAtIndex:actualNumero];
                [diccionarioCambio setObject:actualSeleccionado forKey:@"seleccionado"];
                [indice replaceObjectAtIndex:actualNumero withObject:diccionarioCambio];
            }
            if(anteriorNumero != -1)
            {
                NSMutableDictionary *diccionarioCambio=[indice objectAtIndex:anteriorNumero];
                [diccionarioCambio setObject:anteriorSeleccionado forKey:@"seleccionado"];
                [indice replaceObjectAtIndex:anteriorNumero withObject:diccionarioCambio];
            }
            [self.contenedor reloadData];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Aviso" message:[APIConnection getStringJSON:status withKey:@"mensaje" widthDefValue:@""] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [av show];
            [self.delegate actualizaEditando:self.editando];
        }
        
    }
}

-(NSString *)generaMoneda:(NSString *)cantidad
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: [cantidad floatValue]]];
    return numberAsString;
}
@end



