//
//  AppDelegate.m
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"
// PARA INSTALAR FACEBOOK CONSULTAR https://developers.facebook.com/docs/ios/getting-started
#import "noticiaDetalleViewController.h"
#import "HDNotificationView.h"
#import "PayPalMobile.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#import <sqlite3.h>
@implementation AppDelegate
#import "databaseOperations.h"


int screenMultiplier=1;
CGFloat screenWidth;
CGFloat screenHeight;
CGFloat versionSistema;
CGFloat alturaStatus;
NSDictionary *tagsDictionary;

/*NSString* GAPIURLImages = @"http://www.123probando.com.mx/legios/recursos/";
NSString* GAPIURL = @"http://www.123probando.com.mx/legios/APIRemote/";
NSString* GAPIShare = @"http://www.123probando.com.mx/legios/";*/
NSString* GAPIURLImages = @"http://www.vitamexico.org/recursos/";
NSString* GAPIURL = @"http://www.vitamexico.org/APIRemote2/";
NSString* GAPIShare = @"http://www.vitamexico.org/legios/";

/*
NSString* GAPIURLImages = @"http://www.cutelmex.com/pruebas/recursos/";
NSString* GAPIURL = @"http://www.cutelmex.com/pruebas/APIRemote/";
NSString* GAPIShare = @"http://www.cutelmex.com/pruebas/";
*/
NSString* GAPICiudad=@"1";
NSString* GAPIContentType= @"application/x-www-form-urlencoded; charset=utf-8";
NSString* imagenMails = @"http://cdn.kiwilimon.com/images/varios/email-logo.png";
NSString *imagenPredeterminada=@"1/pre55810f2aaabc3.png";

NSString* stringToPass = @"";
NSString* stringToPass1 = @"";
NSString* stringToPass2 = @"";
NSMutableDictionary* dictionaryToPass;

NSString* APIlocale=@"0";
NSString* APIDocDir;

NSString *token=@"";
NSString *uid = @"0";

NSString *tokenCMS = @"";
NSString *tokenName= @"";
NSString *tokenImagen= @"";
NSString *tokenTeam= @"0";
NSString *tokenMember= @"0";
NSString *tokenManager=@"0";
BOOL recienFirmado=false;

NSString *googleAdID = @"/3879499/320x50App";
BOOL googleProbando = false;
NSString *googleTest = @"aaaa";

NSString *dispositivo;
NSString *stringToPass;
NSDictionary *dictionaryToPass1,*dictionaryToPass2,*dictionaryToPass3;
NSString *proximaVentana=@"";
NSDictionary *proximoDiccionario=nil;
BOOL popOverEstaAbierto=false;
NSString *cBase=@"#fe7300";

// VARIABLES PARA FORMULARIOS
NSString *fuenteEspecial=@"Arial";
NSString *cDestacado=@"#FF0000";
NSString *cGris80=@"808080";

NSString *urlRC=@"";

BOOL audioReproduciendo=false;
float audioDuracion,audioProgreso;
NSString *audioArchivo=@"";

NSMutableDictionary *configPrincipal,*configPrincipal1,*configPrincipal2;

