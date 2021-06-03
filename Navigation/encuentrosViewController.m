//
//  encuentrosViewController.m
//  centrovita
//
//  Created by Guillermo on 22/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import "encuentrosViewController.h"
#import "actividadesViewController.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "AppDelegate.h"

@interface encuentrosViewController ()<EKEventEditViewDelegate>

@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours

@end

@implementation encuentrosViewController
@synthesize timeline=_timeline;
@synthesize timelineDistancia=_timelineDistancia;
@synthesize pasoActual=_pasoActual;
@synthesize vistaHeader=_vistaHeader;
@synthesize botonSiguiente=_botonSiguiente;
@synthesize botonAnterior=_botonAnterior;
@synthesize tituloPrincipal=_tituloPrincipal;

#import "color.h"
#import "globales.h"
-(void)mostrarAvisoNoInternet
{
    self.timelineDistancia.constant=50;
    [self.timeline layoutIfNeeded];
    [self.timeline mostrarAviso:@"NoInternet"];
}

-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    [refreshControl endRefreshing];
    jsonOriginal=[NSDictionary dictionaryWithDictionary:json];
    //NSLog(@"%@ %@",senderValue,json);
    NSMutableArray *indiceTemporal=[[NSMutableArray alloc] init];
    
    if([senderValue isEqualToString:@"notas"])
    {
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        indiceTemporal=[APIConnection getArrayJSON:response withKey:@"indice"];
        [indice removeAllObjects];
        [indiceTipos removeAllObjects];
        for(NSMutableDictionary *elemento in indiceTemporal)
        {
            [indice addObject:elemento];
            [indiceTipos addObject:[APIConnection getStringJSON:elemento withKey:@"tipotimeline" widthDefValue:@""]];
        }
        [self.timeline acomoda:indice conTipos:indiceTipos conPagina:pagina conSeparador:false conVentana:@"" conAudios:1];
        [self animarRegreso];
        [self.botonSiguiente setHidden:true];
    }
    else if([senderValue isEqualToString:@"consulta"] || [senderValue isEqualToString:@"catDetalle"] || [senderValue isEqualToString:@"catLeer"])
    {

        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        if([senderValue isEqualToString:@"catDetalle"])
        {

            /*
            NSString *audio=[APIConnection getStringJSON:response withKey:@"audio" widthDefValue:@""];
            audio=@"audio/574audio77408.m4a";
            if(![audio isEqualToString:@""])
            {
                audio = [audio stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                audio=[NSString stringWithFormat:@"%@%@",GAPIURLImages,audio];
                
                 distancia=90;
                
                AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                self.audioArchivo=audio;
                [appDelegate cargaAudio:audio];
                
            }*/
            NSString *tipocatRespuesta=[APIConnection getStringJSON:response withKey:@"tipocat" widthDefValue:@"0"];
            diccionarioCalendario=[APIConnection getDictionaryJSON:response withKey:@"calendario"];
           
           
            

            if([tipocatRespuesta isEqualToString:@"2"] || [tipocatRespuesta isEqualToString:@"3"])
            {
                if([tipocatRespuesta isEqualToString:@"2"])
                    ventanaActualCalendario=@"actuarDetalle"; // actuar
                else ventanaActualCalendario=@"catDetalle"; // apostolado
                // aca revisaremos si ya esta en la tabla
                enCalendario=[self leeCalendario:ventanaActualCalendario conidregistrocal:self.idreal conidusuariocal:uid];
                [self.botonSiguiente setHidden:false];
                if([enCalendario isEqualToString:@""])
                    [self.botonSiguiente setImage:[UIImage imageNamed:@"encuentroCalendario0"] forState:UIControlStateNormal];
                else
                    [self.botonSiguiente setImage:[UIImage imageNamed:@"encuentroCalendario1"] forState:UIControlStateNormal];
                
            }
            else [self.botonSiguiente setHidden:true];
        }
        
        if([senderValue isEqualToString:@"consulta"])
        {
            operaEncuentro=[APIConnection getBOOLJSON:response withKey:@"operaEncuentro" widthDefValue:false];
        }
        
        NSDictionary *salir=[APIConnection getDictionaryJSON:response withKey:@"salir"];
        if(salir)
        {
            NSString *operacion=[APIConnection getStringJSON:salir withKey:@"operacion" widthDefValue:@""];
            if([operacion isEqualToString:@"salir"])
            {
                [timerX invalidate];
                timerX=NULL;
                [APIConnection limpiaSesion];
                [APIConnection connectionCancel];
                [self dismissViewControllerAnimated:true completion:^{
                    
                    
                }];
            }
        }
        
        self.pasoActual=[APIConnection getIntJSON:response withKey:@"pasoActual" widthDefValue:[NSString stringWithFormat:@"%ld",self.pasoActual]];
        [self pintaTitulo];
        
        
        NSDictionary *configuracion=[APIConnection getDictionaryJSON:response withKey:@"configuracion"];
        if(configuracion)
        {
            seleccionMaximo=[APIConnection getIntJSON:configuracion withKey:@"seleccionMaximo" widthDefValue:@"0"];
            seleccionMinimo=[APIConnection getIntJSON:configuracion withKey:@"seleccionMinimo" widthDefValue:@"0"];
            editando=[APIConnection getBOOLJSON:configuracion withKey:@"editando" widthDefValue:false];
            self.timeline.seleccionMinimo=seleccionMinimo;
            self.timeline.seleccionMaximo=seleccionMaximo;
            self.timeline.editando=editando;
        }
        
        self.timeline.idence=self.idreal;
        
        indiceTemporal=[APIConnection getArrayJSON:response withKey:@"indice"];
        [indice removeAllObjects];
        [indiceTipos removeAllObjects];
        
        if([senderValue isEqualToString:@"catDetalle"])
       {

           
           NSString *audio=[APIConnection getStringJSON:response withKey:@"audio" widthDefValue:@""];
           if(![audio isEqualToString:@""])
           {
               [indice addObject:[NSDictionary dictionaryWithObjectsAndKeys:audio,@"audio",@"audio",@"tipotimeline", nil]];
               [indiceTipos addObject:@"audio"];
               
               [indice addObject:[NSDictionary dictionaryWithObjectsAndKeys:audio,@"audio",@"audio",@"tipotimeline", nil]];
               [indiceTipos addObject:@"generalSeparador"];
           }
       }
                   
        for(NSMutableDictionary *elemento in indiceTemporal)
        {
            [indice addObject:elemento];
            [indiceTipos addObject:[APIConnection getStringJSON:elemento withKey:@"tipotimeline" widthDefValue:@""]];
        }
        [self.timeline acomoda:indice conTipos:indiceTipos conPagina:pagina conSeparador:false conVentana:@"" conAudios:1];
        [self animarRegreso];
        
        
        
    }
    else if([senderValue isEqualToString:@"vimeo"])
    {
       
    }
    else if([senderValue isEqualToString:@"enceStatus"] || [senderValue isEqualToString:@"enceStatusAdelante"])
    {
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        NSDictionary *accion=[APIConnection getDictionaryJSON:response withKey:@"accion"];
        long statusence=[APIConnection getIntJSON:accion withKey:@"statusence" widthDefValue:[NSString stringWithFormat:@"%ld",self.pasoActual]];
        //NSLog(@"%ld %ld %@",statusence,self.pasoActual,senderValue);
        if([senderValue isEqualToString:@"enceStatusAdelante"])
        {
            if(statusence==self.pasoActual) // es el mismo paso y nos faltan elementos
            {
                NSString *mensaje=[NSString stringWithFormat:@"Debes seleccionar al menos %ld opción(es)",seleccionMinimo];
                if(seleccionMinimo==seleccionMaximo && seleccionMinimo!=1)
                    mensaje=@"Debes seleccionar todos los elementos";
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:mensaje delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [av show];
                [self arrancaTimer];
            }
            else [self adelanteAccion];
        }
        else
        {
            if(statusence!=self.pasoActual && editando)
            {
                editando=false;
                self.timeline.editando=false;
                [self.timeline.contenedor reloadData];
                
            }
            else if(!editando && statusence==self.pasoActual)
            {
                editando=true;
                self.timeline.editando=true;
                [self.timeline.contenedor reloadData];
            }
            [self arrancaTimer];
        }
    }
    else if([senderValue isEqualToString:@"enceTermina"])
    {
        stringToPass2=@"enceStatus";
        [self dismissViewControllerAnimated:true completion:^{       }];
    }
    else if([senderValue isEqualToString:@"catGuarda"])
    {
        [self arrancaTimer];
    }
    
    if([ventanaActualCalendario isEqualToString:@""])
        [self.botonSiguiente setImage:[UIImage imageNamed:@"encuentroSiguiente"] forState:UIControlStateNormal];
    
    [super APIresponse:json :errorValue :senderValue];
    
}

