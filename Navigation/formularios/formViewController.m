//
//  formViewController.m
//  otroEjemplo
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 13/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import "formViewController.h"
#import "formTextFieldObject.h"
#import "SVProgressHUD.h"
#import "fontMuseo.h"
#import "UIImageView+AFNetworking.h"
#import <sqlite3.h>
@interface formViewController ()

@end

@implementation formViewController
@synthesize fecha = _fecha;
@synthesize tableview = _tableview;
@synthesize selector = _selector;
@synthesize enhancedKeyboard = _enhancedKeyboard;
@synthesize formItems= _formItems;
@synthesize vistaTecladoVacio = _vistaTecladoVacio;
@synthesize formulario = _formulario;
@synthesize operacion = _operacion;
@synthesize remoto = _remoto;
@synthesize titulo = _titulo;
@synthesize idreal = _idreal;
@synthesize delegate = _delegate;
@synthesize formularioArchivo = _formularioArchivo;
@synthesize location = _location;
@synthesize variablesExtrasGuardar=_variablesExtrasGuardar;
@synthesize cp = _cp;
@synthesize cerrarButton = _cerrarButton;
@synthesize guardarButton = _guardarButton;
#import "color.h"
#import "globales.h"
#import "databaseOperations.h"

-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    if([senderValue isEqualToString:@"leerFormulario"])
    {
        [self leerFormulario:json];
    }
    else if([senderValue isEqualToString:@"leerRegistro"])
    {
        NSMutableArray *arregloTemporal = [APIConnection getArrayJSON:json withKey:@"datos"];
        if([arregloTemporal count]>0) // encontramos un registro
        {
            for(id elemento in arregloTemporal)
                indiceValores = [NSMutableDictionary dictionaryWithDictionary:elemento];
            [self arrancaFormulario];
        }
        else
        {
            if([errorValue isEqualToString:@""])
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Registro no encontrado", )];
            else
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(errorValue, )];
            [self dismissViewControllerAnimated:true completion:^{ }];
            cerrarPorError=true;
        }
    }
    else if([senderValue isEqualToString:@"guardarRegistro"]) // ya guardamos
    {
        NSDictionary *meta=[APIConnection getDictionaryJSON:json withKey:@"meta"];
        NSString *idreal=[APIConnection getStringJSON:meta withKey:@"idreal" widthDefValue:@"0"];
        NSString *mensaje=[APIConnection getStringJSON:meta withKey:@"mensaje" widthDefValue:@"0"];
        NSString *modoAviso=[APIConnection getStringJSON:meta withKey:@"modoAviso" widthDefValue:@""];
        if(![idreal isEqual:@"0"])
        {
            if([modoAviso isEqualToString:@"alert"])
            {
                UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso" message:mensaje delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                [alerta show];
            }
            
            [self.delegate formRegresaGuardando:idreal];
            [self dismissViewControllerAnimated:true completion:^{
                if(![modoAviso isEqualToString:@"alert"])
                    [SVProgressHUD showSuccessWithStatus:mensaje];
            }];
        }
        else
            [SVProgressHUD showErrorWithStatus:@"Error"];
    }
    else if([senderValue isEqualToString:@"subirFoto_fotomamausuario"] || [senderValue isEqualToString:@"subirFoto_fotopapausuario"])
    {
        [self leerRegistro];
    }
    else if([senderValue isEqualToString:@"leeCP"])
    {
        NSMutableArray *arregloTemporal = [APIConnection getArrayJSON:json withKey:@"datos"];
        if([arregloTemporal count]>0) // encontramos un registro
        {
            for(id elemento in arregloTemporal)
                indiceValores = [NSMutableDictionary dictionaryWithDictionary:elemento];
            [self arrancaFormulario];
        }
       
    }

    
}

-(void)viewDidAppear:(BOOL)animated
{
    if(cerrarPorError) // quizás tengamos que cerrar si fue demasiado rápido la carga con error.
    {
        [self dismissViewControllerAnimated:true completion:^{ }];
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:true];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(NSDictionary*)dictionaryWithContentsOfJSONString:(NSString*)fileLocation{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:[fileLocation pathExtension]];
    
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    
    
    NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(float)devuelveAltura:(NSString *)cadena conAncho:(int)ancho confuente:(NSString *)fuente conTamano:(float)tamano
{
    CGSize constraintSize;
    CGSize labelSize;
    constraintSize.width = ancho; // the width for calculius
    constraintSize.height = MAXFLOAT;
    
    /*
    labelSize = [cadena sizeWithFont:[UIFont fontWithName:fuente size:tamano]
                                                 constrainedToSize:constraintSize
                                                     lineBreakMode:NSLineBreakByWordWrapping];
    */
    CGRect labelRect = [cadena boundingRectWithSize:constraintSize
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName: [UIFont fontWithName:fuente size:tamano]}
                                                          context:nil];
    labelSize=CGSizeMake(ceilf(labelRect.size.width), ceilf(labelRect.size.height));
    
    return labelSize.height;
}