double multiplicadorFuente=1.0;
NSString *colorFuenteGlobal=@"1";
BOOL cambioFuenteAhora=false;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self CopyDbToDocumentsFolder];
    multiplicadorFuente=[[self readConfig:@"fuente"] doubleValue];
    // creamos la tabla que nos falta
    [self databaseUpdate:@"CREATE TABLE `calendario` (`id`	INTEGER PRIMARY KEY AUTOINCREMENT,`tipo` TEXT, `idcalendario` TEXT, `idregistro`	INTEGER,`idusuario`	INTEGER);"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    actividadesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"actividades"];
    vc.ventanaActual=@"home";
    vc.ventanaActual2=@"home";
     navigationController = [[navigationViewController alloc] initWithRootViewController:vc];
    [navigationController setNavigationBarHidden:YES animated:YES];
    
    
    [OneSignal setLogLevel:ONE_S_LL_VERBOSE visualLevel:ONE_S_LL_NONE];
    
    // OneSignal initialization
    [OneSignal initWithLaunchOptions:launchOptions];
    [OneSignal setAppId:@"227b9fb1-175f-4613-aaae-d6f14c3a5af9"];

    // promptForPushNotifications will show the native iOS notification permission prompt.
    // We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 8)
 
    
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    self.window.rootViewController = navigationController;
   
    CGRect frame = [UIScreen mainScreen].bounds;
    
    // Real Size + 0.000001
    self.window.frame = CGRectMake(0, 0, frame.size.width+0.000001, frame.size.height+0.000001);
    [self.window makeKeyAndVisible];
    
    [application setStatusBarHidden:YES];
    [application setStatusBarStyle:UIStatusBarStyleDefault];
    
    versionSistema=[[[UIDevice currentDevice] systemVersion] intValue];
    if(versionSistema>=7) alturaStatus=0;
    screenWidth = [[UIScreen mainScreen] bounds].size.width;
    screenHeight = [[UIScreen mainScreen] bounds].size.height;
    if (IPAD) {
        // iPad
        dispositivo = @"ipad";
    } else {
        // iPhone / iPod Touch
        dispositivo = @"iphone";
    }
    
    // funciones memo
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        googleAdID = @"/3879499/768x70App";
    }
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0))
    {
        screenMultiplier=2;
        
    }

    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-73493230-1"];
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback    error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    
    
    // pedimos permiso para recibir notidicaciones
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    // generemos el track de audio para las alertas
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"alerta"
                                              withExtension:@"mp3"];
    avSound = [[AVAudioPlayer alloc]     initWithContentsOfURL:soundURL error:nil];
    avSound.numberOfLoops = 3;
    
    // vemos si recibimos una notificación
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(notification)
        [self mostrarNotificacion:notification];
    
    token = [self readConfig:@"token"];
    uid = [self readConfig:@"uid"];
    tokenCMS = [self readConfig:@"tokenCMS"];
    tokenName = [self readConfig:@"tokenName"];
    tokenImagen=[self readConfig:@"tokenImagen"];
    tokenTeam = [self readConfig:@"tokenTeam"];
    tokenMember = [self readConfig:@"tokenMember"];
    tokenManager = [self readConfig:@"tokenManager"];
    
   
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else
    #endif
    {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
    }
   
    // terminan cosa de parse
    
    APIConnection=[[iwantooAPIConnection alloc] init];
    APIConnection.delegationListener=self;
    [APIConnection limpiaSesion];
    if([token isEqualToString:@""])
    {
        [self abreFirma];
    }
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        // como viene de afuera vamos directo a la operación
        [self handleRemoteNotificationsOperacion:userInfo];
    }
    configPrincipal1=[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     @"VITA",@"nombreAPP",
                     @"df/lug/2015/02/502-amalgama/fotos/logoPrincipal1b.png",@"logoPrincipal1",
                     @"df/lug/2015/02/502-amalgama/fotos/logoPrincipal2b.png",@"logoPrincipal2",
                     @"df/lug/2015/02/502-amalgama/fotos/imagenLateral.jpg",@"imagenLateral",
                     @"#F2F2F2",@"colorFondo1",
                     @"#FFFFFF",@"colorFondo2",
                     @"#515151",@"colorFondoTitulo",
                     @"#A4A4A4",@"colorBotoncitoTitulo",
                     @"#3C3C3C",@"colorTitulo",
                     @"#555555",@"colorSubtitulo",
                     @"#cccccc",@"tablaFondoPrincipal",
                     @"#B3B3B3",@"colorLinea",
                     @"#333333",@"colorTexto",

                     @"#ff5100",@"colorDestacado",
                     @"#ff5100",@"colorPantallaCompleta",
                     @"#666666",@"colorDestacadoOpaco",
                     @"#FFFFFF",@"colorTextoSobreDestacado",
                     
                     @"#5F504D",@"colorFondo3",
                     @"#e6e6e6",@"colorGris",
                     @"#808080",@"colorTextoGris",
                     @"#DADADA",@"colorLineas",
                     @"#FFFFFF",@"colorBotonFondo1",
                     @"#FFFFFF",@"colorBotonFondo2",
                     @"#FFFFFF",@"colorBotonFondo3",
                     @"#FFFFFF",@"colorTextoFondo1",
                     @"#FFFFFF",@"colorTextoFondo2",
                     @"#FFFFFF",@"colorTextoFondo3",
                     @"#FFFFFF",@"colorLogo",
                      @"#ff5100",@"colorEstrellas",

                     
                     
                     @"#999999",@"colorSocial",
                     @"#cccccc",@"tablaFondoRenglon",
                     nil,@"cat",
                     @"0",@"scatlistar",
                     nil];
    
    configPrincipal2=[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                     @"VITA",@"nombreAPP",
                     @"df/lug/2015/02/502-amalgama/fotos/logoPrincipal1b.png",@"logoPrincipal1",
                     @"df/lug/2015/02/502-amalgama/fotos/logoPrincipal2b.png",@"logoPrincipal2",
                     @"df/lug/2015/02/502-amalgama/fotos/imagenLateral.jpg",@"imagenLateral",
                     @"#222222",@"colorFondo1",
                     @"#333333",@"colorFondo2",
                     @"#313131",@"colorFondoTitulo",
                     @"#EEEEEE",@"colorBotoncitoTitulo",
                     @"#FFFFFF",@"colorTitulo",
                     @"#EEEEEE",@"colorSubtitulo",
                     @"#5F504D",@"colorDestacado",
                     @"#FFFFFF",@"colorPantallaCompleta",
                     @"#555555",@"colorDestacadoOpaco",
                     @"#FFFFFF",@"colorTextoSobreDestacado",
                     @"#111111",@"tablaFondoPrincipal",
                     @"#666666",@"colorLinea",
                     @"#FFFFFF",@"colorTexto",

                     @"#5F504D",@"colorFondo3",
                     @"#e6e6e6",@"colorGris",
                     @"#808080",@"colorTextoGris",
                     @"#DADADA",@"colorLineas",
                     @"#FFFFFF",@"colorBotonFondo1",
                     @"#FFFFFF",@"colorBotonFondo2",
                     @"#FFFFFF",@"colorBotonFondo3",
                     @"#FFFFFF",@"colorTextoFondo1",
                     @"#FFFFFF",@"colorTextoFondo2",
                     @"#FFFFFF",@"colorTextoFondo3",
                     @"#FFFFFF",@"colorLogo",
                     @"#FFFFFF",@"colorEstrellas",
                      
                     @"#999999",@"colorSocial",
                     @"#cccccc",@"tablaFondoRenglon",
                     nil,@"cat",
                     @"0",@"scatlistar",
                     nil];
    NSString *fuenteColor=[self readConfig:@"fuenteColor"];
    if([fuenteColor isEqualToString:@"1"])
        configPrincipal=[NSMutableDictionary dictionaryWithDictionary:configPrincipal1];
    else
        configPrincipal=[NSMutableDictionary dictionaryWithDictionary:configPrincipal2];
    colorFuenteGlobal=fuenteColor;
    
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AV4aD2Pw6Xs140EyDO11gNAoWByR7lejSJisatcxunkVAstVoAYAyE-Nauv79upzZCypxf8_ys5Ubcbk",
                                                           PayPalEnvironmentSandbox : @"AUhbLNATIvCyD31NhFLmkrN4AiXJooPIYmZjmgeXSNuo_mqMQxoQJJfbijn2grxrg1SLcVdyKznEzw5a"}];
    
    
    return YES;

}
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    [self.window setFrame:bounds];
    [self.window setBounds:bounds];
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //LandScapeMode:- UIInterfaceOrientationLandscapeRight;
   // ProtraitMode:-
    return UIInterfaceOrientationPortrait;
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
   
    
/*    NSLog(@"%@",token);
    if([token isEqualToString:@""])
    {
        [self abreFirma];
    }
  */  
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification{
    [self mostrarNotificacion:notification];
}