-(void)pintaTitulo
{
    NSString *titulo=@"";
    //[self.botonSiguiente setImage:[UIImage imageNamed:@"encuentroSiguiente"] forState:UIControlStateNormal];
    if(self.pasoActual==-1)
    {
        
        if([self.ventanaActual isEqualToString:@"editarCasos"])
            titulo=@"Editar Casos";
        else if([self.ventanaActual isEqualToString:@"editarActuares"])
            titulo=@"Editar Actuares";
        else if([self.ventanaActual isEqualToString:@"editarNotas"])
            titulo=@"Editar Notas";
        else
        {
            titulo=@"Detalle";
            
            
        }
    }

    else if(self.pasoActual==0) titulo=@"Oración inicial";
    else if(self.pasoActual==1) titulo=@"Lectura evangélica";
    else if(self.pasoActual==2) titulo=@"Video";
    else if(self.pasoActual==3) titulo=@"Revisión de Compromisos";
    else if(self.pasoActual==4) titulo=@"Selección de caso";
    else if(self.pasoActual==5) titulo=@"Presentación de caso";
    else if(self.pasoActual==55) titulo=@"Análisis de caso";
    else if(self.pasoActual==6) titulo=@"Selección de actuares";
    else if(self.pasoActual==7) titulo=@"Apostolados";
    else if(self.pasoActual==8) titulo=@"Aportaciones de Miembros";
    else if(self.pasoActual==9) titulo=@"Oración final";
    else if(self.pasoActual==333) titulo=@"";
    self.tituloPrincipal.text=titulo;
}

