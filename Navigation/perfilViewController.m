//
//  perfilViewController.m
//  cut
//
//  Created by Guillermo on 30/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "perfilViewController.h"
#import <sqlite3.h>
#import "AppDelegate.h"
#import <OneSignal/OneSignal.h>

@interface perfilViewController ()

@end

@implementation perfilViewController

-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    if([senderValue isEqualToString:@"leer"])
    {
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        NSMutableArray *escolaridadesTempo=[[NSMutableArray alloc] init];
        
        escolaridadesTempo=[APIConnection getArrayJSON:response withKey:@"escolaridades"];
        [escolaridades addObjectsFromArray:escolaridadesTempo];
        [self.escolaridad reloadAllComponents];
        
        NSDictionary *usuario=[APIConnection getDictionaryJSON:response withKey:@"usuario"];
        self.nombre.text=[APIConnection getStringJSON:usuario withKey:@"nombreusuario" widthDefValue:@""];
        self.email.text=[APIConnection getStringJSON:usuario withKey:@"emailusuario" widthDefValue:@""];
        self.celular.text=[APIConnection getStringJSON:usuario withKey:@"celularusuario" widthDefValue:@""];
        self.telefono.text=[APIConnection getStringJSON:usuario withKey:@"teloficinausuario" widthDefValue:@""];
        self.profesion.text=[APIConnection getStringJSON:usuario withKey:@"profesionusuario" widthDefValue:@""];
       
        long iescolaridadusuario=[APIConnection getIntJSON:usuario withKey:@"iescolaridadusuario" widthDefValue:@"0"];
        
        for(long i=0; i<=[escolaridades count]-1; i++)
        {
            NSDictionary *dic=[escolaridades objectAtIndex:i];
            long idt=[APIConnection getIntJSON:dic withKey:@"id" widthDefValue:@"0"];
            if(iescolaridadusuario==idt)
            {
                [self.escolaridad selectRow:i inComponent:0 animated:true];
            }
            
        }
        NSString *nacimientousuario=[APIConnection getStringJSON:usuario withKey:@"nacimientousuario" widthDefValue:@""];
        NSDate *date = [[NSDate alloc] init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        if(![nacimientousuario isEqualToString:@""] && ![nacimientousuario isEqualToString:@"0000-00-00"])
           date = [dateFormatter dateFromString:nacimientousuario];
        
        [self.nacimiento setDate:date];
        
    }
    else if([senderValue isEqualToString:@"guardar"])
    {
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        NSLog(@"%@",response);
        NSString *error=[APIConnection getStringJSON:response withKey:@"error" widthDefValue:@""];
        if([error isEqualToString:@""])
        {
            [self dismissViewControllerAnimated:true completion:NULL];
        }
        else
        {
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:@"Error"
                                         message:error
                                         preferredStyle:UIAlertControllerStyleAlert];
            
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
}
- (AppDelegate*)appDelegate {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (IBAction)activaNotificaciones:(id)sender {
    if(self.notificaciones.on){
        self.reflexion.on=true;
        self.actividades.on=true;
        self.encuentros.on=true;
       NSMutableDictionary *losTags = [[NSMutableDictionary alloc] init];
        [losTags setObject:@"1" forKey:@"refdiaria"];
        [losTags setObject:@"1" forKey:@"notificaciones"];
        self.reflexion.enabled = true;
        [OneSignal sendTags:losTags];
        }
    else
    {
        self.reflexion.on=false;
        self.actividades.on=false;
        self.encuentros.on=false;
    
        
        NSMutableDictionary *losTags = [[NSMutableDictionary alloc] init];
        [losTags setObject:@"0" forKey:@"refdiaria"];
        [losTags setObject:@"0" forKey:@"notificaciones"];
        self.reflexion.enabled = false;
        [OneSignal sendTags:losTags];
    }
}
- (IBAction)activaRelexion:(id)sender {
   
}
- (void)viewDidLoad {
    self.escolaridad.delegate=self;
    self.escolaridad.dataSource=self;
    escolaridades=[[NSMutableArray alloc] init];
    [escolaridades addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                              @"",@"escolaridad",
                              @"0",@"id", nil]];
    [self.escolaridad reloadAllComponents];
     [super viewDidLoad];
    [self.headerPrincipal inicializa:@"Mis preferencias" conSubtitulo:@"" conBotonBack:false conBuscador:false conTipoBotonHome:@"home"];
    
    self.headerPrincipal.delegate=self;
    
    //[self.nombreUsuario becomeFirstResponder];
    
    self.ventanaActual=@"perfil";
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"perfil"
                                                          action:@"abre"
                                                           label:@""
                                                           value:nil] build]];
    
    self.notificaciones.on = [[tagsDictionary objectForKey:@"notificaciones"] boolValue];
    self.reflexion.on = [[tagsDictionary objectForKey:@"refdiaria"] boolValue];
    
    if(self.notificaciones.on){
        self.reflexion.enabled = true;
    }
    else
    {
        self.reflexion.enabled = false;
    }
    
    [APIConnection connectAPI:@"perfil.php?paso=leer" withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"leer" willContinueLoading:false];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)anterior:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [OneSignal getTags:^(NSDictionary* tags) {
        tagsDictionary = tags;
        
        
    }];
    
}
- (IBAction)guardar:(id)sender {
    if([self.nombre.text isEqualToString:@""])
        [SVProgressHUD showErrorWithStatus:@"Escribe tu nombre"];
    else if([self.email.text isEqualToString:@""])
        [SVProgressHUD showErrorWithStatus:@"Escribe tu email"];
    else if([self.profesion.text isEqualToString:@""])
        [SVProgressHUD showErrorWithStatus:@"Escribe tu profesión"];
    else if([self.celular.text isEqualToString:@""])
           [SVProgressHUD showErrorWithStatus:@"Escribe tu celular"];
    else if(![self.contrasena.text isEqualToString:@""] && self.contrasena.text.length<4)
        [SVProgressHUD showErrorWithStatus:@"La contraseña debe tener al menos 4 caracteres"];
    else if(![self.contrasena.text isEqualToString:@""] && ![self.contrasena.text isEqualToString:self.confirmar.text])
        [SVProgressHUD showErrorWithStatus:@"La contraseña y su confirmación no coinciden"];
    else
    {
        NSString *nacimiento=@"";
        
        NSDate *date = self.nacimiento.date;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        nacimiento = [dateFormatter stringFromDate:date];
        
        long cual=[self.escolaridad selectedRowInComponent:0];
        NSDictionary *elemento=[escolaridades objectAtIndex:cual];
        NSString *escolaridad=[APIConnection getStringJSON:elemento withKey:@"id" widthDefValue:@""];
        
        NSString *cadena=[NSString stringWithFormat:@"nombre=%@&email=%@&contrasena=%@&celular=%@&telefono=%@&profesion=%@&nacimiento=%@&escolaridad=%@",
                          self.nombre.text,
                          self.email.text,
                          self.contrasena.text,
                          self.celular.text,
                          self.telefono.text,
                          self.profesion.text,
                          nacimiento,escolaridad];
        [APIConnection connectAPI:@"perfil.php?paso=guardar" withData:cadena withMethod:@"POST" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"guardar" willContinueLoading:false];
        NSLog(@"%@",cadena);
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tap:NULL];
}

- (IBAction)cerrar:(id)sender {
    [self dismissViewControllerAnimated:true completion:NULL];
}

- (IBAction)tap:(id)sender {
    [self.nombre resignFirstResponder];
    [self.email resignFirstResponder];
    [self.contrasena resignFirstResponder];
    [self.confirmar resignFirstResponder];
    [self.celular resignFirstResponder];
    [self.telefono resignFirstResponder];
    [self.profesion resignFirstResponder];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [escolaridades count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *elemento=[escolaridades objectAtIndex:row];
    return [APIConnection getStringJSON:elemento withKey:@"escolaridad" widthDefValue:@""];
    
}
@end