-(void)mostrarNotificacion:(UILocalNotification *)notification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    [avSound play];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"VITA"
                                                    message:notification.alertBody
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==1000) // es la de recueprar contraseña
    {
        if(buttonIndex==1) // presiono si
        {
            if([[alertView textFieldAtIndex:0].text length]==0)
            {
                [self recuperaContrasena:NSLocalizedString(@"Proporciona la contraseña", )];
            }
            else if(![[alertView textFieldAtIndex:0].text isEqualToString:[alertView textFieldAtIndex:1].text])
            {
                [self recuperaContrasena:NSLocalizedString(@"Las contraseñas no coinciden", )];
            }
            else
            {
                [APIConnection connectAPI:[NSString stringWithFormat:@"users.handler.php?action=updateForgotedPass&tokenTemporal=%@&pass=%@",tokenTemporalGlobal,[alertView textFieldAtIndex:0].text] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:true withSender:@"recuperaContrasena" willContinueLoading:false];
            }
        }
    }
    else if(alertView.tag==999)
    {
        if(buttonIndex==1 && ![token isEqualToString:@""])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            perfilViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"perfil"];
            
            [navigationController pushViewController:vc animated:true];
            
        }
    }
    [avSound stop];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if (!url) {  return NO; }
    NSString *URLString = [url absoluteString];
    
    NSString *accion=@"";
    NSString *idConsulta=@"";
    
    // read the link and process it
    NSString *string = URLString;
    NSLog(@"%@",string);
    NSArray *chunks = [string componentsSeparatedByString: @"&"];
    NSLog(@"%@",chunks);
    
    
    NSString *modoTemporal=@"";
    NSString *tokenTemporal=@"";
    for(id parts in chunks)
    {
        NSArray *chunks2 = [parts componentsSeparatedByString: @"="];
        if([chunks2 count]==2)
        {
            if([[chunks2 objectAtIndex:0] isEqualToString:@"modo"]) // it is atoken requested
            {
                modoTemporal=[chunks2 objectAtIndex:1];
            }
            if([[chunks2 objectAtIndex:0] isEqualToString:@"token"]) // it is atoken requested
            {
                tokenTemporal=[chunks2 objectAtIndex:1];
            }
            
        }
    }
    if([modoTemporal isEqualToString:@"recuperaContrasena"]){
        if([token isEqualToString:@""])
        {
            tokenTemporalGlobal=tokenTemporal;
            [self recuperaContrasena:NSLocalizedString(@"Proporciona una nueva contraseña", )];
            
            return NO;
            
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"No puedes recuperar tu contraseña mientras estés firmado." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
            return NO;
        }
        
    }
    
    /*for(id parts in chunks)
    {
        NSArray *chunks2 = [parts componentsSeparatedByString: @"="];
        if([chunks2 count]==2)
        {
            if([[chunks2 objectAtIndex:0] isEqualToString:@"accion"]) // it is atoken requested
            {
                accion=[chunks2 objectAtIndex:1];
            }
            if([[chunks2 objectAtIndex:0] isEqualToString:@"idConsulta"]) // it is atoken requested
            {
                idConsulta=[chunks2 objectAtIndex:1];
            }
            
        }
    }*/
    
    // va a ser modo master porque tiene accion
    if(![accion isEqualToString:@""])
    {
        /*
         NSLog(@"%@ %@",accion,idConsulta);
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         masterViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"master"];
         vc.accion = accion;
         vc.idConsulta=idConsulta;
         */
        
        stringToPass=accion;
        stringToPass2=idConsulta;
        [self.window.rootViewController dismissViewControllerAnimated:false completion:nil];
        UITabBarController *tabb = (UITabBarController *)self.window.rootViewController;
        tabb.selectedIndex = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"notificacionCalendario" object:nil];
        
        
        return YES;
    }
    else
        return NO;}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}