- (void)viewDidLoad
{
    distancia=50;
    [self.vistaHeader setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.view setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    self.eventStore = [[EKEventStore alloc] init];

    ventanaActualCalendario=@"";
    pasos=9;
    seleccionMaximo=0;
    seleccionMinimo=0;
    editando=FALSE;
    [super viewDidLoad];
    
    self.timeline.delegate=self;
    self.timelineDistancia.constant=700;
    [self.view setNeedsLayout];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(recargaContenido)
             forControlEvents:UIControlEventValueChanged];
    [self.timeline.contenedor addSubview:refreshControl];
    
    [self.timeline layoutIfNeeded];
    
    [self.timeline setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    
    [self pintaTitulo];
   
    [self.botonAnterior setTintColor:[self colorDesdeString:@"#FFFFFF" withAlpha:1.0]];
    [self.botonSiguiente setTintColor:[self colorDesdeString:@"#FFFFFF" withAlpha:1.0]];
    yacargado=false;
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    if(!yacargado || self.pasoActual==3 || self.pasoActual==4 || self.pasoActual==5 || self.pasoActual==6 || self.pasoActual==7)
    {
        yacargado=true;
        [self recargaContenido];
        
        
        if(self.pasoActual==3 || self.pasoActual==4 || self.pasoActual==6 || self.pasoActual==7)
            [self arrancaTimer];
        
    }
    if(cambioFuenteAhora || self.multiplicadorFuenteActual!=multiplicadorFuente || ![self.colorFuenteLocal isEqualToString:colorFuenteGlobal])
    {
         self.colorFuenteLocal=colorFuenteGlobal;
        self.multiplicadorFuenteActual=multiplicadorFuente;
        cambioFuenteAhora=false;
        
        [self.timeline.contenedor reloadData];
    }
    if([stringToPass isEqualToString:@"refrescarEditar"])
    {
        [self recargaContenido];
        stringToPass=@"";
    }

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
    if(self.pasoActual>-1)
    {
        if([tokenManager isEqualToString:@"1"])
        {
            [APIConnection connectAPI:[NSString stringWithFormat:@"encLeer.php?paso=%ld&idreal=%@&iniciarEncuentro=%@",self.pasoActual,self.idreal,stringToPass] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"consulta" willContinueLoading:false];
            stringToPass=@"";
        }
        else
            [APIConnection connectAPI:[NSString stringWithFormat:@"encLeer.php?paso=%ld&idreal=%@&iniciarEncuentro=%@",self.pasoActual,self.idreal,stringToPass] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"consulta" willContinueLoading:false];
        
        [self analytics:@"encLeer" conAccion:self.idreal conLabel:[NSString stringWithFormat:@"%ld",self.pasoActual]];
       
    }
    else
    {
        if([self.ventanaActual isEqualToString:@"editarCasos"] || [self.ventanaActual isEqualToString:@"editarActuares"])
        {
            [APIConnection connectAPI:[NSString stringWithFormat:@"catLeer.php?modo=%@&idreal=%@",self.ventanaActual,self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"catLeer" willContinueLoading:false];
            [self analytics:@"catLeer" conAccion:self.ventanaActual conLabel:@""];
        }
        else if([self.ventanaActual isEqualToString:@"editarNotas"])
        {
            [APIConnection connectAPI:[NSString stringWithFormat:@"notas.php?idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"notas" willContinueLoading:false];
            [self analytics:@"notas" conAccion:self.ventanaActual conLabel:@""];
        }
        else
        {
            [APIConnection connectAPI:[NSString stringWithFormat:@"catDetalle.php?mostrarVideo=no&idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"catDetalle" willContinueLoading:false];
            [self analytics:@"catDetalle" conAccion:self.idreal conLabel:@""];
        }
    
    }
}



-(void)animarRegreso
{
    
    self.timelineDistancia.constant=distancia;
    [UIView animateWithDuration:0.5 animations:^{
        [self.timeline layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if(pagina==1)
            [self.timeline.contenedor scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        
    }];
}



-(void)scrollToTop
{
    [self.timeline.contenedor scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:true];
}

- (IBAction)atras:(id)sender
{
    if(self.pasoActual==0)
    {
        [APIConnection connectionCancel];
        [timerX invalidate];
        timerX=NULL;
        [self dismissViewControllerAnimated:true completion:^{       }];
    }
    else
    {
        [APIConnection connectionCancel];
        [timerX invalidate];
        timerX=NULL;
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (IBAction)adelante:(id)sender
{
    if(self.pasoActual==pasos)
    {
        if(operaEncuentro) // [tokenManager isEqualToString:@"1"] ||
        {
            [timerX invalidate];
            timerX=NULL;
            
            [APIConnection connectionCancel];
            [APIConnection connectAPI:[NSString stringWithFormat:@"enceTermina.php?idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"enceTermina" willContinueLoading:false];
            
        }
        else
        {
            [APIConnection connectionCancel];
            [timerX invalidate];
            timerX=NULL;
            [self dismissViewControllerAnimated:true completion:^{       }];
        }
        
        
        
    }
    else if(self.pasoActual==7)
    {
        [APIConnection connectionCancel];
        [timerX invalidate];
        timerX=NULL;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        actividadesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"actividades"];
        vc.diccionario=self.diccionario;
        vc.idreal=[APIConnection getStringJSON:self.diccionario withKey:@"idreal" widthDefValue:@"0"];
        vc.ventanaActual=@"conc";
        vc.ventanaActual2=@"ence";
        [self.navigationController pushViewController:vc animated:true];
    }
    else if(self.pasoActual==-1)
    {
        if(![self.ventanaActual isEqualToString:@"editarCasos"] && ![self.ventanaActual isEqualToString:@"editarActuares"])
        {
            [self clicEnCalendario];
        }
    }
    else
    {
        [self.timeline calculaSeleccionActual];
        if(seleccionMinimo>0 && self.timeline.seleccionActual<seleccionMinimo && editando)
        {
            [APIConnection connectionCancel];
            [timerX invalidate];
            timerX=NULL;
            [APIConnection connectAPI:[NSString stringWithFormat:@"enceStatus.php?idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"enceStatusAdelante" willContinueLoading:false];
            
           
            
        }
        else
        {
            [self adelanteAccion];
        }
        
    }
    
    

}

-(void)adelanteAccion
{
    /*
     else
     {
     [timerX invalidate];
     timerX=NULL;
     [APIConnection connectionCancel];
     [self.timeline calculaSeleccionActual];
     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
     encuentrosViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"encuentros"];
     vc.diccionario=self.diccionario;
     vc.idreal=[APIConnection getStringJSON:self.diccionario withKey:@"idreal" widthDefValue:@"0"];
     
     if(self.pasoActual==-2)
     vc.pasoActual=0;
     else if(self.pasoActual==3)
     vc.pasoActual=33;
     else if(self.pasoActual==33)
     vc.pasoActual=333;
     else if(self.pasoActual==333)
     vc.pasoActual=4;
     else if(self.pasoActual==5)
     vc.pasoActual=55;
     else if(self.pasoActual==55)
     vc.pasoActual=6;
     else
     vc.pasoActual=self.pasoActual+1;
     
     
     [self.navigationController pushViewController:vc animated:true];
     
     }
     */
    long pasoActualT=self.pasoActual+1;
    if(self.pasoActual==3) { self.pasoActual=331; pasoActualT=self.pasoActual+1; }
    if(self.pasoActual==332) { self.pasoActual=332; pasoActualT=self.pasoActual+1; }
    else if(self.pasoActual==333) {self.pasoActual=3; pasoActualT=self.pasoActual+1; }
    
    else if(self.pasoActual==5)
        pasoActualT=55;
    else if(self.pasoActual==55)
        pasoActualT=6;
    
    
    [APIConnection connectionCancel];
    [timerX invalidate];
    timerX=NULL;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    encuentrosViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"encuentros"];
    vc.diccionario=self.diccionario;
    vc.idreal=[APIConnection getStringJSON:self.diccionario withKey:@"idreal" widthDefValue:@"0"];
    vc.pasoActual=pasoActualT;
    
    [self.navigationController pushViewController:vc animated:true];
}

-(void)detieneAudio:(BOOL)cerrar
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if(appDelegate.movieplayer)
    {
        [appDelegate.movieplayer pause];
        if(cerrar)
            appDelegate.movieplayer=NULL;
    }
}

-(void)actualizaEditando:(BOOL)editandoPasado
{
    editando=editandoPasado;
}

-(void)onTick:(NSTimer *)timer {
    [timerX invalidate];
    timerX=NULL;
    if((self.pasoActual==4 || self.pasoActual==6))
        [APIConnection connectAPI:[NSString stringWithFormat:@"encLeer.php?paso=%ld&idreal=%@",self.pasoActual,self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:false onErrorReturn:false withSender:@"consulta" willContinueLoading:false];
    else
        [APIConnection connectAPI:[NSString stringWithFormat:@"enceStatus.php?idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:false onErrorReturn:false withSender:@"enceStatus" willContinueLoading:false];
    [self arrancaTimer];
    //do smth
}

-(void)arrancaTimer
{
    timerX = [NSTimer scheduledTimerWithTimeInterval: 10
                                              target: self
                                            selector:@selector(onTick:)
                                            userInfo: nil repeats:NO];
}

-(void)analytics:(NSString*)category conAccion:(NSString*)accion conLabel:(NSString*)label{
    //NSLog(@"%@ / %@ / %@",category,accion,label);
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
     [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
     action:accion
     label:label
     value:nil] build]];
    
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)actualizaCat:(NSString *)nombre conTexto:(NSString *)texto
{
    /*[catpropio setObject:nombre forKey:@"nombrecat"];
    [catpropio setObject:texto forKey:@"textocat"];
    [self pintacatpropio];
    */
    [APIConnection connectAPI:[NSString stringWithFormat:@"catGuarda.php?nombre=%@&texto=%@&idreal=%@&paso=%ld",nombre,texto,self.idreal,self.pasoActual] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"catGuarda" willContinueLoading:false];
}

-(void)noActualizaCat
{
    [self arrancaTimer];
}



-(void)clicEnCalendario
{
    if([enCalendario isEqualToString:@""])
    {
        [self checkEventStoreAccessForCalendar];
    }
    else
    {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"¿Borrar del calendario?"
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* no = [UIAlertAction
                             actionWithTitle:@"Cancelar"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                             }];
        [view addAction:no];
        
        UIAlertAction* si = [UIAlertAction
                             actionWithTitle:@"Borrar"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 NSArray *items = [self.eventStore calendarItemsWithExternalIdentifier:enCalendario];
                                 if ([items count] == 1)
                                 {
                                     NSError *anError = nil;
                                     [self.eventStore removeEvent:items[0] span:EKSpanThisEvent error:&anError];
                                     
                                 }
                                 enCalendario=@"";
                                 [self borrarCalendario:ventanaActualCalendario conidregistrocal:self.idreal conidusuariocal:uid];
                                 [self.botonSiguiente setImage:[UIImage imageNamed:@"encuentroCalendario0"] forState:UIControlStateNormal];
                                 [SVProgressHUD showSuccessWithStatus:@"Quitado del calendario"];
                             }];
        [view addAction:si];
        [self presentViewController:view animated:YES completion:nil];
    }
}



// Check the authorization status of our application for Calendar
-(void)checkEventStoreAccessForCalendar
{
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status)
    {
            
            // Update our UI if the user has granted access to their Calendar
        case EKAuthorizationStatusAuthorized: [self accessGrantedForCalendar];
            break;
            // Prompt the user for access to Calendar if there is no definitive answer
        case EKAuthorizationStatusNotDetermined: [self requestCalendarAccess];
            break;
            // Display a message if the user has denied or restricted access to Calendar
        case EKAuthorizationStatusDenied:
        case EKAuthorizationStatusRestricted:
        {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Advertencia" message:@"No tenemos privilegios para acceder a tu calendario"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
    
}


// Prompt the user for access to their Calendar
-(void)requestCalendarAccess
{
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         if (granted)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self accessGrantedForCalendar];
             });
         }
     }];
}


// This method is called when the user has granted permission to Calendar
-(void)accessGrantedForCalendar
{
    self.defaultCalendar = self.eventStore.defaultCalendarForNewEvents;
    [self addEvent:nil];
}

- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller
{
    return self.defaultCalendar;
}

- (IBAction)addEvent:(id)sender
{
    // Create an instance of EKEventEditViewController
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] init];
    
    EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
    if([ventanaActualCalendario isEqualToString:@"actuarDetalle"] || [ventanaActualCalendario isEqualToString:@"catDetalle"])
    {
        event.title=[APIConnection getStringJSON:diccionarioCalendario withKey:@"titulo" widthDefValue:@""];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        NSString *fechaUsar= [APIConnection getStringJSON:diccionarioCalendario withKey:@"fecha" widthDefValue:@""];
        if(![fechaUsar isEqualToString:@""])
        {
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
            event.startDate = [dateFormat dateFromString:fechaUsar];
        }
        else event.startDate=[NSDate date];
        
        NSString *fechafin= [APIConnection getStringJSON:diccionarioCalendario withKey:@"fechafin" widthDefValue:@""];
        if([fechafin isEqualToString:@""])
            event.endDate = [event.startDate dateByAddingTimeInterval:60*60];
        else
            event.endDate = [dateFormat dateFromString:fechafin];
    }
    addController.event = event;
    addController.eventStore = self.eventStore;
    addController.editViewDelegate = self;
    [self presentViewController:addController animated:YES completion:nil];
}

// Overriding EKEventEditViewDelegate method to update event store according to user actions.
- (void)eventEditViewController:(EKEventEditViewController *)controller
          didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         if (action != EKEventEditViewActionCanceled)
         {
             dispatch_async(dispatch_get_main_queue(), ^{

                 enCalendario=controller.event.calendarItemExternalIdentifier;
                 [self guardaCalendario:ventanaActualCalendario conidregistrocal:self.idreal conidusuariocal:uid conidcalendariocal:enCalendario];
                 [self.botonSiguiente setImage:[UIImage imageNamed:@"encuentroCalendario1"] forState:UIControlStateNormal];
                 [SVProgressHUD showSuccessWithStatus:@"Agregado al calendario"];
                 
             });
         }
     }];
}



@end