-(void)leerRegistro
{
    [APIConnection connectAPI:[NSString stringWithFormat:@"iOSForms/consultaRegistroForm.php?tablaIT=%@&formularioArchivo=%@&idreal=%@&campos=%@",self.formulario,self.formularioArchivo,self.idreal,camposConsulta] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:true withSender:@"leerRegistro" willContinueLoading:false];
}
-(void)leerFormulario:(NSDictionary *)datosLeidos
{
    camposConsulta=@"";
    NSMutableDictionary *diccionario;
    // convertimos todos los elementos a arreglos y diccionarios
    NSMutableArray *arregloTemporal = [[NSMutableArray alloc] init];
    arregloTemporal = [APIConnection getArrayJSON:datosLeidos withKey:@"campos"];
    for(id elemento in arregloTemporal)
    {
        diccionario = [NSMutableDictionary dictionaryWithDictionary:elemento];
        [indice addObject:diccionario];
        
        if(![camposConsulta isEqualToString:@""])
            camposConsulta = [camposConsulta stringByAppendingString:@","];
        camposConsulta = [camposConsulta stringByAppendingString:[diccionario objectForKey:@"nombre"]];
    }
    
    arregloTemporal = [APIConnection getArrayJSON:datosLeidos withKey:@"grupos"];
    for(id elemento in arregloTemporal)
    {
        diccionario = [NSMutableDictionary dictionaryWithDictionary:elemento];
        [diccionario setObject:[NSNumber numberWithFloat:[self devuelveAltura:[diccionario objectForKey:@"titulo"] conAncho:self.view.frame.size.width-20 confuente:fuenteEspecial conTamano:14]+10] forKey:@"altura"];
            
        [indiceGrupos addObject:diccionario];
    }
    
    indiceCamposITs = [APIConnection getArrayJSON:datosLeidos withKey:@"camposITs"];
    indiceEquivalenciasITs = [APIConnection getArrayJSON:datosLeidos withKey:@"equivalenciasITs"];
    indiceEncadenadosITs = [APIConnection getArrayJSON:datosLeidos withKey:@"encadenadosITs"];
    indiceEncadenadosRelacionadosITs = [APIConnection getArrayJSON:datosLeidos withKey:@"encadenadosRelacionadosITs"];
    
    arregloTemporal = [APIConnection getArrayJSON:datosLeidos withKey:@"valores"];
    for(id elemento in arregloTemporal)
        diccionarioValoresDefault = [NSMutableDictionary dictionaryWithDictionary:elemento];
    
    
    // vamos a ajustar los valores default par quitar HOY y NONE
    NSArray *leerValoresDefault = [[NSArray alloc] init];
    NSString *cadenaEvalua,*cadenaEvaluaNueva;
    leerValoresDefault = [diccionarioValoresDefault allKeys];
    // sacampos la fecha
    
    for (int i=0; i<=[leerValoresDefault count]-1; i++)
    {
        cadenaEvalua = [diccionarioValoresDefault objectForKey:[leerValoresDefault objectAtIndex:i]];
        cadenaEvaluaNueva = cadenaEvalua;
        if([cadenaEvalua isEqualToString:@"HOY"])
            cadenaEvaluaNueva = [self dameHoy];
        else if([cadenaEvalua isEqualToString:@"NONE"])
            cadenaEvaluaNueva = @"0";
        
        if(![cadenaEvaluaNueva isEqual:cadenaEvalua])
            [diccionarioValoresDefault setObject:cadenaEvaluaNueva forKey:[leerValoresDefault objectAtIndex:i]];
    }
    
    // vamos a agregar
    if([self.operacion isEqual:@"agregar"])
    {
        indiceValores = [NSMutableDictionary dictionaryWithDictionary:diccionarioValoresDefault];
        if([self.formularioArchivo isEqualToString:@"alertasAgregar"] && ![self.cp isEqualToString:@""]  && ![self.cp isEqual:[NSNull null]])
            [self leeDatosCP];
        else [self arrancaFormulario];
    }
    else // vamos a editar
    {
        if(self.remoto) // si es remoto leamos el registro remotamente
        {
            [self leerRegistro];
        }
        else
        {
            NSString *sql_extra = [NSString stringWithFormat:@"id=%@",self.idreal];
            NSMutableArray *arregloTemporal = [self consultaDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys:sql_extra,@"sql_extra", nil] withTabla:self.formulario];
            if([arregloTemporal count]>0) // encontramos un registro
            {
                for(id elemento in arregloTemporal)
                    indiceValores = [NSMutableDictionary dictionaryWithDictionary:elemento];
                [self arrancaFormulario];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Registro no encontrado", )];
                [self dismissViewControllerAnimated:true completion:^{ }];
                cerrarPorError=true;
            }
            
            
            
            // hagamos aca la consulta local
            // considerar aqui si no lo encontron
        }
    }
    
    pieFormulario = [APIConnection getStringJSON:datosLeidos withKey:@"instruccionesabajo" widthDefValue:@""];
    cabezaFormulario = [APIConnection getStringJSON:datosLeidos withKey:@"instruccionesarriba" widthDefValue:@""];
    
    if((![self.titulo isEqualToString:@""] && ![self.titulo isEqual:[NSNull null]]) || ![cabezaFormulario isEqualToString:@""])
    {
        float extraAltura = 0;
        extraAltura=[self devuelveAltura:cabezaFormulario conAncho:self.view.frame.size.width-20 confuente:fuenteEspecial conTamano:16];
        if(extraAltura>0) extraAltura+=5;
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 30+extraAltura)];
        [headerView setBackgroundColor:[UIColor clearColor]];
        fontMuseo *labelView = [[fontMuseo alloc] initWithFrame:CGRectMake(10, 8, self.view.frame.size.width-20, 30)];
        [labelView fontPaint:self.titulo withFont:fuenteEspecial withSize:20 withColor:@"#000000"];
        [labelView setBackgroundColor:[UIColor clearColor]];
        [labelView setTextAlignment:NSTextAlignmentCenter];
        [headerView addSubview:labelView];
        
        if(![cabezaFormulario isEqualToString:@""])
        {
            fontMuseo *cabezaFormularioLabel = [[fontMuseo alloc] initWithFrame:CGRectMake(10, 35, self.view.frame.size.width-20, extraAltura+20-5)];
            [cabezaFormularioLabel fontPaint:cabezaFormulario withFont:fuenteEspecial withSize:16 withColor:@"#333333"];
            cabezaFormularioLabel.numberOfLines=0;
            [cabezaFormularioLabel setBackgroundColor:[UIColor clearColor]];
            [headerView addSubview:cabezaFormularioLabel];
            [cabezaFormularioLabel setTextAlignment:NSTextAlignmentCenter];

        }
        self.tableview.tableHeaderView = headerView;
    }
    
    if(![pieFormulario isEqualToString:@""])
    {
        float extraAltura = 0;
        extraAltura=[self devuelveAltura:pieFormulario conAncho:self.view.frame.size.width-20 confuente:fuenteEspecial conTamano:14];
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, extraAltura+5)];
        [footerView setBackgroundColor:[UIColor clearColor]];

        fontMuseo *pieFormularioLabel = [[fontMuseo alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, extraAltura)];
        [pieFormularioLabel fontPaint:pieFormulario withFont:fuenteEspecial withSize:14 withColor:@"#6A1E74"];
        [pieFormularioLabel setBackgroundColor:[UIColor clearColor]];
        pieFormularioLabel.numberOfLines=0;
        [footerView addSubview:pieFormularioLabel];

        
        self.tableview.tableFooterView=footerView;
    }
}


