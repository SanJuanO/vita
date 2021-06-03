//
//  seleccionaSubirViewController.m
//  cut
//
//  Created by Guillermo on 15/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//


#import "seleccionaSubirViewController.h"
#import "NSString+calculaCosas.h"
#import <sqlite3.h>
@interface seleccionaSubirViewController ()

@end

@implementation seleccionaSubirViewController
@synthesize vistaBuscador=_vistaBuscador;
@synthesize textoBuscador=_textoBuscador;
@synthesize imagen=_imagen;
@synthesize imagenObjeto=_imagenObjeto;
@synthesize cubierta=_cubierta;
@synthesize cargando=_cargando;
@synthesize subirRegistroReal=_subirRegistroReal;
@synthesize subirTablaReal=_subirTablaReal;
@synthesize delegate=_delegate;
@synthesize subirTextoReal=_subirTextoReal;
@synthesize subirImagen1Real=_subirImagen1Real;
@synthesize subirImagen2Real=_subirImagen2Real;
@synthesize botonsiguiente=_botonsiguiente;

#import "color.h"
#import "databaseOperations.h"

-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    NSMutableArray *indiceTemporal=[[NSMutableArray alloc] init];

    if([senderValue isEqualToString:@"seleccionaSubir"])
    {
        [self.cargando stopAnimating];
        NSMutableDictionary *dic;
        [indice removeAllObjects];
        [indiceTipos removeAllObjects];
        NSDictionary *response=[APIConnection getDictionaryJSON:json withKey:@"response"];
        NSString *tipoIDReal=@"";
        indiceTemporal=[APIConnection getArrayJSON:response withKey:@"lug"];
        if([indiceTemporal count]>0) // generamos los jugadores
        {
            for(NSDictionary *elemento in indiceTemporal)
            {
                tipoIDReal=[NSString stringWithFormat:@"lug-%@",[APIConnection getStringJSON:elemento withKey:@"idreal" widthDefValue:@""]];
                if([self buscaExistente:tipoIDReal] == -1)
                {
                    dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           tipoIDReal,@"tipoIDReal",
                           [APIConnection getStringJSON:elemento withKey:@"nombrelug" widthDefValue:@""],@"titulo",
                           [APIConnection getStringJSON:elemento withKey:@"nombrecad" widthDefValue:@""],@"subtitulo",
                           @"",@"imagen1",
                           [APIConnection getStringJSON:elemento withKey:@"imagenlug" widthDefValue:@""],@"imagen2",
                           @"0",@"marcado",
                           @"lug",@"tipo",
                           nil];
                    [indice addObject:dic];
                    [indiceTipos addObject:@"selecciona"];
                }
            }
        }
        indiceTemporal=[APIConnection getArrayJSON:response withKey:@"cad"];
        if([indiceTemporal count]>0) // generamos los jugadores
        {
            for(NSDictionary *elemento in indiceTemporal)
            {
                tipoIDReal=[NSString stringWithFormat:@"cad-%@",[APIConnection getStringJSON:elemento withKey:@"idreal" widthDefValue:@""]];
                if([self buscaExistente:tipoIDReal] == -1)
                {
                    dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           tipoIDReal,@"tipoIDReal",
                           [APIConnection getStringJSON:elemento withKey:@"nombrecad" widthDefValue:@""],@"titulo",
                           @"",@"subtitulo",
                           @"",@"imagen1",
                           [APIConnection getStringJSON:elemento withKey:@"imagencad" widthDefValue:@""],@"imagen2",
                           @"0",@"marcado",
                           @"cad",@"tipo",
                           nil];
                    [indice addObject:dic];
                    [indiceTipos addObject:@"selecciona"];
                }
            }
        }
        
        indiceTemporal=[APIConnection getArrayJSON:response withKey:@"usuarios"];
        if([indiceTemporal count]>0) // generamos los jugadores
        {
            for(NSDictionary *elemento in indiceTemporal)
            {
                tipoIDReal=[NSString stringWithFormat:@"usuarios-%@",[APIConnection getStringJSON:elemento withKey:@"idreal" widthDefValue:@""]];
                if([self buscaExistente:tipoIDReal] == -1)
                {
                    dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           tipoIDReal,@"tipoIDReal",
                           [APIConnection getStringJSON:elemento withKey:@"nombreusuario" widthDefValue:@""],@"titulo",
                           @"",@"subtitulo",
                           @"",@"imagen1",
                           [APIConnection getStringJSON:elemento withKey:@"imagenusuario" widthDefValue:@""],@"imagen2",
                           @"0",@"marcado",
                           @"usu",@"tipo",
                           nil];
                    [indice addObject:dic];
                    [indiceTipos addObject:@"selecciona"];
                }
            }
        }
        
        indiceTemporal=[APIConnection getArrayJSON:response withKey:@"actores"];
        if([indiceTemporal count]>0) // generamos los jugadores
        {
            for(NSDictionary *elemento in indiceTemporal)
            {
                tipoIDReal=[NSString stringWithFormat:@"act-%@",[APIConnection getStringJSON:elemento withKey:@"idreal" widthDefValue:@""]];
                if([self buscaExistente:tipoIDReal] == -1)
                {
                    dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           tipoIDReal,@"tipoIDReal",
                           [APIConnection getStringJSON:elemento withKey:@"nombreact" widthDefValue:@""],@"titulo",
                           @"",@"subtitulo",
                           @"",@"imagen1",
                           [APIConnection getStringJSON:elemento withKey:@"imagenact" widthDefValue:@""],@"imagen2",
                           @"0",@"marcado",
                           @"act",@"tipo",
                           nil];
                    [indice addObject:dic];
                    [indiceTipos addObject:@"selecciona"];
                }
            }
        }
        
        
        [self agregaExistentes];
        
        if([indice count]==0)
            [self.timelineBuscador limpia];
        
        [self.timelineBuscador acomoda:indice conTipos:indiceTipos conPagina:pagina conSeparador:false conVentana:@"seleccionaSubir" conAudios:1
         ];
        
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"seleccionaSubir"
                                                              action:@"buscaEtiquetas"
                                                               label:@""
                                                               value:nil] build]];
    }
    else if ([senderValue isEqualToString:@"subirFoto"])
    {
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"seleccionaSubir"
                                                              action:@"subioFoto"
                                                               label:@""
                                                               value:nil] build]];
        // mandamos el APIResponse con la respuesta que obtuvimos y luego cerramos
        [self.delegate APIresponse:json :errorValue :@"comentarioAgregar"];
        [self.delegate avisoPublicacion:@"Foto publicada"];
        [self.navigationController popViewControllerAnimated:true];
        
        
    }
}




- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    [self.botonsiguiente setTintColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorBotonFondo2"] withAlpha:1.0]];
    [self.botonsiguiente setTitleColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorBotonFondo2"] withAlpha:1.0] forState:UIControlStateNormal];
    [self.vistaBuscador setBackgroundColor:[self colorDesdeString:[configPrincipal objectForKey:@"colorFondo2"] withAlpha:1.0]];

    [super viewDidLoad];
    existentes=[[NSMutableArray alloc] init];

    if([self.ventanaActual isEqualToString:@"video"])
    {
        [self.headerPrincipal inicializa:@"¿Quién aparece en el video?" conSubtitulo:@"Cancelar" conBotonBack:true conBuscador:false conTipoBotonHome:@""];

    }
    else
        [self.headerPrincipal inicializa:@"¿Quién aparece en la foto?" conSubtitulo:@"Cancelar" conBotonBack:true conBuscador:false conTipoBotonHome:@""];
    
    self.textoBuscador.delegate=self;
    self.timelineBuscador.delegate=self;
    self.headerPrincipal.delegate=self;
    [self.imagen setImage:self.imagenObjeto];
    pagina=1;
    paso=1;
    [self.textoBuscador becomeFirstResponder];
    [self.cubierta setHidden:true];
    self.cubierta.alpha=0;
    [self agregaExistentes];
    [self.timelineBuscador.noinfo setHidden:true];
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"seleccionaSubir"
                                                          action:@"abre"
                                                           label:@""
                                                           value:nil] build]];
    // Do any additional setup after loading the view.
}

