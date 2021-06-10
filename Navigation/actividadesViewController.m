//
//  actividadesViewController.m
//  micartelera
//
//  Created by Guillermo on 16/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//


#import "actividadesViewController.h"
#import "encuentrosViewController.h"
#import "acompanantesViewController.h"
#import "perfilViewController.h"
#import "AppDelegate.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface actividadesViewController ()<EKEventEditViewDelegate>

@property (nonatomic, strong) EKEventStore *eventStore;

// Default calendar associated with the above event store
@property (nonatomic, strong) EKCalendar *defaultCalendar;

// Array of all events happening within the next 24 hours
@end

@implementation actividadesViewController
@synthesize headerPrincipal=_headerPrincipal;
@synthesize timeline=_timeline;
@synthesize vistaBotones=_vistaBotones;
@synthesize timelineDistancia=_timelineDistancia;
@synthesize bactividades=_bactividades;
@synthesize bformacion=_bformacion;
@synthesize bencuentros=_bencuentros;
@synthesize bmiagenda=_bmiagenda;
@synthesize bactividadesT=_bactividadesT;
@synthesize bformacionT=_bformacionT;
@synthesize bencuentrosT=_bencuentrosT;
@synthesize bmiagendaT=_bmiagendaT;

@synthesize vistaBotonesConceptos;
@synthesize btodos=_btodos;
@synthesize bpendientes=_bpendientes;
@synthesize bpagados=_bpagados;
@synthesize bcancelados=_bcancelados;
@synthesize btodosT=_btodosT;
@synthesize bpendientesT=_bpendientesT;
@synthesize bpagadosT=_bpagadosT;
@synthesize bcanceladosT=_bcanceladosT;

@synthesize bparroquias=_bparroquias;
@synthesize bparroquiasT=_bparroquiasT;
@synthesize bpadres=_bpadres;
@synthesize bpadresT=_bpadresT;

@synthesize vistaAccion=_vistaAccion;
@synthesize posicionVistaAccion=_posicionVistaAccion;
@synthesize vistaAccionTexto=_vistaAccionTexto;

@synthesize posicionVistaBotonesConceptos=_posicionVistaBotonesConceptos;

@synthesize botonAnteriorEncuentro=_botonAnteriorEncuentro;
@synthesize botonSiguienteEncuentro=_botonSiguienteEncuentro;

@synthesize marrXMLData;
@synthesize mstrXMLString;
@synthesize mdictXMLPart;

#import "color.h"
#import "globales.h"
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
 
    return self;
}

-(void)mostrarAvisoNoInternet
{
    self.timelineDistancia.constant=50;
    [self.timeline layoutIfNeeded];
    [self.timeline mostrarAviso:@"NoInternet"];
}