-(void)arrancaFormulario
{
    NSArray *leerValores = [[NSArray alloc] init];
    leerValores = [indiceValores allKeys];    
    // limpiaremos los valores que mostraremos
    for (int i=0; i<=[leerValores count]-1; i++)
    {
        NSString *tempo=[APIConnection getStringJSON:indiceValores withKey:[leerValores objectAtIndex:i] widthDefValue:@""];
        [indiceValores setObject:tempo forKey:[leerValores objectAtIndex:i]];
    }
    
    self.formItems = [[NSMutableArray alloc] init];
    for (int i=0; i<[indice count]; i++)
    {
        formTextFieldObject *item = [[formTextFieldObject alloc] init];
        [self.formItems insertObject:item atIndex:i];
    }
    [self.tableview reloadData];
}


- (void)viewDidLoad
{
    
    /*PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setObject:@123 forKey:@"idUsuario"];
    [installation saveInBackground];*/
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    
    cerrarPorError = false;
    [self inicializa];
 
    APIConnection = [[iwantooAPIConnection alloc] init];
    APIConnection.delegationListener = self;
    
    
    // leamos el diccionario del formulario
    if(self.remoto) // es remoto
    {
        [APIConnection connectAPI:[NSString stringWithFormat:@"iOSForms/%@.php?",self.formularioArchivo] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:true withSender:@"leerFormulario" willContinueLoading:FALSE];
    }
    else // es local
    {
        NSString *cadena=[NSString stringWithFormat:@"%@.json",self.formularioArchivo];
        
       NSDictionary *datosLeidos = [NSDictionary dictionaryWithDictionary: [self dictionaryWithContentsOfJSONString: NSLocalizedString(cadena,)]];
        [self leerFormulario:datosLeidos];
    }
    
    if(self.location) // habra geolocalizacion
        [self iniciaGeolocalizacion];
    
    [self.guardarButton setTitle:NSLocalizedString(@"Guardar", ) forState:UIControlStateNormal];
    [self.cerrarButton setTitle:NSLocalizedString(@"Cerrar", ) forState:UIControlStateNormal];
    [self.guardarButton setTitle:NSLocalizedString(@"Guardar", ) forState:UIControlStateHighlighted];
    [self.cerrarButton setTitle:NSLocalizedString(@"Cerrar", ) forState:UIControlStateHighlighted];
    
    [self.selector removeFromSuperview];
    [self.fecha removeFromSuperview];
    [self.vistaTecladoVacio removeFromSuperview];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(NSString *)dameHoy
{
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc] init];
    return [timeFormat stringFromDate:now];
}

- (IBAction)cerrar:(id)sender {
    if ([self.delegate respondsToSelector:@selector(formRegresaCerrar)])
        [self.delegate formRegresaCerrar];
    
    [self dismissViewControllerAnimated:true completion:^{ }];
}

- (IBAction)guardar:(id)sender {
    [campoActual resignFirstResponder];
    [self valida];
}

static inline BOOL validateEmail(NSString *candidate) {
    
    NSString*emailRegex =@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate*emailTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return[emailTest evaluateWithObject:candidate];
}