-(void)handleRemoteNotifications:(NSDictionary *)userInfo
{
    NSLog(@"userInfo %@",userInfo);
    NSDictionary *infoExtra=[APIConnection getDictionaryJSON:userInfo withKey:@"infoExtra"];

    if(infoExtra)
    {
        NSString *modo=[APIConnection getStringJSON:infoExtra withKey:@"modo" widthDefValue:@""];
        NSString *textoNotificacion=[APIConnection getStringJSON:infoExtra withKey:@"texto" widthDefValue:@""];
        
        NSString *tituloNotificacion;
        if([modo isEqualToString:@"act"]) tituloNotificacion=@"Actividad";
        else if([modo isEqualToString:@"enc"]) tituloNotificacion=@"Encuentro";
        else if([modo isEqualToString:@"par"]) tituloNotificacion=@"Parroquia";
        else if([modo isEqualToString:@"ref"]) tituloNotificacion=@"Reflexión";
        else if([modo isEqualToString:@"cuotas"]) tituloNotificacion=@"Aportaciones de Miembros";
        else tituloNotificacion=@"VITA";
        
        // Show notification view
        [HDNotificationView showNotificationViewWithImage:[UIImage imageNamed:@"logoPeque"]
                                                    title:tituloNotificacion
                                                  message:textoNotificacion
                                               isAutoHide:false
                                                  onTouch:^{

                                                       [self handleRemoteNotificationsOperacion:userInfo];
                                                       [HDNotificationView hideNotificationViewOnComplete:nil];
                                                  }];
        
    }

    
}

