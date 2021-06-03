//
//  baseVentanaViewController.m
//  kiwilimontest
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 24/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "baseVentanaViewController.h"
#import "PureLayout.h"
#import "actividadesViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "encuentrosViewController.h"

#import "noticiasViewController.h"
#import "firmaViewController.h"
#import "noticiaDetalleViewController.h"
#import "vistawebViewController.h"
#import "mapaTimelineViewController.h"
#import "imagenViewController.h"
#import "perfilViewController.h"
#import "viedo2ViewController.h"
#import <sqlite3.h>
@interface baseVentanaViewController ()

@end

@implementation baseVentanaViewController
@synthesize ventanaActual=_ventanaActual;
@synthesize ventanaActual2=_ventanaActual2;
@synthesize idreal=_idreal;
@synthesize diccionario=_diccionario;
@synthesize subirTextoIntermedio=_subirTextoIntermedio;
@synthesize subirImagen1Intermedio=_subirImagen1Intermedio;
@synthesize subirImagen2Intermedio=_subirImagen2Intermedio;
@synthesize modoTimeline=_modoTimeline;
@synthesize cancelarTaps=_cancelarTaps;

#import "menuLateralHerramientas.h"
#import "popOverHerramientas.h"
#import "databaseOperations.h"
#import "color.h"
- (void)viewDidLoad {
    self.multiplicadorFuenteActual=multiplicadorFuente;
    self.colorFuenteLocal=colorFuenteGlobal;
    operacionPublicar=@"";
    APIConnection =[[iwantooAPIConnection alloc] init];
    APIConnection.delegationListener=self;
    porpagina=20;
    indice=[[NSMutableArray alloc] init];
    indiceTipos=[[NSMutableArray alloc] init];

    
    selectorAltura=40;
    selector2Altura=30;
    
    selectorSeleccionado=0;
    tituloPrincipal=@"";
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)abreFirma
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
    firmaViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"firma"];
    vc.delegate=self;
    [self presentViewController:vc animated:true completion:nil];
}

-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    if([senderValue isEqualToString:@"vimeo"])
    {
        NSMutableArray *files = [APIConnection getArrayJSON:json withKey:@"files"];
        NSString *link_hls=@"",*link_sd=@"";
        NSString *quality=@"";
        
        if([files count]>0)
        {
            for(NSDictionary *elemento in files)
            {
                quality=[APIConnection getStringJSON:elemento withKey:@"quality" widthDefValue:@""];
                if([quality isEqualToString:@"sd"])
                    link_sd=[APIConnection getStringJSON:elemento withKey:@"link_secure" widthDefValue:@""];
                else if([quality isEqualToString:@"hls"])
                    link_hls=[APIConnection getStringJSON:elemento withKey:@"link_secure" widthDefValue:@""];
            }
        }
        if(![link_hls isEqualToString:@""])
        {
            [self cargaVideo:link_hls];
        }
        else if(![link_sd isEqualToString:@""])
        {
            [self cargaVideo:link_sd];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"No pude abrirse el video"];
        }

    }
}

-(void)cargaVideo:(NSString *)urli
{
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL URLWithString:urli]];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    viedo2ViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"video2"];
   vc.player = player;
    [player play];
    
    [self presentViewController:vc animated:YES completion:nil];

    /*
    // create a player view controller
    AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
    controller.player = player;
    [player play];*/
}


-(void)viewDidAppear:(BOOL)animated
{
    if([proximaVentana isEqualToString:@"salirAfuera"])
    {
        proximaVentana=@"";
        [self.navigationController popToRootViewControllerAnimated:true];
    }
    else if([token isEqualToString:@""])
    {
        [self abreVentanaNavigation:@"entrar" conDiccionario:NULL];
    }
    else
        if([self.ventanaActual isEqualToString:@"home"])
        {
            if(![proximaVentana isEqualToString:@""])
            {
                [self abreVentanaNavigation:proximaVentana conDiccionario:proximoDiccionario];
                proximaVentana=@"";
            }
            else if(recienFirmado)
            {
                recienFirmado=false;
                [self performSelector:@selector(recargaContenido) withObject:NULL];
            }
        }
}