-(void)valida
{
    
    NSMutableDictionary *diccionario;
    NSString *real,*tipo,*subtipo;
    int requerido,realInt;
    float realFloat,minimo,maximo;
    BOOL correcto;
    NSString *mensajeError,*campo;
    
    correcto = true;
    for(int i=0; i<=[indice count]-1; i++)
    {
        mensajeError = @"";
        diccionario = [indice objectAtIndex:i];
        campo = [diccionario objectForKey:@"nombre"];
        minimo = [self getFloatJSON2:diccionario withKey:@"minimo" widthDefValue:@"0"];
        maximo = [self getFloatJSON2:diccionario withKey:@"maximo" widthDefValue:@"0"];
        requerido = [self getIntJSON2:diccionario withKey:@"requerido" widthDefValue:@"0"];
        tipo = [self getStringJSON2:diccionario withKey:@"tipo" widthDefValue:@""];
        subtipo = [self getStringJSON2:diccionario withKey:@"subtipo" widthDefValue:@""];
        
        real = [self getStringJSON2:indiceValores withKey:campo widthDefValue:@""];
        realInt = [self getIntJSON2:indiceValores withKey:campo widthDefValue:@"0"];
        realFloat = [self getFloatJSON2:indiceValores withKey:campo widthDefValue:@"0"];
        
        if(requerido == 1)
        {
            if([tipo isEqual:@"A"] || [tipo isEqual:@"F"] || [tipo isEqual:@"I"] || [tipo isEqual:@"AO"] || [tipo isEqual:@"M"] || [tipo isEqual:@"MF"])
            {
                if([real isEqual:@""])
                    mensajeError = NSLocalizedString(@"Campo requerido",);
            }
            else if([tipo isEqual:@"AI"])
            {
                if([[indiceValores objectForKey:campo] isEqualToString:@""] || [[indiceValores objectForKey:campo] isEqual:[NSNull null]])
                    mensajeError = NSLocalizedString(@"Campo requerido",);
            }
            else
            {
                if(realInt == 0)
                    mensajeError = NSLocalizedString(@"Campo requerido",);
            }
            
        }
        
        
        if([mensajeError isEqual:@""]) // sigue adelante
        {
            if([tipo isEqual:@"A"] || [tipo isEqual:@"M"] || [tipo isEqual:@"MF"]) // es cadena, revisemos longitud incorrecta
            {
                
                if(minimo != maximo)
                {
                    if([real length]<minimo)
                        mensajeError = [NSString stringWithFormat:@"Mínimo %.0f caracteres",round(minimo)];
                    else if([real length]>maximo)
                        mensajeError = [NSString stringWithFormat:@"Máximo %.0f caracteres",round(maximo)];
                }
                    
                else if([subtipo isEqualToString:@"email"] && !validateEmail(real))
                    mensajeError = NSLocalizedString(@"Email inválido",);
            }
            else if([tipo isEqual:@"I"] || [tipo isEqual:@"F"])
            {
                if(minimo != maximo && (realFloat<minimo || realFloat>maximo))
                    mensajeError = NSLocalizedString(@"Fuera de rango",);
            }
        }
        
        [self generaError:mensajeError conCual:i];
        if(![mensajeError isEqual:@""]) // ocurrio algun error
            correcto=false;
        
        
    }
    if(!correcto)
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Existen errores", )];
    else
    {
        // aqui vamos a guardar, hay que ver que pasa
        
        // generamos la cadena de valores que vamos a guardar
        NSArray *campos = [camposConsulta componentsSeparatedByString:@","];
        NSString *cadenasalvar=@"",*cadenaTemporal,*cadenaSalvarCampos=@"",*cadenaSalvarValores=@"",*cadenaActualizar=@"",*coma;
        if([campos count]>0)
        {
            for(int i=0; i<[campos count]; i++)
            {
                cadenaTemporal = [indiceValores objectForKey:[campos objectAtIndex:i]];               
                cadenasalvar = [NSString stringWithFormat:@"%@&VAR_%@=%@",cadenasalvar,[campos objectAtIndex:i],cadenaTemporal];
                coma=@"";
                if(![cadenaSalvarCampos isEqualToString:@""]) coma=@",";
                cadenaSalvarCampos = [NSString stringWithFormat:@"%@%@%@",cadenaSalvarCampos,coma,[campos objectAtIndex:i]];
                cadenaSalvarValores = [NSString stringWithFormat:@"%@%@'%@'",cadenaSalvarValores,coma,cadenaTemporal];
                cadenaActualizar = [NSString stringWithFormat:@"%@%@%@='%@'",cadenaActualizar,coma,[campos objectAtIndex:i],cadenaTemporal];
                
                /*if(![imagenGuardarLocal isEqualToString:@""] && ![campoImagenGuardaLocal isEqualToString:@""])
                {
                    coma=@"";
                    if(![cadenaSalvarCampos isEqualToString:@""]) coma=@",";

                    cadenaSalvarCampos = [NSString stringWithFormat:@"%@%@%@",cadenaSalvarCampos,coma,campoImagenGuardaLocal];
                    cadenaSalvarValores = [NSString stringWithFormat:@"%@%@'%@'",cadenaSalvarValores,coma,imagenGuardarLocal];
                    cadenaActualizar = [NSString stringWithFormat:@"%@%@%@='%@'",cadenaActualizar,coma,campoImagenGuardaLocal,imagenGuardarLocal];

                }*/
            }
        }
        
        if(self.remoto)
        {
            NSString *geolocalizacion=@"";
            if(self.location)
                geolocalizacion = [NSString stringWithFormat:@"&latitud=%f&longitud=%f&",currentLat,currentLon];
            
            stringToPass=campoSubirFoto;
            [APIConnection connectAPI:@"iOSForms/guardaRegistroForm.php?" withData:[NSString stringWithFormat:@"operacion=%@&tablaIT=%@&formularioArchivo=%@&idreal=%@&campos=%@%@%@",self.operacion,self.formulario,self.formularioArchivo,self.idreal,cadenasalvar,geolocalizacion,self.variablesExtrasGuardar] withMethod:@"POST" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"guardarRegistro" willContinueLoading:false];
        }
        else
        {
            BOOL todoBien=false;
            NSString *sql=@"";
            if(![self.operacion isEqualToString:@"agregar"])
            {                
                sql = [NSString stringWithFormat:@"UPDATE %@ set %@ where id=%@",
                                 self.formulario,cadenaActualizar,self.idreal];
                todoBien=[self databaseUpdate: sql];
            }
            else
            {
                sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",
                       self.formulario,cadenaSalvarCampos,cadenaSalvarValores];
                
                self.idreal = [self databaseInsert: sql];
                if(![self.idreal isEqualToString:@""])
                {
                    todoBien=true;
                    if(![self.variablesExtrasGuardar isEqualToString:@""])
                    {
                        sql = [NSString stringWithFormat:@"UPDATE %@ set %@ where id=%@",
                           self.formulario,self.variablesExtrasGuardar,self.idreal];
                        [self databaseUpdate:sql];
                    }
                }
            }
            
           if(todoBien)
           {
               
               
               [SVProgressHUD showSuccessWithStatus:@"Guardado"];
               [self.delegate formRegresaGuardando:self.idreal];
               [self dismissViewControllerAnimated:true completion:^{ }];
           }
           else [SVProgressHUD showErrorWithStatus:@"Ocurrió un error"];
               
            // aqui pondremos la rutina que guarda local
            
        }
        
    }
    
    [self.tableview reloadData];
}