-(void)abreVentanaPeticion:(NSString *)modo conIDInterno:(NSString *)idInterno conTabla:(NSString *)tabla
{   
    if([modo isEqualToString:@"cita"] || [modo isEqualToString:@"cuotas"] || [modo isEqualToString:@"act"] || [modo isEqualToString:@"enc"] || [modo isEqualToString:@"par"] || [modo isEqualToString:@"ref"] || [modo isEqualToString:@"noti"])
    {
        if([token isEqualToString:@""] && ([modo isEqualToString:@"cuotas"] || [modo isEqualToString:@"par"] || [modo isEqualToString:@"ref"])) // debes estar firmado
        {
            // no hacemos nada
        }
        else if([modo isEqualToString:@"cita"])
        {
            [self.window.rootViewController dismissViewControllerAnimated:true completion:nil];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            actividadesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"actividades"];
            vc.diccionario=nil;
            vc.ventanaActual=@"citaDetalle";
            vc.idreal=idInterno;
            [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:true];
        }
        else if([modo isEqualToString:@"noti"])
        {
            [self.window.rootViewController dismissViewControllerAnimated:true completion:nil];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            actividadesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"actividades"];
            vc.diccionario=nil;
            vc.ventanaActual=@"notiDetalle";
            vc.idreal=idInterno;
            [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:true];
        }
        else
        {
            [self.window.rootViewController dismissViewControllerAnimated:true completion:nil];
            NSString *ventanaActual=[NSString stringWithFormat:@"%@Detalle",modo];
            if([modo isEqualToString:@"cuotas"]) ventanaActual=@"conc";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
            actividadesViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"actividades"];
            vc.diccionario=nil;
            vc.ventanaActual=ventanaActual;
            vc.ventanaActual2=@"notificacion";
            vc.idreal=idInterno;
            [(UINavigationController *)self.window.rootViewController pushViewController:vc animated:true];
        }
    }
}



-(void)handleRemoteNotificationsOperacion:(NSDictionary *)userInfo
{
    NSLog(@"aca %@",userInfo);

    NSDictionary *infoExtra=[APIConnection getDictionaryJSON:userInfo withKey:@"infoExtra"];
    NSString *modo=[APIConnection getStringJSON:infoExtra withKey:@"modo" widthDefValue:@""];
    NSString *idInterno=[APIConnection getStringJSON:infoExtra withKey:@"idInterno" widthDefValue:@""];
    NSString *tabla=[APIConnection getStringJSON:infoExtra withKey:@"tabla" widthDefValue:@""];
    [self abreVentanaPeticion:modo conIDInterno:idInterno conTabla:tabla];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"alla %@", userInfo);
    
    NSDictionary *apsPayload = userInfo[@"aps"];
    NSString *alertString = apsPayload[@"alert"];
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Notification"
                          message:alertString
                          delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
    
    // estaba corriendo, mostremos la barrita
    if ( application.applicationState == UIApplicationStateActive )
        [self handleRemoteNotifications:userInfo];
    else
        [self handleRemoteNotificationsOperacion:userInfo]; // no estaba corriendo, mostramos el contenido
    
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"%@",error);
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    if (!url) {  return NO; }
    
    NSString *URLString = [url absoluteString];
    
    NSString *modo=@"";
    NSString *tokenTemporal=@"";
    NSString *idproceso=@"";
    NSString *tabla=@"";
    
    // read the link and process it
    NSString *string = URLString;
    NSArray *chunks = [string componentsSeparatedByString: @"&"];
    for(id parts in chunks)
    {
        NSArray *chunks2 = [parts componentsSeparatedByString: @"="];
        if([chunks2 count]==2)
        {
            if([[chunks2 objectAtIndex:0] isEqualToString:@"modo"]) // it is atoken requested
            {
                modo=[chunks2 objectAtIndex:1];
            }
            if([[chunks2 objectAtIndex:0] isEqualToString:@"token"]) // it is atoken requested
            {
                tokenTemporal=[chunks2 objectAtIndex:1];
            }
            if([[chunks2 objectAtIndex:0] isEqualToString:@"idproceso"]) // it is atoken requested
            {
                idproceso=[chunks2 objectAtIndex:1];
            }
            if([[chunks2 objectAtIndex:0] isEqualToString:@"tabla"]) // it is atoken requested
            {
                tabla=[chunks2 objectAtIndex:1];
            }
        }
    }
    
    if([modo isEqualToString:@"jue"] || [modo isEqualToString:@"jug"] || [modo isEqualToString:@"equ"] || [modo isEqualToString:@"noti"] || [modo isEqualToString:@"comentarios"])
    {
        [self abreVentanaPeticion:modo conIDInterno:idproceso conTabla:tabla];
        return NO;

    }
    else if([modo isEqualToString:@"validaUsuario"])
    {
        if([token isEqualToString:@""])
        {
            [APIConnection connectAPI:[NSString stringWithFormat:@"users.handler.php?action=validateUser&tokenTemporal=%@",tokenTemporal] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"validaUsuario" willContinueLoading:false];
            return YES;
            
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"No puedes validar una cuenta mientras estés firmado." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
            return NO;
        }
    }
    else if([modo isEqualToString:@"recuperaContrasena"])
    {
        if([token isEqualToString:@""])
        {
            tokenTemporalGlobal=tokenTemporal;
            [self recuperaContrasena:NSLocalizedString(@"Proporciona una nueva contraseña", )];
            
            return NO;
            
        }
        else
        {
            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso" message:@"No puedes recuperar tu contraseña mientras estés firmado." delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
            [alerta show];
            return NO;
        }
    }
    else
        return NO;
}