-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    
   
    if([senderValue isEqualToString:@"citaCalifica"])
    {
       
    }
    else if([senderValue isEqualToString:@"cancelarAsistencia"])
    {
        [self recargaContenido];
    }
    else if([senderValue isEqualToString:@"registroPaso1Cancelar"]){
        
        [self analytics:self.ventanaActual conAccion:@"registroPaso1Cancelar" conLabel:self.idreal];
    }
    else if([senderValue isEqualToString:@"registroPaso1"]){
        
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        NSDictionary *accion=[APIConnection getDictionaryJSON:response withKey:@"accion"];
        
        NSString *statusTempo = [APIConnection getStringJSON:accion withKey:@"status" widthDefValue:@""];
        NSString *idconcTempo = [APIConnection getStringJSON:accion withKey:@"idconc" widthDefValue:@""];
        idconcFinal = idconcTempo;
        NSString *nombreconcTempo = [APIConnection getStringJSON:accion withKey:@"nombreact" widthDefValue:@""];
        NSString *mensajeError = [APIConnection getStringJSON:accion withKey:@"mensajeError" widthDefValue:@""];
        
        float costoT = [APIConnection getFloatJSON:diccionarioAccion withKey:@"costo" widthDefValue:@""];
        
        if([statusTempo isEqualToString:@"OK"]){
            
            [self analytics:self.ventanaActual conAccion:@"registroPaso1" conLabel:self.idreal];
            // Create a PayPalPayment
            // Use the intent property to indicate that this is a "sale" payment,
            // meaning combined Authorization + Capture.
            // To perform Authorization only, and defer Capture to your server,
            // use PayPalPaymentIntentAuthorize.
            // To place an Order, and defer both Authorization and Capture to
            // your server, use PayPalPaymentIntentOrder.
            // (PayPalPaymentIntentOrder is valid only for PayPal payments, not credit card payments.)
         
        }
        else{
            [SVProgressHUD showErrorWithStatus:mensajeError];
        }
        //@"titulo"
    }
    else if([senderValue isEqualToString:@"validaPP"])
    {
        NSLog(@"%@",json);
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        
        NSString *statusTempo = [APIConnection getStringJSON:response withKey:@"status" widthDefValue:@""];
        NSString *message = [APIConnection getStringJSON:response withKey:@"message" widthDefValue:@""];
        NSString *telefono = [APIConnection getStringJSON:response withKey:@"telefono" widthDefValue:@""];
        NSString *idtransaction = [APIConnection getStringJSON:response withKey:@"idtransaction" widthDefValue:@""];
        [self analytics:self.ventanaActual conAccion:@"validaPP" conLabel:self.idreal];
        if([self.ventanaActual isEqualToString:@"conc"]){
            
            //[SVProgressHUD showSuccessWithStatus:message];
            if([statusTempo isEqualToString:@"ok"]){
                [self recargaContenido];
            }
            else{
                
                
         
                }
               
         
                
            }
        
        }
        else if([self.ventanaActual isEqualToString:@"forDetalle"])
        {
            
           
        }
    
    else if([senderValue isEqualToString:@"registroDirecto"]){
        
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        NSDictionary *accion=[APIConnection getDictionaryJSON:response withKey:@"accion"];
        NSString *mensajeError = [APIConnection getStringJSON:accion withKey:@"mensajeError" widthDefValue:@""];
        //[APIConnection connectAPI:[NSString stringWithFormat:@"actDetalle.php?idreal=%@&modo2=%@",self.idreal,self.ventanaActual2] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:YES onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
        if([mensajeError isEqualToString:@""]){
            [self analytics:self.ventanaActual conAccion:@"registroDirecto" conLabel:self.idreal];
            self.vistaAccionTexto.text=@"Asistencia confirmada (¿Cambiar?)";
            [diccionarioAccion removeObjectForKey:@"operacion"];
            [diccionarioAccion setObject:@"editarAsistentesExterno" forKey:@"operacion"];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            acompanantesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"acompanantes"];
            vc.idreal = self.idreal;
            [self analytics:self.ventanaActual conAccion:@"editarAsistencia" conLabel:self.idreal];
            [self.navigationController pushViewController:vc animated:true];
            
           // [self cargaAccionAccion:nil];
            
        }
        else{
            [diccionarioAccion removeObjectForKey:@"disponibles"];
            [diccionarioAccion setObject:[APIConnection getStringJSON:accion withKey:@"disponibles" widthDefValue:@""] forKey:@"disponibles"];
            
            [diccionarioAccion removeObjectForKey:@"puedoreservar"];
            [diccionarioAccion setObject:[APIConnection getStringJSON:accion withKey:@"puedoreservar" widthDefValue:@""] forKey:@"puedoreservar"];
            [SVProgressHUD showErrorWithStatus:mensajeError];
        }
    }
    else if([senderValue isEqualToString:@"actDispobilidad"]){
        [self analytics:self.ventanaActual conAccion:@"actDispobilidad" conLabel:self.idreal];
        
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        int disponibles = [APIConnection getIntJSON:response withKey:@"disponibles" widthDefValue:@"0"];
        if(disponibles>=acompananTempo+1){
            float costoT = [APIConnection getFloatJSON:diccionarioAccion withKey:@"costo" widthDefValue:@""];
            //NSLog(@"diccionarioAccion %@",diccionarioAccion);
            [SVProgressHUD dismiss];
            
            if(costoT>0){
                //NSLog(@"aqui se llama");
                [APIConnection connectAPI:[NSString stringWithFormat:@"actDetalle.php?idreal=%@&modo=registroPaso1&cuantos=%d&",self.idreal,acompananTempo+1] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:YES onErrorReturn:false withSender:@"registroPaso1" willContinueLoading:false];
            }
            else{
                [APIConnection connectAPI:[NSString stringWithFormat:@"actDetalle.php?idreal=%@&modo=registroDirecto&cuantos=%d",self.idreal,acompananTempo+1] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:YES onErrorReturn:false withSender:@"registroDirecto" willContinueLoading:true];
                
            }
        }
        else
        {
            if(disponibles==0) [SVProgressHUD showErrorWithStatus:@"Lo sentimos, no hay lugares para esta actividad"];
            else if(disponibles == 1) [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Lo sentimos sólo contamos con %d lugar para esta actividad",disponibles]];
            else [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"Lo sentimos sólo contamos con %d lugares para esta actividad",disponibles]];
        
        }
        
    }
    
    else{
       // NSLog(@"senderValue %@",senderValue);
        //NSLog(@"%@",json);
        [refreshControl endRefreshing];
        jsonOriginal=[NSDictionary dictionaryWithDictionary:json];
       
        
        NSMutableArray *indiceTemporal=[[NSMutableArray alloc] init];
        //[self.timeline.contenedor.infiniteScrollingView stopAnimating];
        [self.timeline.contenedor.infiniteScrollingView stopAnimating];
        
        
        if([senderValue isEqualToString:@"enceStatus"])
        {
            NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
            
            diccionarioAccion=[NSMutableDictionary dictionaryWithDictionary:[APIConnection getDictionaryJSON:response withKey:@"accion"]];
            
            if(diccionarioAccion)
                [self cargaAccion];
        }
        else if(![senderValue isEqualToString:@"vimeo"])
        {
            if([self.ventanaActual isEqualToString:@"citaDetalle"] || [self.ventanaActual isEqualToString:@"sede"] || [self.ventanaActual isEqualToString:@"mis"] || [self.ventanaActual isEqualToString:@"apo"] || [self.ventanaActual isEqualToString:@"dapo"] || [self.ventanaActual isEqualToString:@"detalleMat"] || [self.ventanaActual isEqualToString:@"act"] || [self.ventanaActual isEqualToString:@"for"] || [self.ventanaActual isEqualToString:@"enc"] || [self.ventanaActual isEqualToString:@"par"] || [self.ventanaActual isEqualToString:@"pad"] || [self.ventanaActual isEqualToString:@"ref"] || [self.ventanaActual isEqualToString:@"home"] || [self.ventanaActual isEqualToString:@"noti"] || [self.ventanaActual isEqualToString:@"pag"] || [self.ventanaActual isEqualToString:@"conc"]  || [self.ventanaActual isEqualToString:@"ReflexionDelDia"]  || [self.ventanaActual isEqualToString:@"ultimoEncuentro"] || [self.ventanaActual isEqualToString:@"catpdf"]  || [self.ventanaActual isEqualToString:@"mia"] || [self.ventanaActual rangeOfString:@"Detalle"].location != NSNotFound)//ReflexionDelDia
            {
                NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
                
                
                if([self.ventanaActual isEqualToString:@"home"])
                {
                    urlRC=[APIConnection getStringJSON:response withKey:@"urlRC" widthDefValue:@""];
                }
                    
                
                
                BOOL abrirPerfil=[APIConnection getBOOLJSON:response withKey:@"abrirPerfil" widthDefValue:false];
                if(abrirPerfil)
                {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                    perfilViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"perfil"];
                    
                    [self presentViewController:vc animated:true completion:^{
                        
                        
                    }];
                }
                NSDictionary *datos=[APIConnection getDictionaryJSON:response withKey:@"datos"];
                diccionarioCalendario=[APIConnection getDictionaryJSON:response withKey:@"calendario"];
                NSString *titulo=[APIConnection getStringJSON:datos withKey:@"titulo" widthDefValue:@""];
                if(![titulo isEqualToString:@""])
                    self.headerPrincipal.titulo.text=titulo;
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
                        if([self.ventanaActual isEqualToString:@"enc"])
                            [self abreFirma];
                        else
                            [self.navigationController popToRootViewControllerAnimated:true];
                    }
                }
                
                if(pagina==1)
                {
                    diccionarioAccion=[NSMutableDictionary dictionaryWithDictionary:[APIConnection getDictionaryJSON:response withKey:@"accion"]];
                    
                    if(diccionarioAccion)
                        [self cargaAccion];
                }
                //[self cargaAudio:[APIConnection getStringJSON:response withKey:@"audio" widthDefValue:@""]];
                
                indiceTemporal=[APIConnection getArrayJSON:response withKey:@"indice"];
                [indice removeAllObjects];
                [indiceTipos removeAllObjects];
                for(NSDictionary *elemento in indiceTemporal)
                {
                    [indice addObject:elemento];
                    [indiceTipos addObject:[APIConnection getStringJSON:elemento withKey:@"tipotimeline" widthDefValue:@""]];
                }
                
                [indice addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"generalSeparador",@"tipotimeline",@"100",@"altura", nil]];
                [indiceTipos addObject:@"generalSeparador"];
                [indice addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"generalSeparador",@"tipotimeline",@"100",@"altura", nil]];
                [indiceTipos addObject:@"generalSeparador"];
                [indice addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"generalSeparador",@"tipotimeline",@"100",@"altura", nil]];
                [indiceTipos addObject:@"generalSeparador"];
                [indice addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"generalSeparador",@"tipotimeline",@"100",@"altura", nil]];
                [indiceTipos addObject:@"generalSeparador"];
                
                [self.timeline acomoda:indice conTipos:indiceTipos conPagina:pagina conSeparador:false conVentana:@"" conAudios:[APIConnection getIntJSON:response withKey:@"totalAudios" widthDefValue:@"1"]];
                
                [self animarRegreso];
                
                if(cargarInfinite)
                {
                    if([indiceTemporal count]>0)
                        self.timeline.contenedor.showsInfiniteScrolling=true;
                    else self.timeline.contenedor.showsInfiniteScrolling=false;
                }
            }
        }
    }
     [super APIresponse:json :errorValue :senderValue];
}