-(void)inicializa
{
    indice = [[NSMutableArray alloc] init];
    indiceGrupos = [[NSMutableArray alloc] init];
    selectorTextos = [[NSMutableArray alloc] init];
    selectorValores = [[NSMutableArray alloc] init];
    indiceCamposITs = [[NSMutableArray alloc] init];
    indiceEquivalenciasITs = [[NSMutableArray alloc] init];
    indiceEncadenadosITs = [[NSMutableArray alloc] init];
    indiceEncadenadosRelacionadosITs = [[NSMutableArray alloc] init];
    
    [self.fecha setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,216)];
    [self.selector setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,216)];
    [self.vistaTecladoVacio setFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width,216)];
    [self registerForKeyboardNotifications];
    tecladoAbierto = false;
    [self.tableview setBackgroundView: nil];
    
    self.enhancedKeyboard = [[formKSEnhancedKeyboard alloc] init];
    self.enhancedKeyboard.delegate = self;
    
    CGRect  marco = self.tableview.frame;
    marco.size.height = screenHeight-49;
    marco.origin.y=49;
    self.tableview.frame=marco;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [indiceGrupos count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSDictionary *grupoActual = [indiceGrupos objectAtIndex:section];
    return [[grupoActual objectForKey:@"cuantos"] intValue];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *grupoActual = [indiceGrupos objectAtIndex:section];
    UIView *vista = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, [[grupoActual objectForKey:@"altura"] floatValue])];
    [vista setBackgroundColor:[UIColor clearColor]];
    if(![[grupoActual objectForKey:@"titulo"] isEqualToString:@""])
    {        
        fontMuseo *titulo = [[fontMuseo alloc] initWithFrame:CGRectMake(10, 2, self.view.frame.size.width-20, [[grupoActual objectForKey:@"altura"] floatValue])];
        [titulo fontPaint:[grupoActual objectForKey:@"titulo"] withFont:fuenteEspecial withSize:14 withColor:cGris80];
        titulo.numberOfLines=0;
        [vista addSubview:titulo];
    }
    return vista;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSDictionary *grupoActual = [indiceGrupos objectAtIndex:section];
    return [[grupoActual objectForKey:@"altura"] floatValue];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *grupoActual = [indiceGrupos objectAtIndex:indexPath.section];
    long cualElemento = [[grupoActual objectForKey:@"empieza"] intValue] + indexPath.row;
    NSMutableDictionary *elementoActual = [indice objectAtIndex:cualElemento];
    // extraemos el elemento del arreglo
    static NSString *MyIdentifier = @"formCelda";
    formCelda *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[formCelda alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    [cell.imagen setContentMode:UIViewContentModeScaleAspectFill];

    cell.tag = cualElemento;
    cell.sectionReal = indexPath.section;
    cell.rowReal = indexPath.row;
    cell.delegate = self;
    cell.diccionario = [NSMutableDictionary dictionaryWithDictionary:elementoActual];
    
    [cell.campo setHidden:true];
    [cell.elswitch setHidden:true];
    [cell.elslider setHidden:true];
    [cell.elcontrol setHidden:true];
    //[cell.imagen setHidden:true];
    
    cell.label.text = [elementoActual objectForKey:@"leyenda"];
    cell.error.text = [elementoActual objectForKey:@"error"];
    cell.campo.text = [indiceValores objectForKey:[elementoActual objectForKey:@"nombre"]];
    cell.valorReal = [indiceValores objectForKey:[elementoActual objectForKey:@"nombre"]];
    
    cell.campo.delegate = self;
    cell.campo.enabled = true;
    NSString *tipo=[elementoActual objectForKey:@"tipo"];
    NSString *subtipo=[elementoActual objectForKey:@"subtipo"];
    
    cell.tipo = tipo;
    cell.subtipo = subtipo;
    cell.campo.tipo = tipo;
    cell.campo.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self guardaTextField:cualElemento cualCampo:cell.campo conSection:indexPath.section conRow:indexPath.row];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    if([tipo isEqual:@"I"])
    {
        
        if([subtipo isEqual:@"slider"])
        {
            [cell pintaSlider];
            
            cell.campo.inputView = self.vistaTecladoVacio;
        }
        else
        {
            [cell pintaCampo];
            [cell.campo setKeyboardType:UIKeyboardTypeNumberPad];
        }
    }
    else if([tipo isEqual:@"F"])
    {
        if([subtipo isEqual:@"slider"])
        {
            [cell pintaSlider];
            cell.campo.inputView = self.vistaTecladoVacio;
        }
        else
        {
            [cell pintaCampo];
            [cell.campo setKeyboardType:UIKeyboardTypeDecimalPad];
        }
    }
    else if([tipo isEqual:@"A"])
    {
        cell.campo.inputView=nil;
        [cell pintaCampo];
        if([subtipo isEqualToString:@"email"])
            [cell.campo setKeyboardType:UIKeyboardTypeEmailAddress];
        else if([subtipo isEqualToString:@"telefono"])
            [cell.campo setKeyboardType:UIKeyboardTypePhonePad];
        else if([subtipo isEqualToString:@"geolocalizacion"])
        {
            
            cell.campo.enabled=false;
            cell.campo.inputView = self.vistaTecladoVacio;
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else
            [cell.campo setKeyboardType:UIKeyboardTypeDefault];
        
        
        
    }
    
    else if([tipo isEqual:@"M"] || [tipo isEqual:@"MF"])
    {
        [cell pintaCampoM];
        cell.campo.enabled = false;
        cell.campo.inputView = self.vistaTecladoVacio;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if([tipo isEqual:@"D"])
    {
        [cell pintaCampo];
        cell.campo.inputView = self.fecha;
        
        
    }
    else if([tipo isEqual:@"IT"])
    {
        cell.campo.text = [self generaValorIT:elementoActual];
        [cell pintaCampoIT];
        cell.campo.enabled = false;
        cell.campo.inputView = self.vistaTecladoVacio;

        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    else if([tipo isEqual:@"AI"])
    {
        cell.campo.text = @"";
        [cell pintaCampoAI];
        cell.campo.enabled = false;
        
        if(![self.operacion isEqualToString:@"agregar"])
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            NSString *imagen=@"";
            if(![cell.valorReal isEqualToString:@""])
            {
                if(self.remoto)
                {
                    if([subtipo isEqualToString:@"oculta"]) // la imagen esta oculta, llamamos un PHP que la muestra
                    {
                        int rand = arc4random() % 100000;
                        imagen = [NSString stringWithFormat:@"%@mostrarImagen.php?name=%@&token=%@&otro=%d",GAPIURLImages,cell.valorReal,token,rand];
                    }
                    else imagen = [self extraeArchivoReal:cell.valorReal conModo:@"M"];
                }
                else imagen = cell.valorReal;
            }
            if(![imagen isEqualToString:@""])
            {
                
                if(self.remoto)
                    [cell.imagen setImageWithURL:[NSURL URLWithString:imagen]];
                else
                {
                    NSData *pngData = [NSData dataWithContentsOfFile:imagen];
                    [cell.imagen setImage:[UIImage imageWithData:pngData]];
                }
            }
            else
            {
                [cell.imagen setContentMode:UIViewContentModeScaleAspectFit];
                [cell.imagen setImage:[UIImage imageNamed:@"botonCamaraForm.png"]];

            }
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            if(APIConnection.imageToUpload && APIConnection.imageToUpload!=nil)
                [cell.imagen setImage:APIConnection.imageToUpload];
            else
            {
                [cell.imagen setContentMode:UIViewContentModeScaleAspectFit];
                [cell.imagen setBackgroundColor:[UIColor clearColor]];
                [cell.imagen setImage:[UIImage imageNamed:@"botonCamaraForm.png"]];
            }
            

        }
    }
    else if([tipo isEqual:@"AO"])
    {
        [cell pintaPickerInterno];
        if([subtipo isEqual:@"switch"] || [subtipo isEqual:@"control"])
        {
            cell.campo.inputView = self.vistaTecladoVacio;
        }
        else
        {
            [cell.campo setHidden:false];
            cell.campo.inputView = self.selector;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *grupoActual = [indiceGrupos objectAtIndex:indexPath.section];
    long cualElemento = [[grupoActual objectForKey:@"empieza"] intValue] + indexPath.row;
    NSMutableDictionary *elementoActual = [indice objectAtIndex:cualElemento];
    NSString *tipo=[elementoActual objectForKey:@"tipo"];
    if([tipo isEqual:@"AI"])
    {
        return 100;
    }
    else return 44;
}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setInputAccessoryView:[self.enhancedKeyboard getToolbarWithPrevEnabled:YES NextEnabled:YES DoneEnabled:YES]];
    
    formCelda *celdaActual; // = (formCelda *)[[textField superview] superview];
    if([[UIDevice currentDevice].systemVersion floatValue]==7.0)
        celdaActual = (formCelda *)[[[textField superview] superview] superview]; // pusimos 3 super viewws en lugar de 2 para arreglar el error de crash en ios7
    else celdaActual = (formCelda *)[[textField superview] superview];
    campoActual = textField;
    rowActual = celdaActual.tag;
    sectionReal = celdaActual.sectionReal;
    rowReal = celdaActual.rowReal;
    
    tipoActual = celdaActual.tipo;
    NSMutableDictionary *elementoActual = [indice objectAtIndex:rowActual];
    
    if([celdaActual.tipo isEqualToString:@"AO"])
    {
        [selectorValores removeAllObjects];
        [selectorTextos removeAllObjects];
        
        NSArray *elementos = [[elementoActual objectForKey:@"opcionestextos"] componentsSeparatedByString: @","];
        selectorTextos = [NSMutableArray arrayWithArray:elementos];
        elementos = [[elementoActual objectForKey:@"opcionesvalores"] componentsSeparatedByString: @","];
        
        selectorValores = [NSMutableArray arrayWithArray:elementos];
        [self.selector reloadAllComponents];
        long real = [selectorValores indexOfObject:[indiceValores objectForKey:[elementoActual objectForKey:@"nombre"]]];
        if(NSNotFound != real)
            [self.selector selectRow:real inComponent:0 animated:YES];
    }
    else if([celdaActual.tipo isEqualToString:@"D"])
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        // ponemos el valor real de la fecha
        NSString *tempoFecha= [APIConnection getStringJSON:indiceValores withKey:[elementoActual objectForKey:@"nombre"] widthDefValue:@""];
        if(![tempoFecha isEqualToString:@""] && ![tempoFecha isEqualToString:@"0000-00-00"])
        {
            [self.fecha setDate:[dateFormatter dateFromString:tempoFecha] animated:true];
        }
        
        // ponemos el valor minimo si es necesario
        tempoFecha= [APIConnection getStringJSON:elementoActual withKey:@"minimo" widthDefValue:@""];
        if([tempoFecha isEqual:@"HOY"]) tempoFecha = [self dameHoy];
        if(![tempoFecha isEqual:@""] && ![tempoFecha isEqual:@"0000-00-00"] && ![tempoFecha isEqual:[NSNull null]])
            [self.fecha setMinimumDate:[dateFormatter dateFromString:tempoFecha]];
        
        // ponemos el valor maximo si es necesario
        tempoFecha= [APIConnection getStringJSON:elementoActual withKey:@"maximo" widthDefValue:@""];
        if([tempoFecha isEqual:@"HOY"]) tempoFecha = [self dameHoy];
        if(![tempoFecha isEqual:@""] && ![tempoFecha isEqual:@"0000-00-00"] && ![tempoFecha isEqual:[NSNull null]])
            [self.fecha setMaximumDate:[dateFormatter dateFromString:tempoFecha]];
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(rowActual!=-1)
    {
        if([tipoActual isEqualToString:@"A"] || [tipoActual isEqualToString:@"I"] || [tipoActual isEqualToString:@"F"])
            [self actualizaModelo:textField.text conReal:textField.text conActual:rowActual conActualiza:true];
    }
    rowActual=-1;
}


-(void)actualizaModelo:(NSString *)valor conReal:(NSString *)real conActual:(long)actual conActualiza:(BOOL)actualiza
{
    NSMutableDictionary *elementoActual = [indice objectAtIndex:actual];
    [indiceValores setObject:real forKey:[elementoActual objectForKey:@"nombre"]];
    if(actualiza)
        campoActual.text = valor;
}

// picker para dates
- (IBAction)fechaCambio:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [self actualizaModelo:[dateFormatter stringFromDate:[sender date]] conReal:[dateFormatter stringFromDate:[sender date]] conActual:rowActual conActualiza:true];
}