-(void)recuperaContrasena:(NSString *)mensaje
{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Cambiar contraseña", ) message:mensaje delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [av setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    av.tag=1000;
    
    // Alert style customization
    [[av textFieldAtIndex:0] setSecureTextEntry:YES];
    [[av textFieldAtIndex:1] setSecureTextEntry:YES];
    [[av textFieldAtIndex:0] setPlaceholder:@"Contraseña"];
    [[av textFieldAtIndex:1] setPlaceholder:@"Confirma contraseña"];
    [av show];
}




-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    if([senderValue isEqualToString:@"recuperaContrasena"])
    {
        NSDictionary *meta=[APIConnection getDictionaryJSON:json withKey:@"meta"];
        if([[APIConnection getStringJSON:meta withKey:@"code" widthDefValue:@"200"] isEqualToString:@"200"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contraseña cambiada"
                                                            message:@"Tu contraseña cambió correctamente"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
        }
        else
        {
            [self recuperaContrasena:[APIConnection getStringJSON:meta withKey:@"detail" widthDefValue:@""]];
        }
        
    }
}

-(void)abreFirma
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
    firmaViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"firma"];
    [self.window.rootViewController presentViewController:vc animated:true completion:nil];
}

- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        
        NSLog(@"%ld",(long)transaction.originalTransaction);
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
                [self showTransactionAsInProgress:transaction deferred:NO];
                break;
            case SKPaymentTransactionStateDeferred:
                [self showTransactionAsInProgress:transaction deferred:YES];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                // For debugging
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
    }
}
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"%@",[error localizedDescription]);
    if(error)
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    
    
}
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions{
    NSLog(@"removedTransactions");
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    
    
}
-(void)showTransactionAsInProgress:(SKPaymentTransaction*)transaction deferred:(BOOL)deferred{
    
    NSLog(@"showTransactionAsInProgress %d",deferred);
    if(transaction.originalTransaction)
    {
        NSLog(@"Just restoring the transaction");
    }
    else
    {
        NSLog(@"First time transaction");
    }
}