- (void)viewDidLoad
{
    [self.view setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    self.eventStore = [[EKEventStore alloc] init];
    
    idconcFinal=0;
    botonGuia = 0;
    //Ocultamos errores por contraints
    //NSLog(@"%@ %@",self.ventanaActual,self.ventanaActual2);
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    [super viewDidLoad];
    self.headerPrincipal.delegate=self;
    self.timeline.delegate=self;
    self.timelineDistancia.constant=700;
    [self.view setNeedsLayout];
    
    [self.botonAnteriorEncuentro setHidden:true];
    [self.botonSiguienteEncuentro setHidden:true];
    
    diccionarioAccion = [[NSMutableDictionary alloc] init];
    
    tituloPrincipal=@"VITA";
    BOOL botonBack=true;
    NSString *subtitulo=@"Regresar",*tipoBotonHome=@"home";
    [self pintaTitulo];
    
    if([self.ventanaActual isEqualToString:@"home"])
    {
        botonBack=false;
        subtitulo=@"";
        tipoBotonHome=@"";
       
    }
    else if([self.ventanaActual isEqualToString:@"conc"])
    {
        if([self.ventanaActual2 isEqualToString:@"ence"]) // viene de un encuentro
        {
            tituloPrincipal=@"Aportaciones de Miembros";
            botonBack=false;
            subtitulo=@"";
            tipoBotonHome=@"";
            self.posicionVistaBotonesConceptos.constant=-31;
            [self.vistaBotonesConceptos layoutIfNeeded];
            
            [self.botonAnteriorEncuentro setHidden:false];
            [self.botonSiguienteEncuentro setHidden:false];
        }
        else tituloPrincipal=@"Estado de cuenta";
    }
    //ReflexionDelDia
    [self.headerPrincipal inicializa:tituloPrincipal conSubtitulo:subtitulo conBotonBack:botonBack conBuscador:false conTipoBotonHome:tipoBotonHome];
    
    if(![self.ventanaActual isEqualToString:@"rss"])
    {
        refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(recargaContenido)
                 forControlEvents:UIControlEventValueChanged];
        [self.timeline.contenedor addSubview:refreshControl];
    }
    
    
    pagina=1;
    cargarInfinite=false;
    if(![self.ventanaActual isEqualToString:@"rss"] && ![self.ventanaActual isEqualToString:@"sede"] && ![self.ventanaActual isEqualToString:@"citaDetalle"] && ![self.ventanaActual isEqualToString:@"apo"] && ![self.ventanaActual isEqualToString:@"dapo"] && ![self.ventanaActual isEqualToString:@"ReflexionDelDia"] && ![self.ventanaActual isEqualToString:@"ultimoEncuentro"] && ![self.ventanaActual isEqualToString:@"detalleMat"] && ![self.ventanaActual isEqualToString:@"home"]  && ![self.ventanaActual isEqualToString:@"pagDetalle"]  && ![self.ventanaActual isEqualToString:@"mia"] && ![self.ventanaActual isEqualToString:@"catpdf"] && [self.ventanaActual rangeOfString:@"Detalle"].location == NSNotFound)
    {
        cargarInfinite=true;
    }
    if(cargarInfinite)
    {
        [self.timeline.contenedor addInfiniteScrollingWithActionHandler:^{
            pagina++;
            [self cargaContenido];
        }];
    }
    
    [self.timeline layoutIfNeeded];
    
    [self.timeline setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
    
    [self.bactividadesT setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.bformacionT setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.bencuentrosT setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.bmiagendaT setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.bparroquiasT setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.bpadresT setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.btodosT setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.bpendientesT setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.bpagadosT setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    [self.bcanceladosT setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
    
    if([self.ventanaActual isEqualToString:@"rss"])
    {
        [SVProgressHUD showWithStatus:@"Cargando"];
    }
    posicionTimeline=50;
    if([self.ventanaActual isEqualToString:@"citaDetalle"] || [self.ventanaActual isEqualToString:@"sede"] || [self.ventanaActual isEqualToString:@"apo"] || [self.ventanaActual isEqualToString:@"dapo"] || [self.ventanaActual isEqualToString:@"rss"])
        posicionTimeline=80;
    else if([self.ventanaActual isEqualToString:@"mis"])
        posicionTimeline=80;
    else if([self.ventanaActual isEqualToString:@"act"] || [self.ventanaActual isEqualToString:@"for"] || [self.ventanaActual isEqualToString:@"enc"] || [self.ventanaActual isEqualToString:@"par"] || [self.ventanaActual isEqualToString:@"pad"] || [self.ventanaActual isEqualToString:@"mia"])
        posicionTimeline=115;
    else if([self.ventanaActual isEqualToString:@"home"])
        posicionTimeline=80;
    else if([self.ventanaActual isEqualToString:@"conc"] || [self.ventanaActual isEqualToString:@"detalleMat"])
    {
        if([self.ventanaActual2 isEqualToString:@"ence"])
            posicionTimeline=85;
        else if([self.ventanaActual isEqualToString:@"detalleMat"])
            posicionTimeline=80;
        else
            posicionTimeline=115;
    }
       
    else if([self.ventanaActual isEqualToString:@"ref"] || [self.ventanaActual isEqualToString:@"noti"] || [self.ventanaActual isEqualToString:@"pagDetalle"]  || [self.ventanaActual isEqualToString:@"pag"]  || [self.ventanaActual isEqualToString:@"catpdf"]  || [self.ventanaActual isEqualToString:@"ultimoEncuentro"]  || [self.ventanaActual isEqualToString:@"ReflexionDelDia"]  || [self.ventanaActual rangeOfString:@"Detalle"].location != NSNotFound)
        posicionTimeline=80;
    primeraVez=true;
    [self abreCosas:self.ventanaActual conStatus:@""];
    
    // es detalle de actividad o es detalle de formacion
    if([self.ventanaActual isEqualToString:@"actDetalle"] || [self.ventanaActual isEqualToString:@"forDetalle"] || [self.ventanaActual isEqualToString:@"catDetalle"])
    {

        enCalendario=[self leeCalendario:self.ventanaActual conidregistrocal:self.idreal conidusuariocal:uid];
        [self.headerPrincipal.botonCalendario setHidden:false];
        if([enCalendario isEqualToString:@""])
            [self.headerPrincipal.botonCalendario setImage:[UIImage imageNamed:@"encuentroCalendario0"] forState:UIControlStateNormal];
        else
            [self.headerPrincipal.botonCalendario setImage:[UIImage imageNamed:@"encuentroCalendario1"] forState:UIControlStateNormal];
        self.headerPrincipal.derechaTitulo.constant=100;
        [self.headerPrincipal layoutIfNeeded];
    }
    else
    {
        self.headerPrincipal.derechaTitulo.constant=50;
        [self.headerPrincipal layoutIfNeeded];
        [self.headerPrincipal.botonCalendario setHidden:true];
    }
    
    

     // Do any additional setup after loading the view.
}

-(void)pintaTitulo
{
    if([self.ventanaActual isEqualToString:@"act"] || [self.ventanaActual isEqualToString:@"actDetalle"]) tituloPrincipal=@"Actividades";
    else if([self.ventanaActual isEqualToString:@"detalleMat"]) tituloPrincipal=@"Material de actividades";
    else if([self.ventanaActual isEqualToString:@"for"] || [self.ventanaActual isEqualToString:@"forDetalle"]) tituloPrincipal=@"Formación";
    else if([self.ventanaActual isEqualToString:@"enc"] || [self.ventanaActual isEqualToString:@"encDetalle"]) tituloPrincipal=@"Encuentros semanales";
    else if([self.ventanaActual isEqualToString:@"par"] || [self.ventanaActual isEqualToString:@"parDetalle"]) tituloPrincipal=@"Parroquias";
    else if([self.ventanaActual isEqualToString:@"pad"] || [self.ventanaActual isEqualToString:@"padDetalle"]) tituloPrincipal=@"Padres";
    else if([self.ventanaActual isEqualToString:@"noti"] || [self.ventanaActual isEqualToString:@"notiDetalle"]) tituloPrincipal=@"Noticias";
    else if([self.ventanaActual isEqualToString:@"citaDetalle"]) tituloPrincipal=@"Citas";
    else if([self.ventanaActual isEqualToString:@"catpdf"] || [self.ventanaActual isEqualToString:@"catpdfDetalle"]) tituloPrincipal=@"Biblioteca";
    else if([self.ventanaActual isEqualToString:@"mia"]) tituloPrincipal=@"Mi Agenda";
    else if([self.ventanaActual isEqualToString:@"ref"] || [self.ventanaActual isEqualToString:@"refDetalle"]) tituloPrincipal=@"Reflexiones";
    else if([self.ventanaActual isEqualToString:@"conc"])
    {
        if([self.ventanaActual2 isEqualToString:@"ence"]) // viene de un encuentro
            tituloPrincipal=@"Aportaciones de Miembros";
        else tituloPrincipal=@"Estado de cuenta";
    }
    else if([self.ventanaActual isEqualToString:@"pag"]) tituloPrincipal=@"Mis pagos";
    else if([self.ventanaActual isEqualToString:@"sede"]) tituloPrincipal=@"Sedes";
    else if([self.ventanaActual isEqualToString:@"pagDetalle"]) tituloPrincipal=@"Detalle de pago";
    else if([self.ventanaActual isEqualToString:@"home"]) tituloPrincipal=@"VITA";
    else if([self.ventanaActual isEqualToString:@"ReflexionDelDia"]) tituloPrincipal=@"Reflexión del día";
    else if([self.ventanaActual isEqualToString:@"ultimoEncuentro"]) tituloPrincipal=@"Encuentro semanal";
    else if([self.ventanaActual isEqualToString:@"apo"]) tituloPrincipal=@"Catálogo de Apostolados";
    else if([self.ventanaActual isEqualToString:@"dapo"]) tituloPrincipal=@"Apostolados";
    else if([self.ventanaActual isEqualToString:@"mis"]) tituloPrincipal=@"Misal";
    //ReflexionDelDia
    
    self.headerPrincipal.titulo.text=tituloPrincipal;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
{
    if ([elementName isEqualToString:@"rss"]) {
        marrXMLData = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"item"]) {
        mdictXMLPart = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
    if (!mstrXMLString) {
        mstrXMLString = [[NSMutableString alloc] initWithString:string];
    }
    else {
        [mstrXMLString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
    if ([elementName isEqualToString:@"title"]
        || [elementName isEqualToString:@"pubDate"]
        || [elementName isEqualToString:@"link"]
        || [elementName isEqualToString:@"description"]) {
        [mdictXMLPart setObject:mstrXMLString forKey:elementName];
    }
    if ([elementName isEqualToString:@"item"]) {
        [marrXMLData addObject:mdictXMLPart];
    }
    mstrXMLString = nil;
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
     [SVProgressHUD dismiss];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    if([marrXMLData count]>0)
    {
        [indice removeAllObjects];
        [indiceTipos removeAllObjects];
        for(long i=0; i<=[marrXMLData count]-1; i++)
        {
            NSDictionary *elemento=[marrXMLData objectAtIndex:i];
            NSString *title=[APIConnection getStringJSON:elemento withKey:@"title" widthDefValue:@""];
            title=[title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            title=[title stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            
            NSString *pubDate=[APIConnection getStringJSON:elemento withKey:@"pubDate" widthDefValue:@""];
            pubDate=[pubDate stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            pubDate=[pubDate stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            
            NSString *link=[APIConnection getStringJSON:elemento withKey:@"link" widthDefValue:@""];
            link=[link stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            link=[link stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            
            NSString *description=[APIConnection getStringJSON:elemento withKey:@"description" widthDefValue:@""];
            description=[description stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            description=[description stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            
            NSString *url = nil;
            NSString *htmlString = description;
            NSScanner *theScanner = [NSScanner scannerWithString:htmlString];
            // find start of IMG tag
            [theScanner scanUpToString:@"<img" intoString:nil];
            if (![theScanner isAtEnd]) {
                [theScanner scanUpToString:@"src" intoString:nil];
                NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'"];
                [theScanner scanUpToCharactersFromSet:charset intoString:nil];
                [theScanner scanCharactersFromSet:charset intoString:nil];
                [theScanner scanUpToCharactersFromSet:charset intoString:&url];
                // "url" now contains the URL of the img
            }
            NSRange rangoMes = NSMakeRange(7,4);
            NSRange rangoDia = NSMakeRange(5,2);
            NSString *mes=[pubDate substringWithRange:rangoMes];
            NSString *dia=[pubDate substringWithRange:rangoDia];
            NSDictionary *elementoCreado=[NSDictionary dictionaryWithObjectsAndKeys:
                                          @"tituloImagen",@"tipotimeline",
                                          @"Somos RC",@"titulo",
                                          @"abrirURL",@"operacion",
                                          url,@"imagen",
                                          description,@"description",
                                          title,@"intro",
                                          [mes uppercaseString],@"mes",
                                          dia,@"dia",
                                          [APIConnection getStringJSON:elemento withKey:@"imagen" widthDefValue:@""],@"imagen",
                                          link,@"url",
                                          nil];
            [indice addObject:elementoCreado];
            [indiceTipos addObject:@"tituloImagen"];
            [self.timeline acomoda:indice conTipos:indiceTipos conPagina:1 conSeparador:false conVentana:@"" conAudios:0];
            [self animarRegreso];
        }
    }
    NSLog(@"%@",marrXMLData);
    [SVProgressHUD dismiss];
}

-(void)recargaContenido
{
    if([self.ventanaActual isEqualToString:@"rss"])
    {
        if([urlRC isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"Temporalmente fuera de servicio"];
            [self.navigationController popViewControllerAnimated:true];
        }
        else
        {
            NSXMLParser *xmlparser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:urlRC]];

            [xmlparser setDelegate:self];
            [xmlparser parse];
        }
        
        
    }
    else
    {
        [refreshControl endRefreshing];
        pagina=1;
        [self cargaContenido];
    }
   }

-(void)cargaContenido
{
    [self pintaTitulo];
    BOOL cargando=false;
    if(pagina==1) cargando=true;

    if([self.ventanaActual isEqualToString:@"act"] || [self.ventanaActual isEqualToString:@"for"] || [self.ventanaActual isEqualToString:@"enc"] || [self.ventanaActual isEqualToString:@"par"] || [self.ventanaActual isEqualToString:@"pad"] || [self.ventanaActual isEqualToString:@"ref"] || [self.ventanaActual isEqualToString:@"noti"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"act.php?modo=%@&numero_pagina=%ld",self.ventanaActual,pagina] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    else if([self.ventanaActual isEqualToString:@"sede"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"sede.php?modo=detalle&idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    else if([self.ventanaActual isEqualToString:@"citaDetalle"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"citas.php?modo=detalle&idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    
    else if([self.ventanaActual isEqualToString:@"conc"] || [self.ventanaActual isEqualToString:@"pag"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"pag.php?modo=%@&numero_pagina=%ld&statusconc=%@",self.ventanaActual,pagina,statusActual] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    else if([self.ventanaActual isEqualToString:@"pagDetalle"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"pag.php?modo=pagDetalle&idreal=%@",self.self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    else if([self.ventanaActual isEqualToString:@"home"])
        [APIConnection connectAPI:@"home.php?" withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    else if([self.ventanaActual isEqualToString:@"catpdf"])
        [APIConnection connectAPI:@"pdf.php?modo=categorias" withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    else if([self.ventanaActual isEqualToString:@"catpdfDetalle"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"pdf.php?modo=catpdf&icatpdf=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    else if([self.ventanaActual isEqualToString:@"ReflexionDelDia"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"refDetalle.php?modo=dia"] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    else if([self.ventanaActual isEqualToString:@"ultimoEncuentro"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"encDetalle.php?modo=ultimo"] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    else if([self.ventanaActual isEqualToString:@"mia"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"act.php?modo=agenda&numero_pagina=%ld",pagina] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    else if([self.ventanaActual rangeOfString:@"Detalle"].location != NSNotFound)
    {
        NSString *archivo=self.ventanaActual;
        if([archivo isEqualToString:@"forDetalle"])
            archivo=@"actDetalle";
        [APIConnection connectAPI:[NSString stringWithFormat:@"%@.php?idreal=%@&modo2=%@",archivo,self.idreal,self.ventanaActual2] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    }
    else if([self.ventanaActual isEqualToString:@"detalleMat"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"actDetalle.php?modo=detalleMat&idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    else if([self.ventanaActual isEqualToString:@"apo"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"act.php?modo=apo"] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    
    else if([self.ventanaActual isEqualToString:@"dapo"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"act.php?modo=dapo&idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    
    else if([self.ventanaActual isEqualToString:@"mis"])
        [APIConnection connectAPI:[NSString stringWithFormat:@"act.php?modo=mis&numero_pagina=%ld",pagina] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:cargando onErrorReturn:false withSender:self.ventanaActual willContinueLoading:false];
    

    [self analytics:self.ventanaActual conAccion:@"abre" conLabel:self.idreal];
}



-(void)animarRegreso
{
    
    self.timelineDistancia.constant=posicionTimeline;
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

-(void)abreCosas:(NSString *)ventanaSiguiente conStatus:(NSString *)status
{
    if(![self.ventanaActual isEqualToString:ventanaSiguiente] || primeraVez || ![statusActual isEqualToString:statusence])
    {
        primeraVez=false;
        [self ocultarTodos];
        if([ventanaSiguiente isEqualToString:@"act"] || [ventanaSiguiente isEqualToString:@"for"] || [ventanaSiguiente isEqualToString:@"enc"] || [ventanaSiguiente isEqualToString:@"mia"])
        {
            if([ventanaSiguiente isEqualToString:@"act"])
            {
                [self.bactividades setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
                [self.bactividades setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0] forState:UIControlStateNormal];
                [self.bactividadesT setHidden:false];
            }
            else if([ventanaSiguiente isEqualToString:@"for"])
            {
                [self.bformacion setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
                [self.bformacion setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0] forState:UIControlStateNormal];
                [self.bformacionT setHidden:false];
            }
            else if([ventanaSiguiente isEqualToString:@"enc"])
            {
                [self.bencuentros setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
                [self.bencuentros setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0] forState:UIControlStateNormal];
                [self.bencuentrosT setHidden:false];
            }
            else if([ventanaSiguiente isEqualToString:@"mia"])
            {
                [self.bmiagenda setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
                [self.bmiagenda setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0] forState:UIControlStateNormal];
                [self.bmiagendaT setHidden:false];
            }
            [self.vistaBotones setHidden:false];
        }
        else if([ventanaSiguiente isEqualToString:@"par"] || [ventanaSiguiente isEqualToString:@"pad"])
        {
            if([ventanaSiguiente isEqualToString:@"par"])
            {
                [self.bparroquias setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
                [self.bparroquias setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0] forState:UIControlStateNormal];
                [self.bparroquiasT setHidden:false];
            }
            else if([ventanaSiguiente isEqualToString:@"pad"])
            {
                [self.bpadres setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
                [self.bpadres setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0] forState:UIControlStateNormal];
                [self.bpadresT setHidden:false];
            }
            [self.vistaBotones2 setHidden:false];
        }
        else if([ventanaSiguiente isEqualToString:@"conc"] || [ventanaSiguiente isEqualToString:@"conc1"] || [ventanaSiguiente isEqualToString:@"conc2"] || [ventanaSiguiente isEqualToString:@"conc0"])
        {
            if([status isEqualToString:@""])
            {
                [self.btodos setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
                [self.btodos setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0] forState:UIControlStateNormal];
                [self.btodosT setHidden:false];
            }
            else if([status isEqualToString:@"0"])
            {
                [self.bpendientes setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
                [self.bpendientes setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0] forState:UIControlStateNormal];
                [self.bpendientesT setHidden:false];
            }
            else if([status isEqualToString:@"1"])
            {
                [self.bpagados setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
                [self.bpagados setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0] forState:UIControlStateNormal];
                [self.bpagadosT setHidden:false];
            }
            else if([status isEqualToString:@"2"])
            {
                [self.bcancelados setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
                [self.bcancelados setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoSobreDestacado"] withAlpha:1.0] forState:UIControlStateNormal];
                [self.bcanceladosT setHidden:false];
            }
            [self.vistaBotonesConceptos setHidden:false];
        }

        self.timelineDistancia.constant=self.timeline.frame.size.height+100;
        [UIView animateWithDuration:0.5 animations:^{
            [self.timeline layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.ventanaActual=ventanaSiguiente;
            statusActual=status;
            [self recargaContenido];
        }];
        
    }
}

-(void)ocultarTodos
{
    [self.vistaBotones setHidden:true];
    [self.vistaBotones2 setHidden:true];
    [self.vistaBotonesConceptos setHidden:true];
    [self.bactividadesT setHidden:true];
    [self.bformacionT setHidden:true];
    [self.bencuentrosT setHidden:true];
    [self.bmiagendaT setHidden:true];
    [self.bparroquiasT setHidden:true];
    [self.bpadresT setHidden:true];
    [self.btodosT setHidden:true];
    [self.bpendientesT setHidden:true];
    [self.bpagadosT setHidden:true];
    [self.bcanceladosT setHidden:true];
    
    [self.bactividades setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorGris"] withAlpha:1.0]];
    [self.bactividades setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoGris"] withAlpha:1.0] forState:UIControlStateNormal];
    
    [self.bformacion setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorGris"] withAlpha:1.0]];
    [self.bformacion setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoGris"] withAlpha:1.0] forState:UIControlStateNormal];
    
    [self.bencuentros setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorGris"] withAlpha:1.0]];
    [self.bencuentros setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoGris"] withAlpha:1.0] forState:UIControlStateNormal];
    
    [self.bmiagenda setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorGris"] withAlpha:1.0]];
    [self.bmiagenda setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoGris"] withAlpha:1.0] forState:UIControlStateNormal];
    
    [self.bparroquias setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorGris"] withAlpha:1.0]];
    [self.bparroquias setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoGris"] withAlpha:1.0] forState:UIControlStateNormal];
    
    [self.bpadres setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorGris"] withAlpha:1.0]];
    [self.bpadres setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoGris"] withAlpha:1.0] forState:UIControlStateNormal];
    
    [self.btodos setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorGris"] withAlpha:1.0]];
    [self.btodos setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoGris"] withAlpha:1.0] forState:UIControlStateNormal];
    
    [self.bpendientes setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorGris"] withAlpha:1.0]];
    [self.bpendientes setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoGris"] withAlpha:1.0] forState:UIControlStateNormal];
    
    [self.bpagados setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorGris"] withAlpha:1.0]];
    [self.bpagados setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoGris"] withAlpha:1.0] forState:UIControlStateNormal];
    
    [self.bcancelados setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorGris"] withAlpha:1.0]];
    [self.bcancelados setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorTextoGris"] withAlpha:1.0] forState:UIControlStateNormal];

}

- (IBAction)abreActividades:(id)sender {
    pagina=1;
    [self abreCosas:@"act" conStatus:@""];
}
- (IBAction)abreFormacion:(id)sender {
    pagina=1;
    [self abreCosas:@"for" conStatus:@""];
}
- (IBAction)abreEncuentros:(id)sender {
    pagina=1;
    [self abreCosas:@"enc" conStatus:@""];
}
- (IBAction)abreMiAgenda:(id)sender {
    pagina=1;
    [self abreCosas:@"mia" conStatus:@""];
}
- (IBAction)abreParroquias:(id)sender {
    pagina=1;
    [self abreCosas:@"par" conStatus:@""];
}
- (IBAction)abrePadres:(id)sender {
    pagina=1;
    [self abreCosas:@"pad" conStatus:@""];
}

- (IBAction)pagosTodos:(id)sender {
    [self abreCosas:self.ventanaActual conStatus:@""];
}
- (IBAction)pagosPendientes:(id)sender {
    [self abreCosas:self.ventanaActual conStatus:@"0"];
}
- (IBAction)pagosPagados:(id)sender {
    [self abreCosas:self.ventanaActual conStatus:@"1"];
}
- (IBAction)pagosCancelados:(id)sender {
    [self abreCosas:self.ventanaActual conStatus:@"2"];
}



-(void)detieneAudio:(BOOL)cerrar
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if(appDelegate.movieplayer)
    {
        [appDelegate.movieplayer pause];
        if(cerrar)
        {
            [appDelegate limpiaAudio];
        }
           
    
    }
}

-(void)onTick:(NSTimer *)timer {
    [timerX invalidate];
    timerX=NULL;
    [APIConnection connectAPI:[NSString stringWithFormat:@"enceStatus.php?idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:false onErrorReturn:false withSender:@"enceStatus" willContinueLoading:false];
    
    //do smth
}

-(void)cargaAccion
{
    NSString *titulo=[APIConnection getStringJSON:diccionarioAccion withKey:@"titulo" widthDefValue:@""];
    BOOL pintarBoton=true;
    if([self.ventanaActual isEqualToString:@"encDetalle"])  // es un encuentro
    {
        statusence=[APIConnection getStringJSON:diccionarioAccion withKey:@"statusence" widthDefValue:@""];
        if([statusence isEqualToString:@"NE"]) // no iniciado, prendemos el timer
        {
            timerX = [NSTimer scheduledTimerWithTimeInterval: 5.0
                                                     target: self
                                                   selector:@selector(onTick:)
                                                   userInfo: nil repeats:NO];
            pintarBoton=false;
        }
    }
    
    
    if(![titulo isEqualToString:@""] && pintarBoton)
    {
        self.vistaAccionTexto.text=titulo;
        if([titulo isEqualToString:@"Asistencia confirmada"])
            [self.vistaAccion setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
        self.posicionVistaAccion.constant=0;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setNeedsLayout];
        }];
        
        
    }
    else
    {
        self.posicionVistaAccion.constant=-80;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view setNeedsLayout];
        }];
        
    }
}

- (IBAction)cargaAccionAccion:(id)sender
{
    [timerX invalidate];
    timerX=NULL;
    NSString *operacion=[APIConnection getStringJSON:diccionarioAccion withKey:@"operacion" widthDefValue:@""];
    NSString *idreal=[APIConnection getStringJSON:diccionarioAccion withKey:@"idreal" widthDefValue:@""];
    NSLog(@"TEMPO %@",diccionarioAccion);
    
    if([operacion isEqualToString:@"encuentro"])
    {
        stringToPass=@"";
        NSString *operadorEncuentro=[APIConnection getStringJSON:diccionarioAccion withKey:@"operadorEncuentro" widthDefValue:@""];
        NSString *statusenceInterno=[APIConnection getStringJSON:diccionarioAccion withKey:@"statusence" widthDefValue:@""];
        if([tokenManager isEqualToString:@"1"])
        {
            NSLog(@"Responsable");
            if([statusenceInterno isEqualToString:@"TE"])
            {
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Opciones"
                                              message:@"El encuentro está terminado. ¿Qué deseas hacer?"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"Ver encuentro"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [self abreVentana:@"encuentro" conDiccionario:diccionarioAccion conIDreal:idreal];
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                UIAlertAction* cancel = [UIAlertAction
                                         actionWithTitle:@"Actualizar encuentro"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             stringToPass=@"iniciarEncuentro";
                                             [self abreVentana:@"encuentro" conDiccionario:diccionarioAccion conIDreal:idreal];
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                UIAlertAction* cancelar = [UIAlertAction
                                           actionWithTitle:@"Cancelar"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction * action)
                                           {
                                               
                                               [alert dismissViewControllerAnimated:YES completion:nil];
                                               
                                           }];

                
                
                [alert addAction:ok];
                [alert addAction:cancel];
                [alert addAction:cancelar];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else if(![operadorEncuentro isEqualToString:@"0"]) // ya tiene operador
            {
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Opciones"
                                              message:@"El encuentro ya tiene Moderador."
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"Quiero ser Moderador"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         
                                         stringToPass=@"iniciarEncuentroModerador";
                                         NSLog(@"hola %@",stringToPass);
                                         [self abreVentana:@"encuentro" conDiccionario:diccionarioAccion conIDreal:idreal];
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                UIAlertAction* cancel = [UIAlertAction
                                         actionWithTitle:@"Seguir como miembro"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             
                                             [self abreVentana:@"encuentro" conDiccionario:diccionarioAccion conIDreal:idreal];
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                
                UIAlertAction* cancelar = [UIAlertAction
                                         actionWithTitle:@"Cancelar"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];

                
                [alert addAction:ok];
                [alert addAction:cancel];
                [alert addAction:cancelar];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
            else
                [self abreVentana:@"encuentro" conDiccionario:diccionarioAccion conIDreal:idreal];
        }
        else
        {
            NSLog(@"operador %@",operadorEncuentro);
            if([statusenceInterno isEqualToString:@"TE"]) // ya termino, solo se abre
                [self abreVentana:@"encuentro" conDiccionario:diccionarioAccion conIDreal:idreal];
            else
            {
                

                if([operadorEncuentro isEqualToString:@"0"])
                {
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Opciones"
                                                  message:@"El encuentro no tiene Moderador."
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"Quiero ser Moderador"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             stringToPass=@"iniciarEncuentroModerador";
                                             [self abreVentana:@"encuentro" conDiccionario:diccionarioAccion conIDreal:idreal];
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                    UIAlertAction* cancel = [UIAlertAction
                                             actionWithTitle:@"Seguir como miembro"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 
                                                 [self abreVentana:@"encuentro" conDiccionario:diccionarioAccion conIDreal:idreal];
                                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                                 
                                             }];
                    UIAlertAction* cancelar = [UIAlertAction
                                               actionWithTitle:@"Cancelar"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                                               {
                                                   
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                                   
                                               }];
                    [alert addAction:ok];
                    [alert addAction:cancel];
                    [alert addAction:cancelar];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else
                    [self abreVentana:@"encuentro" conDiccionario:diccionarioAccion conIDreal:idreal];
            }
        }
    }
    else if([operacion isEqualToString:@"llamar"])
    {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"¿Deseas llamar?"
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSString *tel1=[APIConnection getStringJSON:diccionarioAccion withKey:@"tel1" widthDefValue:@""];
        NSString *tel2=[APIConnection getStringJSON:diccionarioAccion withKey:@"tel2" widthDefValue:@""];
        if(![tel1 isEqualToString:@""])
        {
            UIAlertAction* tel1Alert = [UIAlertAction
                                 actionWithTitle:tel1
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:tel1]]];
                                 }];
            [view addAction:tel1Alert];
        }
        if(![tel2 isEqualToString:@""])
        {
            UIAlertAction* tel2Alert = [UIAlertAction
                                        actionWithTitle:tel1
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:tel2]]];
                                        }];
            [view addAction:tel2Alert];
        }
        
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancelar"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];

        [view addAction:cancel];
        [self presentViewController:view animated:YES completion:nil];
        
    }
   
    else if([operacion isEqualToString:@"registro"])
    {
        int acompanantes=[APIConnection getIntJSON:diccionarioAccion withKey:@"puedoreservar" widthDefValue:@""]-1;
        
        if(acompanantes>0){
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Número de invitados"
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                       destructiveButtonTitle:nil
                                                            otherButtonTitles:nil];
            int i=0;
            NSString *textoInvitados;
            for (i=0;i<=acompanantes;i++) {
                if(i==0) textoInvitados = @"Sin invitados";
                else if(i==1) textoInvitados = [NSString stringWithFormat:@"%d invitado",i];
                else textoInvitados = [NSString stringWithFormat:@"%d invitados",i];
                    [actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@",textoInvitados]];
                botonGuia=i;
            }
            
            actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancelar"];
            [actionSheet showInView:self.view];
        }
        else{
            
            acompananTempo = 0;
            [APIConnection connectAPI:[NSString stringWithFormat:@"actDispobilidad.php?idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"actDispobilidad" willContinueLoading:true];
            
        }
    }
    
    else if([operacion isEqualToString:@"editarAsistentesExterno"])
    {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Selecciona una opción"
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* botonEditar = [UIAlertAction
                                      actionWithTitle:@"Editar mi asistencia"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action)
                                      {
                                          UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                                          acompanantesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"acompanantes"];
                                          vc.idreal = self.idreal;
                                          [self analytics:self.ventanaActual conAccion:@"editarAsistencia" conLabel:self.idreal];
                                          [self.navigationController pushViewController:vc animated:true];
                                      }];
        [view addAction:botonEditar];
        
        UIAlertAction* botonCancelar = [UIAlertAction
                                        actionWithTitle:@"Cancelar mi asistencia"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [APIConnection connectAPI:[NSString stringWithFormat:@"actDetalle.php?idreal=%@&modo=cancelarAsistencia",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"cancelarAsistencia" willContinueLoading:false];
                                        }];
        [view addAction:botonCancelar];
        
        
        UIAlertAction* cerrar = [UIAlertAction
                                 actionWithTitle:@"Cerrar"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];
        
        [view addAction:cerrar];
        [self presentViewController:view animated:YES completion:nil];
    }
    else if([operacion isEqualToString:@"cancelarAsistencia"])
    {
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Selecciona una opción"
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* botonCancelar = [UIAlertAction
                                        actionWithTitle:@"Cancelar mi asistencia"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [APIConnection connectAPI:[NSString stringWithFormat:@"actDetalle.php?idreal=%@&modo=cancelarAsistencia",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"cancelarAsistencia" willContinueLoading:false];

                                        }];
        [view addAction:botonCancelar];
        
        
        UIAlertAction* cerrar = [UIAlertAction
                                 actionWithTitle:@"Cerrar"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     
                                 }];
        
        [view addAction:cerrar];
        [self presentViewController:view animated:YES completion:nil];
        
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"buttonIndex %ld",(long)buttonIndex);
    if(buttonIndex<=botonGuia){
        acompananTempo = buttonIndex;
        [APIConnection connectAPI:[NSString stringWithFormat:@"actDispobilidad.php?idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"actDispobilidad" willContinueLoading:true];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    if([stringToPass2 isEqualToString:@"recienFirmado"])
    {
        stringToPass2=@"";
        [self recargaContenido];
    }
    else if([stringToPass2 isEqualToString:@"enceStatus"])
    {
        stringToPass2=@"";
        [APIConnection connectAPI:[NSString stringWithFormat:@"enceStatus.php?idreal=%@",self.idreal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:false onErrorReturn:false withSender:@"enceStatus" willContinueLoading:false];
    }
    NSLog(@"%@ %@",self.colorFuenteLocal,colorFuenteGlobal);
    if(cambioFuenteAhora || self.multiplicadorFuenteActual!=multiplicadorFuente || ![self.colorFuenteLocal isEqualToString:colorFuenteGlobal])
    {
        self.multiplicadorFuenteActual=multiplicadorFuente;
        self.colorFuenteLocal=colorFuenteGlobal;
        cambioFuenteAhora=false;
        
        [self.headerPrincipal.fondo2Home setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondoTitulo"] withAlpha:1.0]];
        [self.headerPrincipal.fondo2Abajo setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondoTitulo"] withAlpha:1.0]];
        [self.headerPrincipal.fondo1 setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorDestacado"] withAlpha:1.0]];
        [self.headerPrincipal.fondo1Linea setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLinea"] withAlpha:1.0]];
        [self.headerPrincipal.fondo2Linea1 setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorLinea"] withAlpha:1.0]];
        
        [self.view setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"tablaFondoPrincipal"] withAlpha:1.0]];
  
        
        [self.timeline.contenedor reloadData];
    }
        [super viewDidAppear:true];

    // Start out working with the test environment! When you are ready, switch to PayPalEnvironmentProduction.
    //[PayPalMobile preconnectWithEnvironment:PayPalEnvironmentNoNetwork];
    //[PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
    
   
      
}


- (BOOL)shouldAutorotate {


    return YES;

}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)actualizaTotalPagar:(NSMutableArray *)arreglo conTotal:(float)total;
{
    if(total>0)
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat: total]];
        
        self.vistaAccionTexto.text=[NSString stringWithFormat:@"Pagar %@",numberAsString];
        pagarTotal=total;
        pagarArreglo=[[NSMutableArray alloc] init];
        pagarArreglo=[NSMutableArray arrayWithArray:arreglo];
    }
    else
    {
        self.vistaAccionTexto.text=[APIConnection getStringJSON:diccionarioAccion withKey:@"titulo" widthDefValue:@""];
    }
}
- (IBAction)siguienteence:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    encuentrosViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"encuentros"];
    vc.diccionario=self.diccionario;
    vc.idreal=[APIConnection getStringJSON:self.diccionario withKey:@"idreal" widthDefValue:@"0"];
    vc.pasoActual=9;
    
    [self.navigationController pushViewController:vc animated:true];
}
- (IBAction)anteriorEnce:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
-(void)analytics:(NSString*)category conAccion:(NSString*)accion conLabel:(NSString*)label{
    //NSLog(@"%@ / %@ / %@",category,accion,label);
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:accion
                                                           label:label
                                                           value:nil] build]];
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
                                 [self borrarCalendario:self.ventanaActual conidregistrocal:self.idreal conidusuariocal:uid];
                                 [self.headerPrincipal.botonCalendario setImage:[UIImage imageNamed:@"encuentroCalendario0"] forState:UIControlStateNormal];
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
    if([self.ventanaActual isEqualToString:@"actDetalle"] || [self.ventanaActual isEqualToString:@"forDetalle"] || [self.ventanaActual isEqualToString:@"catDetalle"])
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
                 [self guardaCalendario:self.ventanaActual conidregistrocal:self.idreal conidusuariocal:uid conidcalendariocal:enCalendario];
                 [self.headerPrincipal.botonCalendario setImage:[UIImage imageNamed:@"encuentroCalendario1"] forState:UIControlStateNormal];
                 [SVProgressHUD showSuccessWithStatus:@"Agregado al calendario"];
                 
             });
         }
     }];
}

-(void)calificaCita:(NSString *)idcita conCalificacion:(NSString *)calificacion
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Califica tu cita" message:@"Proporciona un comentario" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Comentario";
        textField.secureTextEntry =NO;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Guardar" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [APIConnection connectAPI:[NSString stringWithFormat:@"citaCalifica.php?idreal=%@&calificacion=%@&comentario=%@",idcita,calificacion,[[alertController textFields][0] text]] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"citaCalifica" willContinueLoading:false];

        
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)cita:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    actividadesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"actividades"];
    vc.diccionario=nil;
    vc.ventanaActual=@"citaDetalle";
    vc.idreal=@"1";
    [self.navigationController pushViewController:vc animated:true];
}

@end