// picker para AOs y algunos ITs
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [selectorTextos count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [selectorTextos objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self actualizaModelo:[selectorTextos objectAtIndex:row] conReal:[selectorValores objectAtIndex:row] conActual:rowActual conActualiza:true];
}

// funciones para ocultar el teclado como se muestra y oculta
- (void)registerForKeyboardNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    if(!tecladoAbierto)
    {
        
        tecladoAbierto = true;
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        self.tableview.contentInset = contentInsets;
        self.tableview.scrollIndicatorInsets = contentInsets;
        [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rowReal inSection:sectionReal] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}
// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    tecladoAbierto = false;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.tableview.contentInset = contentInsets;
    self.tableview.scrollIndicatorInsets = contentInsets;
}


// para la barra siguiente anterior
- (void)nextDidTouchDown
{
    for (int i=0; i<[self.formItems count]; i++)
    {
        if ([[[self.formItems objectAtIndex:i] textField] isEditing] && i!=[self.formItems count]-1)
        {
            formTextFieldObject *elemento = [self.formItems objectAtIndex:i+1];
            [elemento.textField becomeFirstResponder];
            
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:elemento.rowReal inSection:elemento.sectionReal] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            break;
        }
    }
}
- (void)previousDidTouchDown
{
    for (int i=0; i<[self.formItems count]; i++)
    {
        if ([[[self.formItems objectAtIndex:i] textField] isEditing] && i!=0)
        {
            formTextFieldObject *elemento = [self.formItems objectAtIndex:i-1];
            [elemento.textField becomeFirstResponder];
            
            [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:elemento.rowReal inSection:elemento.sectionReal] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            
            break;
        }
    }
}
- (void)doneDidTouchDown
{
    for(formTextFieldObject *formElement in self.formItems)
    {
        if ([formElement.textField isEditing])
        {
            [formElement.textField resignFirstResponder];
            [self valida];
            break;
        }
    }
}
// agregamos el textifield al arreglo de campos para previous next
-(void)guardaTextField:(long)cual cualCampo:(UITextField *)campo conSection:(long)section conRow:(long)row;
{
    formTextFieldObject *item = [self.formItems objectAtIndex:cual];
    item.textField = campo;
    item.sectionReal = section;
    item.rowReal = row;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *grupoActual = [indiceGrupos objectAtIndex:indexPath.section];
    long cualElemento = [[grupoActual objectForKey:@"empieza"] intValue] + indexPath.row;
    NSDictionary *elementoActual = [indice objectAtIndex:cualElemento];
    NSString *tipo=[elementoActual objectForKey:@"tipo"];
    NSString *subtipo=[elementoActual objectForKey:@"subtipo"];

    if([tipo isEqual:@"IT"])
    {
        NSString *sql_extra_pasar = [self analizaCascadas:[elementoActual objectForKey:@"nombre"]];
        
        if(![self.cp isEqualToString:@""] && ![self.cp isEqual:[NSNull null]] && ![self.cp isEqualToString:@"(null)"])
        {
            sql_extra_pasar = [NSString stringWithFormat:@"%@ and cpcolonia=%@",sql_extra_pasar,self.cp];
        }
        
        if(![sql_extra_pasar isEqual:@"error"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
            formMemoITViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"formMemoIT"];
            vc.diccionario = [NSMutableDictionary dictionaryWithDictionary:elementoActual];
            vc.delegate = self;
            vc.sql_extra = sql_extra_pasar;
            vc.sonFotos=false;
            vc.actual = [indiceValores objectForKey:[elementoActual objectForKey:@"nombre"]];
            long cual=[indiceCamposITs indexOfObject:[elementoActual objectForKey:@"nombre"]];
            if(cual != NSNotFound)
                vc.camposRetornados = [indiceEquivalenciasITs objectAtIndex:cual];
            vc.items_por_pagina_pasar = [APIConnection getIntJSON:elementoActual withKey:@"items_por_pagina" widthDefValue:@"100"];
            [self presentViewController:vc animated:YES completion:^{  }];
           
        }
        else
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Captura el valor previo",)];
    }
    else if([tipo isEqual:@"M"] || [tipo isEqual:@"MF"])
    {
        NSString *sql_extra_pasar = [self analizaCascadas:[elementoActual objectForKey:@"nombre"]];
        if(![sql_extra_pasar isEqual:@"error"])
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
            formMemoViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"formMemo"];
            vc.delegate = self;
            
            vc.textoValor = [indiceValores objectForKey:[elementoActual objectForKey:@"nombre"]];
            vc.cualCampo = [elementoActual objectForKey:@"nombre"];
            vc.titulo = [elementoActual objectForKey:@"leyenda"];
            [self presentViewController:vc animated:YES completion:^{  }];
        }
        else
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Captura el valor previo",)];
    }
    else if([tipo isEqual:@"A"] && [subtipo isEqual:@"geolocalizacion"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
        mapaViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"mapa"];
        vc.geolocalizacion = [indiceValores objectForKey:[elementoActual objectForKey:@"nombre"]];
        vc.cualCampo = [elementoActual objectForKey:@"nombre"];
        vc.delegate=self;
        [self presentViewController:vc animated:YES completion:^{  }];
    }
    else if([tipo isEqual:@"AI"])
    {
        campoSubirFoto = [elementoActual objectForKey:@"nombre"];
        if([self.operacion isEqualToString:@"agregar"])
        {
            UIActionSheet *sheet = [[UIActionSheet alloc]
                                    initWithTitle:@""
                                    delegate:self
                                    cancelButtonTitle:@"Cancelar"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:@"Tomar foto",
                                    @"Seleccionar foto existente", nil];
            sheet.tag=0;
            sheet.actionSheetStyle = UIActionSheetStyleDefault;
            [sheet showInView:self.view];
        }
        else
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"formulario" bundle:nil];
            formMemoITViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"formMemoIT"];
            vc.diccionario = [NSMutableDictionary dictionaryWithDictionary:elementoActual];
            vc.delegate = self;
            vc.sql_extra = @"";
            vc.actual=@"";
            vc.imagen = [indiceValores objectForKey:[APIConnection getStringJSON:elementoActual withKey:@"nombre" widthDefValue:@""]];
            vc.sonFotos=true;
            vc.idreal=self.idreal;
            vc.tabla=self.formulario; // pasamos la tabla
            vc.items_por_pagina_pasar = [APIConnection getIntJSON:elementoActual withKey:@"items_por_pagina" widthDefValue:@"100"];
            [self presentViewController:vc animated:YES completion:^{  }];
        }
    }
    
}