-(void)failedTransaction:(SKPaymentTransaction*)transaction{
    NSLog(@"failedTransaction");
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [SVProgressHUD dismiss];
}
-(void)completeTransaction:(SKPaymentTransaction*)transaction{
    NSLog(@"completeTransaction");
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
-(void)restoreTransaction:(SKPaymentTransaction*)transaction{
    NSLog(@"restoreTransaction");
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
-(void)limpiaAudio
{
    if(self.movieplayer)
        {
        if(self.timeObserverToken)
        {
            audioArchivo=@"";
            audioReproduciendo=false;
            [self.movieplayer removeTimeObserver:self.timeObserverToken];
            self.timeObserverToken=NULL;
        }
    }
}

-(void)cargaAudio:(NSString *)urlCargar
{
    if(![urlCargar isEqualToString:@""] && ![audioArchivo isEqualToString:urlCargar])
    {
        audioArchivo=urlCargar;

        urlCargar = [urlCargar stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *fileURL =  [NSURL URLWithString:urlCargar];
        if(!self.movieplayer)
        {
           self.movieplayer = [[AVPlayer alloc] init];
            self.movieplayer = [AVPlayer playerWithURL:fileURL];

             
             [self.movieplayer.currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:0 context:nil];
             [self.movieplayer.currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:0 context:nil];
             [self.movieplayer.currentItem addObserver:self forKeyPath:@"playerDidFinishPlaying" options:0 context:nil];
             [self.movieplayer.currentItem addObserver:self forKeyPath:@"status" options:0 context:nil];
             [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.movieplayer.currentItem];
             [self.movieplayer setAllowsExternalPlayback:YES];
             [self.movieplayer setUsesExternalPlaybackWhileExternalScreenIsActive: YES];
        }
        else
        {
            [self.movieplayer.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
            [self.movieplayer.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
            [self.movieplayer.currentItem removeObserver:self forKeyPath:@"status"];
            [self.movieplayer.currentItem removeObserver:self forKeyPath:@"playerDidFinishPlaying"];
            
            [self.movieplayer replaceCurrentItemWithPlayerItem:[AVPlayerItem playerItemWithURL:fileURL]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.movieplayer.currentItem];

            [self.movieplayer.currentItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:0 context:nil];
            [self.movieplayer.currentItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:0 context:nil];
            [self.movieplayer.currentItem addObserver:self forKeyPath:@"status" options:0 context:nil];
            [self.movieplayer.currentItem addObserver:self forKeyPath:@"playerDidFinishPlaying" options:0 context:nil];
        }
        [[NSNotificationCenter defaultCenter]
                   postNotificationName:@"mostrarLoader"
                   object:self];
        [self.movieplayer play];
        audioReproduciendo=true;
        __weak typeof(self) weakSelf = self;
        self.timeObserverToken =
        [self.movieplayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 2)
                                                   queue:dispatch_get_main_queue()
                                              usingBlock:^(CMTime time)
                                              {
            audioProgreso=CMTimeGetSeconds(time);
            audioDuracion=CMTimeGetSeconds(weakSelf.movieplayer.currentItem.duration);
            
           
            [[NSNotificationCenter defaultCenter]
            postNotificationName:@"cambioReproductor"
            object:weakSelf];
            
                                              }];
        
        self.movieplayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
    }
}

-(void)audioAccion:(NSString *)archivo
{
    if([archivo isEqualToString:audioArchivo])
    {
        if(audioReproduciendo)
        {
            audioReproduciendo=false;
            [self.movieplayer pause];
        }
        else
        {
            audioReproduciendo=true;
            [self.movieplayer play];
        }
        [[NSNotificationCenter defaultCenter]
        postNotificationName:@"cambioReproductor"
        object:self];
    }
    else
    {
        [self cargaAudio:archivo];
    }
    
}

-(void)observeValueForKeyPath:(NSString*)keyPath
                     ofObject:(id)object
                       change:(NSDictionary*)change
                      context:(void*)context {
    if ([keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"mostrarLoader"
         object:self];
        if (self.movieplayer.status == AVPlayerStatusFailed) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ocultarLoader"
             object:self];
            
        }
    }
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"mostrarLoader"
         object:self];
        if (self.movieplayer.currentItem.playbackLikelyToKeepUp)
        {
            if(audioReproduciendo)
                [self.movieplayer play];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ocultarLoader"
             object:self];
        }
    }
    else if ([keyPath isEqualToString:@"status"])
    {
        
        if (self.movieplayer.currentItem.status == AVPlayerStatusReadyToPlay) {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ocultarLoader"
             object:self];
        }
        else if (self.movieplayer.currentItem.status == AVPlayerStatusFailed)
        {
            [self.movieplayer pause];
            audioReproduciendo = false;
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ocultarLoader"
             object:self];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"cambioReproductor"
             object:self];
            [SVProgressHUD showErrorWithStatus:@"No se pudo reproducir este archivo"];
            
        }
    }
    else if([keyPath isEqualToString:@"playerDidFinishPlaying"])
    {
        NSLog(@"memin");
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
    [self.movieplayer pause];
    audioReproduciendo=false;
    NSLog(@"memon");

}

@end