-(void)abreVentana:(NSString *)tipo conDiccionario:(NSDictionary *)diccionario conIDreal:(NSString *)idreal
{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"abreVentana"
                                                          action:tipo
                                                           label:idreal
                                                           value:nil] build]];
    
    NSString *esBoton=[APIConnection getStringJSON:diccionario withKey:@"esBoton" widthDefValue:@"si"];
    NSString *url=[APIConnection getStringJSON:diccionario withKey:@"url" widthDefValue:@""];

    if([tipo isEqualToString:@"sede"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        actividadesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"actividades"];
        vc.ventanaActual=@"sede";
        vc.idreal=idreal;
        [self.navigationController pushViewController:vc animated:true];
        
    }
    else if([esBoton isEqualToString:@"si"])
    {
        if(![self.ventanaActual isEqualToString:@"pagDetalle"] && ([tipo isEqualToString:@"pag"] || [tipo isEqualToString:@"conc"]))
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            actividadesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"actividades"];
            vc.ventanaActual=@"pagDetalle";
            //vc.ventanaActual2=;
            vc.idreal=idreal;
            [self.navigationController pushViewController:vc animated:true];
        }
        else if([tipo isEqualToString:@"noticias"])
        {
            NSString *htmlnoti=[APIConnection getStringJSON:diccionario withKey:@"htmlnoti" widthDefValue:@"0"];
            NSString *url2=[APIConnection getStringJSON:diccionario withKey:@"urlnoti" widthDefValue:@"0"];
            if([htmlnoti isEqualToString:@"2"] && ![url2 isEqualToString:@""])
            {
                [self abreURLDirecta:url2 conModo:@"web" conOperacion:@"" conIdreal:@""];
            }
            
            else
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
                vistawebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"vistaweb"];
                vc.modo=@"noticiaHtmlPuro";
                vc.url=[APIConnection getStringJSON:diccionario withKey:@"idreal" widthDefValue:@"0"];
                [self presentViewController:vc animated:true completion:nil];
            }
            
            
            /**/
        }
       
        else if([tipo isEqualToString:@"generalFoto"])
        {
            if([diccionario objectForKey:@"idvideo"])
            {
                [APIConnection connectAPI:[NSString stringWithFormat:@"https://api.vimeo.com/videos/%@",[APIConnection getStringJSON:diccionario withKey:@"idvideo" widthDefValue:@""]] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"vimeo" willContinueLoading:false];

                
                
            }
            else
            {
                NSString *imagen=[APIConnection getStringJSON:diccionario withKey:@"imagen" widthDefValue:@""];
                
                if([diccionario objectForKey:@"archivofoto"])
                    imagen=[APIConnection getStringJSON:diccionario withKey:@"archivofoto" widthDefValue:@""];

                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                imagenViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"imagen"];
                vc.archivo=imagen;
                [self presentViewController:vc animated:true completion:nil];
            }
            
        }
        else if([tipo isEqualToString:@"cat"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            encuentrosViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"encuentros"];
            vc.diccionario=[NSMutableDictionary dictionaryWithDictionary:diccionario];
            vc.idreal=[APIConnection getStringJSON:diccionario withKey:@"idcat" widthDefValue:@"0"];
            vc.pasoActual=-1;
            [self.navigationController pushViewController:vc animated:TRUE];
        }
        else if([tipo isEqualToString:@"texto"])
        {
//            NSString *tipotimeline=[APIConnection getStringJSON:diccionario withKey:@"tipotimeline" widthDefValue:@""];
            
            
        }
        
        else if([tipo isEqualToString:@"publicidad"])
        {
            NSString *urlpub=[APIConnection getStringJSON:diccionario withKey:@"urlpub" widthDefValue:@""];
            if(![urlpub isEqualToString:@""])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
                vistawebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"vistaweb"];
                vc.modo=@"url";
                vc.url=urlpub;
                [self presentViewController:vc animated:true completion:nil];
            }
        }
        else if([tipo isEqualToString:@"encuentro"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            encuentrosViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"encuentros"];
            vc.diccionario=[NSMutableDictionary dictionaryWithDictionary:diccionario];
            vc.idreal=[APIConnection getStringJSON:diccionario withKey:@"idreal" widthDefValue:@"0"];
            vc.pasoActual=0; //04
            
            navigationViewController *navigationController = [[navigationViewController alloc] initWithRootViewController:vc];
            [navigationController setNavigationBarHidden:YES animated:YES];
            
            [self detieneAudio:FALSE];
            [self presentViewController:navigationController animated:true completion:^{ }];
        }
        else if([tipo isEqualToString:@"tituloImagen"] && ![url isEqualToString:@""])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
            vistawebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"vistaweb"];
            vc.modo=@"texto";
            vc.url=url;
            vc.textoHTML=[APIConnection getStringJSON:diccionario withKey:@"description" widthDefValue:@""];
            [self presentViewController:vc animated:true completion:nil];
            
        }
        else if([tipo isEqualToString:@"boton"])
        {
            NSString *tipoBoton=[APIConnection getStringJSON:diccionario withKey:@"tipoBoton" widthDefValue:@""];
            if([tipoBoton isEqualToString:@"detalleMat"])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                actividadesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"actividades"];
                vc.ventanaActual=@"detalleMat";
                //vc.ventanaActual2=;
                vc.idreal=idreal;
                [self.navigationController pushViewController:vc animated:true];
            }
            else if([tipoBoton isEqualToString:@"dapo"])
            {
                NSLog(@"%@ %@",tipoBoton,idreal);
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                actividadesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"actividades"];
                vc.ventanaActual=@"dapo";
                //vc.ventanaActual2=;
                vc.idreal=idreal;
                [self.navigationController pushViewController:vc animated:true];
            }
            else if([tipoBoton isEqualToString:@"agregarCaso"] || [tipoBoton isEqualToString:@"editarCaso"] ||
                    [tipoBoton isEqualToString:@"agregarActuar"] || [tipoBoton isEqualToString:@"editarActuar"])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                editarCatViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"editarCat"];
                vc.ventanaActual=tipoBoton;
                if([tipoBoton isEqualToString:@"agregarCaso"] || [tipoBoton isEqualToString:@"agregarActuar"])
                    vc.idreal=self.idreal;
                else
                    vc.idreal=idreal;
                [self presentViewController:vc animated:true completion:^{
                    
                    
                }];
            }
            
            else if([tipoBoton isEqualToString:@"agregarNota"] || [tipoBoton isEqualToString:@"editarNota"])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                editarCatViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"editarCat"];
                vc.ventanaActual=tipoBoton;
                if([tipoBoton isEqualToString:@"agregarNota"])
                    vc.idreal=self.idreal;
                else
                    vc.idreal=idreal;
                [self presentViewController:vc animated:true completion:^{
                    
                    
                }];
            }
            
            else if([tipoBoton isEqualToString:@"editarCasos"] || [tipoBoton isEqualToString:@"editarActuares"] || [tipoBoton isEqualToString:@"editarNotas"])
            {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                encuentrosViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"encuentros"];
                vc.pasoActual=-1;
                vc.ventanaActual=tipoBoton;
                vc.idreal=self.idreal;
                [self.navigationController pushViewController:vc animated:true];
            }
            
        }
        else if([tipo isEqualToString:@"mapa"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            mapaTimelineViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"mapaTimeline"];
            vc.diccionario=[NSMutableDictionary dictionaryWithDictionary:diccionario];
            [self.navigationController pushViewController:vc animated:true];
        }
        
    }
    
    else if([tipo isEqualToString:@"video"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
        vistawebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"vistaweb"];
        vc.modo=@"video";
        vc.url=[APIConnection getStringJSON:diccionario withKey:@"youtubeidvid" widthDefValue:@""];
        [self presentViewController:vc animated:true completion:nil];
    }
    else if([tipo isEqualToString:@"foto"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        imagenViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"imagen"];
        vc.archivo=[APIConnection getStringJSON:diccionario withKey:@"archivofoto" widthDefValue:@""];;
        [self presentViewController:vc animated:true completion:nil];
    }
}

