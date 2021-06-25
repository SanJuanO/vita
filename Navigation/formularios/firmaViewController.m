//
//  firmaViewController.m
//  tenerMascota
//
//  Created by GUILLERMO FERNANDEZ M on 07/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import "firmaViewController.h"
#import "SVProgressHUD.h"
#import "vistawebViewController.h"
#import "UIImageView+AFNetworking.h"
#import <sqlite3.h>
#import "AppDelegate.h"
@interface firmaViewController ()

@end

@implementation firmaViewController
@synthesize email = _email;
@synthesize password = _password;

@synthesize entrarAMiCuenta = _entrarAMiCuenta;
@synthesize olvidemicontrasena = _olvidemicontrasena;
@synthesize vista1Datos=_vista1Datos;
@synthesize delegate=_delegate;
@synthesize posicion=_posicion;

@synthesize alineacionVistaDatos1=_alineacionVistaDatos1;

@synthesize terminos=_terminos;

#import "databaseOperations.h"
#import "globales.h"
#import "color.h"
- (AppDelegate*)appDelegate {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}
-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    //NSLog(@"%@",json);
    if([senderValue isEqualToString:@"recuperarContrasena"])
    {
        NSDictionary *meta=[APIConnection getDictionaryJSON:json withKey:@"meta"];
        if(![[APIConnection getStringJSON:meta withKey:@"code" widthDefValue:@""] isEqualToString:@"200"])
        {
            [APIConnection muestraErrorFirma:[APIConnection getStringJSON:meta withKey:@"detail" widthDefValue:@""]];
            [APIConnection limpiaSesion];
        }
        else
        {
            UIAlertView *alert;
            alert = [[UIAlertView alloc] initWithTitle:@"Cambiar contraseña" message:NSLocalizedString(@"Recibirás un mensaje de correo electrónico para recuperar tu contraseña" , ) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag=1000;
            [alert show];
        }
    }
    
    else if([senderValue isEqualToString:@"firma"] || [senderValue isEqualToString:@"facebookFirma"])
    {
        NSDictionary *meta=[APIConnection getDictionaryJSON:json withKey:@"meta"];
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        
        if(![[APIConnection getStringJSON:meta withKey:@"code" widthDefValue:@""] isEqualToString:@"200"])
        {
            [APIConnection muestraErrorFirma:[APIConnection getStringJSON:meta withKey:@"detail" widthDefValue:@""]];
            [APIConnection limpiaSesion];
        }
        else if(response)
        {
            
            token = [APIConnection getStringJSON:response withKey:@"token" widthDefValue:@""];
            uid = [APIConnection getStringJSON:response withKey:@"uid" widthDefValue:@"0"];
            tokenCMS = [APIConnection getStringJSON:response withKey:@"tokenCMS" widthDefValue:@"0"];
            tokenName = [APIConnection getStringJSON:response withKey:@"name" widthDefValue:@"0"];
            tokenImagen = [APIConnection getStringJSON:response withKey:@"image" widthDefValue:@"0"];
            tokenTeam = [APIConnection getStringJSON:response withKey:@"team" widthDefValue:@"0"];
            tokenMember = [APIConnection getStringJSON:response withKey:@"member" widthDefValue:@"0"];
            tokenManager = [APIConnection getStringJSON:response withKey:@"manager" widthDefValue:@"0"];
            long ifuncion = [APIConnection getIntJSON:response withKey:@"ifuncion" widthDefValue:@"0"];
            
            if(![token isEqualToString:@""])
            {
                [self saveConfig:@"token" withValue1:token];
                [self saveConfig:@"uid" withValue1:uid];
                [self saveConfig:@"tokenCMS" withValue1:tokenCMS];
                [self saveConfig:@"tokenName" withValue1:tokenName];
                [self saveConfig:@"tokenImagen" withValue1:tokenImagen];
                [self saveConfig:@"refresh_token" withValue1:[APIConnection getStringJSON:response withKey:@"refreshToken" widthDefValue:@""]];
                [self saveConfig:@"tokenTeam" withValue1:tokenTeam];
                [self saveConfig:@"tokenMember" withValue1:tokenMember];
                [self saveConfig:@"tokenManager" withValue1:tokenManager];
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Entraste correctamente",)];
                recienFirmado=true;
                
                long managerNotificaciones=0; // no es responsable para notificaciones
                if(ifuncion==1)
                    managerNotificaciones=1; // es responsable para notificaciones
                                
                NSMutableDictionary *losTags = [[NSMutableDictionary alloc] init];
                [losTags setObject:[NSString stringWithFormat:@"%d",[uid intValue]] forKey:@"uid"];
                [losTags setObject:[NSString stringWithFormat:@"%d",[tokenTeam intValue]] forKey:@"tokenTeam"];
                [losTags setObject:[NSString stringWithFormat:@"%d",[tokenMember intValue]] forKey:@"tokenMember"];
                [losTags setObject:[NSString stringWithFormat:@"%ld",managerNotificaciones] forKey:@"tokenManager"];
                [losTags setObject:@"1" forKey:@"refdiaria"];
                [losTags setObject:@"1" forKey:@"notificaciones"];
                
                [OneSignal sendTags:losTags];

                stringToPass=[APIConnection getStringJSON:response withKey:@"completed" widthDefValue:@"1"];
                
                stringToPass2=@"recienFirmado";
                [self dismissViewControllerAnimated:true completion:^{
                    //NSLog(@"operacion %@",self.operacion);
                    [self.delegate firmaRegreso:self.operacion];
                }];
            }
        }
        else
        {
            [APIConnection limpiaSesion];
            [APIConnection muestraErrorFirma:NSLocalizedString(@"Error desconocido", )];

        }
        
       
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    saliendo=true;
    idbote=@"";
    [self.vista1Datos setBackgroundColor:[UIColor clearColor]];
    entroFBLogin=false;
    
    APIConnection = [[iwantooAPIConnection alloc] init];
    APIConnection.delegationListener = self;
    
    
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(ocultaTeclado)];
    singleFingerTap.cancelsTouchesInView = YES;
    [self.view addGestureRecognizer:singleFingerTap];
    self.email.delegate=self;
    self.password.delegate=self;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.posicion.constant=195;
    
    [UIView animateWithDuration:1 animations:^{
        [self.view setNeedsLayout];
    }];
}
-(void)ocultaTeclado
{
    [self.email resignFirstResponder];
    [self.password resignFirstResponder];
    self.posicion.constant=0;
    [UIView animateWithDuration:1 animations:^{
        [self.view setNeedsLayout];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cerrar:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)entrar:(id)sender {
    [self firma];
}

-(void)firma
{
    if([self.email.text isEqual:@""])
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Proporciona tu email",)];
    else if([self.password.text isEqual:@""])
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Proporciona tu contraseña", )];
    else
    {
         [APIConnection connectAPI:[NSString stringWithFormat:@"users.handler.php?action=logInUser&email=%@&pass=%@",self.email.text,self.password.text] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:true withSender:@"firma" willContinueLoading:false];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.email)
        [self.password becomeFirstResponder];
    else if (theTextField == self.password)
        [self firma];
    
    return YES;
}



- (IBAction)registro:(id)sender {
    /*self.email2.text=@"imagen@imagencentral.com ";
    self.nombreusuario2.text=@"memin";
    self.pass3.text=@"adri";
    self.pass2.text=@"adri";
    */
    [self ocultaTeclado];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.vista1Datos.alpha=0;
        self.olvidemicontrasena.alpha=0;

    } completion:^(BOOL finished) {
        [self.vista1Datos setHidden:true];
        [self.olvidemicontrasena setHidden:true];
    }];
}