-(void)devuelveValorIT:(NSMutableDictionary *)diccionario conIDReal:(NSString *)idReal conretornado1IT:(NSString *)retornado1IT conretornado2IT:(NSString *)retornado2IT conretornado3IT:(NSString *)retornado3IT conSonFotos:(BOOL)sonFotos
{
    NSString *campo = [APIConnection getStringJSON:diccionario withKey:@"nombre" widthDefValue:@""];
    NSString *campo1=@"";
    NSString *campo2=@"";
    NSString *campo3=@"";
    
    long cual=[indiceCamposITs indexOfObject:campo];
    if(cual != NSNotFound)
    {
        NSString *equivalencias = [indiceEquivalenciasITs objectAtIndex:cual];
        NSArray *arregloTemporal = [equivalencias componentsSeparatedByString:@","];
        campo1=[arregloTemporal objectAtIndex:0];
        if([arregloTemporal count]>1)
            campo2=[arregloTemporal objectAtIndex:1];
        if([arregloTemporal count]>2)
            campo3=[arregloTemporal objectAtIndex:2];
    }
    
    if(!sonFotos)
    {
        NSString *actual = [indiceValores objectForKey:campo];
        [indiceValores setObject:idReal forKey:campo];
        [indiceValores setObject:retornado1IT forKey:campo1];
        
        if(![campo2 isEqual:@""])
            [indiceValores setObject:retornado2IT forKey:campo2];
        if(![campo3 isEqual:@""])
            [indiceValores setObject:retornado3IT forKey:campo3];
        [self generaValorIT:diccionario];
        
        if(![actual isEqual: idReal]) // actualizamos los campos hacia abajo
            [self actualizaCascadasHaciaAbajo:campo];
    }
    else
    {
        [indiceValores setObject:retornado2IT forKey:campo];
    }
    
    [self.tableview reloadData];
}

-(void)devuelveTexto:(NSString *)texto conCampo:(NSString *)campo
{
    [indiceValores setObject:texto forKey:campo];
    [self.tableview reloadData];
}