-(void)compartirDesdeTimeLine:(NSString *)URL
{
    [self compartirAccion:URL];
}

-(void)compartirBoton
{
    if(![URLCompartir isEqualToString:@""])
    {
        [self compartirAccion:URLCompartir];
    }
}

-(void)compartirAccion:(NSString *)url
{

    if(![url isEqualToString:@""])
    {

        NSArray * activityItems = @[[NSString stringWithFormat:NSLocalizedString(@"Te comparto", )], [NSURL URLWithString:url]];
        NSArray * applicationActivities = nil;
        NSArray * excludeActivities = @[UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeMessage];
        
        UIActivityViewController * activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:applicationActivities];
        activityController.excludedActivityTypes = excludeActivities;
        
        activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
            if (completed) {
                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"compartir"
                                                                      action:url
                                                                       label:@""
                                                                       value:nil] build]];
            }
        };
        
        [self presentViewController:activityController animated:YES completion:nil];
    }
    
}


-(void)ocultaTeclado
{
    [self.view endEditing:YES];
}

-(void)registraMeGusta:(long)operacion conTabla:(NSString *)tabla conRegistro:(NSString *)registro
{
    [APIConnection connectAPI:[NSString stringWithFormat:@"operaciones.php?operacion=megusta&valor=%ld&tabla=%@&registro=%@",operacion,tabla,registro] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"megusta" willContinueLoading:false];
}

-(void)abreURLDirecta:(NSString *)URLAbrir conModo:(NSString *)modo conOperacion:(NSString *)operacion conIdreal:(NSString *)idreal
{
    NSLog(@"%@ / abre / %@",operacion,idreal);
    /*id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
     [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
     action:accion
     label:label
     value:nil] build]];*/
    if([modo isEqualToString:@"web"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
        vistawebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"vistaweb"];
        vc.modo=@"url";
        vc.url=URLAbrir;
        [self presentViewController:vc animated:true completion:nil];

    }
    else
    {
        NSArray *toRecipents = [NSArray arrayWithObject:URLAbrir];
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:@""];
        [mc setMessageBody:@"" isHTML:NO];
        [mc setToRecipients:toRecipents];
        
        [self presentViewController:mc animated:YES completion:NULL];
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)scrollToTop
{

}