- (IBAction)registroRegresar:(id)sender {
    [self ocultaTeclado];
    [self.vista1Datos setHidden:false];
    [self.olvidemicontrasena setHidden:false];
    [UIView animateWithDuration:0.5 animations:^{
        self.vista1Datos.alpha=1;
        self.olvidemicontrasena.alpha=1;
    } completion:^(BOOL finished) {
    }];

}

- (IBAction)recuperarContrasena:(id)sender {
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Proporciona tu dirección de correo electrónico" , ) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
    alert.tag=1001;
    [alert show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1000)
    {
        [self registroRegresar:nil];
    }
    else if (alertView.tag==1001){
        NSString *inputText = [[alertView textFieldAtIndex:0] text];
        if([inputText length]>0)
        {
            [APIConnection connectAPI:[NSString stringWithFormat:@"users.handler.php?action=sendForgotPassEmail&email=%@",inputText] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:true withSender:@"recuperarContrasena" willContinueLoading:false];
        }
        
       
    }
    
}


-(BOOL)prefersStatusBarHidden
{
    return true;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (IBAction)tapEnTexto:(id)sender {
    int pos=80;
    if(self.view.frame.size.height<=480)
        pos=160;
    self.alineacionVistaDatos1.constant=pos;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}


- (IBAction)abreAviso:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
    vistawebViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"vistaweb"];
    vc.modo=@"url";
    vc.url=@"http://www.vitamexico.org/index.php?modo=aviso";
    [self presentViewController:vc animated:true completion:nil];
}


@end