- (IBAction)siguiente:(id)sender {
    if(paso==1)
    {
        if([existentes count]==0 && [self.subirTablaReal isEqualToString:@""] && [self.subirRegistroReal isEqualToString:@"0"] && ![self.ventanaActual isEqualToString:@"video"])
        {
            [SVProgressHUD showErrorWithStatus:@"Selecciona al menos un equipo, jugador o juego"];
        }
        else
        {
            self.textoBuscador.text=@"";
            paso=2;
            self.textoBuscador.placeholder=@"Escribe un título o descripción";
            
            if([self.ventanaActual isEqualToString:@"video"])
                [self.headerPrincipal inicializa:@"Título del video" conSubtitulo:@"Cancelar" conBotonBack:true conBuscador:false conTipoBotonHome:@""];
            else
                [self.headerPrincipal inicializa:@"Título de la foto" conSubtitulo:@"Cancelar" conBotonBack:true conBuscador:false conTipoBotonHome:@""];
            [indice removeAllObjects];
            [indiceTipos removeAllObjects];
            [self agregaExistentes];
            [self.cubierta setHidden:false];
            [UIView animateWithDuration:1 animations:^{
                self.cubierta.alpha=0.5;
                
            }];
            [self.timelineBuscador.noinfo setHidden:true];
            [self.textoBuscador setReturnKeyType:UIReturnKeySend];
        }
    }
}
- (IBAction)ocultar:(id)sender {
    [self.textoBuscador resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self siguiente:nil];
    return true;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(paso==1)
    {
        [APIConnection connectionCancel];
        pagina=1;
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if([textField.text length]>=3)
        {
            [self.cargando startAnimating];
            [APIConnection connectAPI:[NSString stringWithFormat:@"seleccionaSubir.php?modo=todos&palabra=%@",self.textoBuscador.text] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:false onErrorReturn:false withSender:@"seleccionaSubir" willContinueLoading:false];
        }
        else
        {
            [self.cargando stopAnimating];

            [indice removeAllObjects];
            [indiceTipos removeAllObjects];
            [self agregaExistentes];
        }
    }
    else if(paso==2)
    {
        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
    }
    
    return false;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField;
{
    [self.cargando stopAnimating];
    
    [indice removeAllObjects];
    [indiceTipos removeAllObjects];
    [self agregaExistentes];
    return YES;
}

-(void)scrollToTop
{
    [self.timelineBuscador.contenedor scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:true];
}

-(long)buscaExistente:(NSString *)tipoIDReal
{
    long donde=-1;
    for(NSMutableDictionary *elemento in existentes)
    {
        donde++;
        NSString *tipoIDRealTempo=[APIConnection getStringJSON:elemento withKey:@"tipoIDReal" widthDefValue:@""];
        if([tipoIDRealTempo isEqualToString:tipoIDReal]) // si existe
            return donde;
    }
    return -1;
}

-(void)actualizaSeleccion:(NSMutableDictionary *)diccionario conMarcado:(NSString *)marcado
{
    
    // veremos si esta o no
    long existeDonde=[self buscaExistente:[APIConnection getStringJSON:diccionario withKey:@"tipoIDReal" widthDefValue:@""]];
    
    if([marcado isEqualToString:@"1"] && existeDonde==-1) // vamos a agregar y no existe
        [existentes addObject:diccionario];
    else if([marcado isEqualToString:@"0"] && existeDonde!=-1) // vamos a quitar y si existe
        [existentes removeObjectAtIndex:existeDonde];
}

-(void)agregaExistentes
{
    if(self.subirTextoReal && ![self.subirTextoReal isEqualToString:@""])
    {
        NSString *tipoIDReal=[NSString stringWithFormat:@"%@-%@",self.subirTablaReal,self.subirRegistroReal];
        if([self buscaExistente:tipoIDReal] == -1)
        {
            NSDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 tipoIDReal,@"tipoIDReal",
                                 self.subirTextoReal,@"titulo",
                                 @"",@"subtitulo",
                                 self.subirImagen1Real,@"imagen1",
                                 self.subirImagen2Real,@"imagen2",
                                 @"1",@"marcado",
                                 self.subirTablaReal,@"tipo",
                                 nil];
            [existentes addObject:dic];
        }
    }
    
    for(NSMutableDictionary *elemento in existentes)
    {
        [indice addObject:elemento];
        [indiceTipos addObject:@"selecciona"];
    }
    [self.timelineBuscador acomoda:indice conTipos:indiceTipos conPagina:pagina conSeparador:false conVentana:@"seleccionaSubir" conAudios:1];

}
-(void)detieneAudio:(BOOL)cerrar
{
    
}
@end