-(void)cambiaFuente
{
    if(multiplicadorFuente>=1.5)
        multiplicadorFuente=1.0;
    else multiplicadorFuente=multiplicadorFuente+0.1;
    cambioFuenteAhora=true;
    [self saveConfig:@"fuente" withValue1:[NSString stringWithFormat:@"%f",multiplicadorFuente]];
    [self viewDidAppear:true];
}

-(void)cambiaColorFuente
{
    NSString *fuenteColor=[self readConfig:@"fuenteColor"];
    if([fuenteColor isEqualToString:@"1"])
    {
        fuenteColor=@"2";
        configPrincipal=[NSMutableDictionary dictionaryWithDictionary:configPrincipal2];
    }
    else
    {
        fuenteColor=@"1";
        configPrincipal=[NSMutableDictionary dictionaryWithDictionary:configPrincipal1];

    }
    colorFuenteGlobal=fuenteColor;
    cambioFuenteAhora=true;
    [self saveConfig:@"fuenteColor" withValue1:fuenteColor];
    [self viewDidAppear:true];

}




-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==10001)
    {
        if(buttonIndex>0)
        {
            [self cargaContenidoTimeline:buttonIndex];
        }
    }
}

-(void)cargaContenidoTimeline:(long)buttonIndex
{
    NSDictionary *elemento=[arregloRelaciones objectAtIndex:buttonIndex-1];
    NSString *campo=[APIConnection getStringJSON:elemento withKey:@"campo" widthDefValue:@""];
    NSString *registro=[APIConnection getStringJSON:elemento withKey:@"registro" widthDefValue:@""];
    
    if([campo isEqualToString:@"idact"] || [campo isEqualToString:@"idlug"] || [campo isEqualToString:@"idcad"] || [campo isEqualToString:@"idusuario"])
    {
        NSDictionary *dictionary;
        NSString *tipo;
        if([campo isEqualToString:@"idact"])
        {
            dictionary=[NSDictionary dictionaryWithObjectsAndKeys:registro,@"idreal", nil];
            tipo=@"act";
        }
        else if([campo isEqualToString:@"idlug"])
        {
            dictionary=[NSDictionary dictionaryWithObjectsAndKeys:registro,@"idreal", nil];
            tipo=@"lug";
        }
        else if([campo isEqualToString:@"idcad"])
        {
            dictionary=[NSDictionary dictionaryWithObjectsAndKeys:registro,@"idreal", nil];
            tipo=@"cad";
        }
        else if([campo isEqualToString:@"idusuario"])
        {
            dictionary=[NSDictionary dictionaryWithObjectsAndKeys:registro,@"idreal", nil];
            tipo=@"usu";
        }
        [self abreVentana:tipo conDiccionario:dictionary conIDreal:registro];
    }
    else if([campo isEqualToString:@"origen"])
    {
        NSString *tablaorigentim=[APIConnection getStringJSON:elemento withKey:@"tablaorigentim" widthDefValue:@""];
        NSString *registrotimorigen=[APIConnection getStringJSON:elemento withKey:@"registrotimorigen" widthDefValue:@""];
        if([tablaorigentim isEqualToString:@"lug"])
        {
        
            [self abreVentana:@"lug" conDiccionario:[NSDictionary dictionaryWithObjectsAndKeys:registrotimorigen,@"idreal", nil] conIDreal:registrotimorigen];
        }
        
        
       
    }
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"timelineAbreContenido"
                                                          action:campo
                                                           label:registro
                                                           value:nil] build]];
}

-(void)actualizaComentarios:(long)comentarios conRow:(long)row
{

}

-(void)actualizaComentarios:(long)comentarios
{
    
}

-(void)abreMiPerfil
{
    if(![token isEqualToString:@""])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        perfilViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"perfil"];
        [self presentViewController:vc animated:true completion:^{
            
            
        }];
        
    }
    else [self abreFirma];
}

-(void)firmaRegreso:(NSString *)operacion
{
    stringToPass=@"";
    [self.navigationController popToRootViewControllerAnimated:true];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==999)
    {
        if(buttonIndex==1)
            [self abreMiPerfil];
    }
    else if(alertView.tag==992)
        if(buttonIndex==1)
            [self compartirDesdeTimeLine:URLCompartirPost];
}


-(void)avisoPublicacion:(NSString *)texto
{
    [SVProgressHUD showSuccessWithStatus:texto];
}

-(void)detieneAudio:(BOOL)cerrar
{
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