-(NSString *)generaValorIT:(NSMutableDictionary *)diccionario
{
    NSString *campo = [diccionario objectForKey:@"nombre"];
    NSString *valor = @"";
    NSString *valorReal = [indiceValores objectForKey:campo];
    
    if([valorReal isEqual:@"0"])
        valor=@"";
    else
    {
        long cual=[indiceCamposITs indexOfObject:campo];
        if(cual != NSNotFound)
        {
            NSString *campo1=@"";
            NSString *campo2=@"";
            NSString *campo3=@"";
            
            NSString *equivalencias = [indiceEquivalenciasITs objectAtIndex:cual];
            NSArray *arregloTemporal = [equivalencias componentsSeparatedByString:@","];
            campo1=[arregloTemporal objectAtIndex:0];
            if([arregloTemporal count]>1)
                campo2=[arregloTemporal objectAtIndex:1];
            if([arregloTemporal count]>2)
                campo3=[arregloTemporal objectAtIndex:2];
            
            valor = [indiceValores objectForKey:campo1];
            if(![campo2 isEqual:@""])
                valor = [NSString stringWithFormat:@"%@ %@",valor,[indiceValores objectForKey:campo2]];
            if(![campo3 isEqual:@""])
                valor = [NSString stringWithFormat:@"%@ %@",valor,[indiceValores objectForKey:campo3]];
            
        }
    }
    return valor;
}

-(void)actualizaCascadasHaciaAbajo:(NSString *)campo
{
    long cualHaciaAbajo=[indiceEncadenadosITs indexOfObject:campo];
    if(cualHaciaAbajo != NSNotFound)
    {
        NSString *campoValidar = [indiceCamposITs objectAtIndex:cualHaciaAbajo];
        [indiceValores setObject:@"0" forKey:campoValidar];            
        [self actualizaCascadasHaciaAbajo:campoValidar];
    }
}

-(NSString *)analizaCascadas:(NSString *)campo
{
    
    NSString *respuesta=@"";
    long cual=[indiceCamposITs indexOfObject:campo];
    if(cual != NSNotFound)
    {
        NSString *campoEncadenado = [indiceEncadenadosITs objectAtIndex:cual];
        NSString *campoEncadenadoRelacionado = [indiceEncadenadosRelacionadosITs objectAtIndex:cual];
        respuesta=campoEncadenado;
        if(![campoEncadenado isEqual:@""])
        {
            int valor = [[indiceValores objectForKey:campoEncadenado] intValue];
            if(valor==0)
                respuesta=@"error";
            else respuesta = [NSString stringWithFormat:@"%@=%d",campoEncadenadoRelacionado,valor];

        }
    }
    return respuesta;
}


-(void)generaError:(NSString *)mensaje conCual:(int)cual
{
    NSMutableDictionary *elementoActual = [indice objectAtIndex:cual];
    [elementoActual setObject:NSLocalizedString(mensaje, ) forKey:@"error"];
    [indice replaceObjectAtIndex:cual withObject:elementoActual];
}



-(NSString *)getStringJSON2:(id)dictionary withKey:(NSString *)key widthDefValue:(NSString *)defValue
{
    NSString *newString=@"";
    
    @try {
        newString  = [dictionary objectForKey:key];
    }
    @catch (NSException *exception) {
        newString = defValue;
    }
    @finally {
        if(newString==NULL || [newString isEqual: [NSNull null]]) newString = defValue;
    }
    return newString;
}

-(int)getIntJSON2:(id)dictionary withKey:(NSString *)key widthDefValue:(NSString *)defValue
{
    int newInt;
    NSString *newString;
    @try { newString = [dictionary objectForKey:key]; }
    @catch (NSException *exception) { newString = defValue; }
    @finally {  }
    if(newString == NULL || [newString isEqual: [NSNull null]]) newString = defValue;
    
    newInt = [newString intValue];
    return newInt;
}

-(float)getFloatJSON2:(id)dictionary withKey:(NSString *)key widthDefValue:(NSString *)defValue
{
    float newFloat;
    NSString *newString;
    @try { newString = [dictionary objectForKey:key]; }
    @catch (NSException *exception) { newString = defValue; }
    @finally {  }
    if(newString == NULL || [newString isEqual: [NSNull null]]) newString = defValue;
    
    newFloat = [newString floatValue];
    return newFloat;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


// funciones para geolocalizacion
- (void)iniciaGeolocalizacion
{
    locationManager = [[CLLocationManager alloc] init];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations lastObject];
    currentLat = newLocation.coordinate.latitude;
    currentLon = newLocation.coordinate.longitude;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed %ld",(long)[error code]);
}


-(void)leeDatosCP
{
    [APIConnection connectAPI:[NSString stringWithFormat:@"leeDatosCP.php?CP=%@",self.cp ] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"leeCP" willContinueLoading:false];
}





// rutinas de iamgen
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(actionSheet.tag==0) // primer action sheet
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        if(buttonIndex==0)
            [self useCamera];
        else if(buttonIndex==1)
            [self useCameraRoll];
    }
    
}

- (void) useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        [[UIBarButtonItem appearance] setTintColor:[UIColor  colorWithRed:0 green:0 blue:0 alpha:1]];
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing   = YES;
        
        [self presentViewController:imagePicker animated:YES completion:^{  }];
        //newMedia = YES;
    }
}

- (void) useCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        [[UIBarButtonItem appearance] setTintColor:[UIColor  colorWithRed:0 green:0 blue:0 alpha:1]];
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        //imagePicker.allowsEditing = YES;
        [self presentViewController:imagePicker animated:YES completion:^{  }];
        //newMedia = YES;
    }
}



-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imgCropperViewController = [[UzysImageCropperViewController alloc] initWithImage:image andframeSize:picker.view.frame.size andcropSize:CGSizeMake(640, 480)];
    _imgCropperViewController.delegate = self;
    [picker presentViewController:_imgCropperViewController animated:YES completion:nil];
    [_imgCropperViewController release];
}


- (void)imageCropper:(UzysImageCropperViewController *)cropper didFinishCroppingWithImage:(UIImage *)image
{
    
    float dimensionMayor=640;
    float ancho=640,alto=480;
    if(image.size.width >= image.size.height && image.size.width>dimensionMayor)
    {
        ancho = dimensionMayor;
        alto = image.size.height * dimensionMayor / image.size.width;
        
    }
    else if( image.size.height>dimensionMayor)
    {
        alto = dimensionMayor;
        ancho = image.size.width * dimensionMayor / image.size.height;
        
    }
    else
    {
        ancho = image.size.width;
        alto =image.size.height;
        
    }
    
    CGSize newSize = CGSizeMake(ancho,alto);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    APIConnection.imageToUpload = newImage;
    
    [self.tableview reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(UzysImageCropperViewController *)cropper
{
    stringToPass=@"";
    [_imgCropperViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
