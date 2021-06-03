//
//  formMemoITViewController.m
//  tenerMascota
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 15/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import "formMemoITViewController.h"
#import "SVPullToRefresh.h"
#import "cellFormMemo.h"
#import "UIImageView+AFNetworking.h"
#import <sqlite3.h>
@interface formMemoITViewController ()

@end

@implementation formMemoITViewController
@synthesize diccionario= _diccionario;
@synthesize tableview = _tableview;
@synthesize delegate = _delegate;
@synthesize sql_extra = _sql_extra;
@synthesize camposRetornados=_camposRetornados;
@synthesize campoBuscar=_campoBuscar;
@synthesize actual = _actual;
@synthesize sonFotos=_sonFotos;
@synthesize imagen=_imagen;
@synthesize idreal=_idreal;
@synthesize tabla=_tabla;

#import "globales.h"
#import "color.h"
#import "databaseOperations.h"

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue
{
    
    
    if([senderValue isEqualToString:@"consulta"])
    {
        if(numero_pagina==1 && self.sonFotos)
        {
            [indice addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                               @"subirImagen",@"modo",
                               @"Subir imagen",@"titulofoto",nil]];
            
            if(![self.imagen isEqualToString:@""])
            {
                [indice addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   @"1",@"activo",
                                   self.imagen,@"archivofoto",
                                   @"0",@"idreal",
                                   @"Selección actual",@"titulofoto",nil]];
            }
        }
        
        NSMutableArray *arregloTemporal = [[NSMutableArray alloc] init];
        arregloTemporal = [APIConnection getArrayJSON:json withKey:@"items"];
        if([arregloTemporal count]>0)
        {
            for(id elemento in arregloTemporal)
                [indice addObject:elemento];
        }
        if([arregloTemporal count]<items_por_pagina)
            self.tableview.showsInfiniteScrolling = false;
        else self.tableview.showsInfiniteScrolling = true;
        [self.tableview reloadData];
        
        /*if([indice count]>0)
            [self.nohay setHidden:true];
        else
            [self.nohay setHidden:false];
        */
        if(numero_pagina == 1)
        {
            [self.tableview setContentOffset:CGPointMake(0, 0)];
        }

    }
    else if([senderValue isEqualToString:@"subirFoto"])
    {
        NSDictionary *meta=[APIConnection getDictionaryJSON:json withKey:@"meta"];
        NSString* imagen=[APIConnection getStringJSON:meta withKey:@"mensaje" widthDefValue:@""];
        if(![imagen isEqualToString:@""]) // si hubo imagen
        {
            [self.delegate devuelveValorIT:self.diccionario
                                 conIDReal:0
                           conretornado1IT:@""
                           conretornado2IT:imagen
                           conretornado3IT:@"" conSonFotos:self.sonFotos];
            [self dismissViewControllerAnimated:true completion:^{ }];
        }
    }
}

-(void)cargaIndice
{
    BOOL mostrarAlert = false;
    if(numero_pagina==1)
    {
        [indice removeAllObjects];
        [self.tableview reloadData];
        mostrarAlert = true;
    }
   
    [APIConnection connectAPI:[NSString stringWithFormat:@"iOSForms/consultasForm.php?numero_pagina=%d&items_por_pagina=%d&tablaIT=%@&buscadoIT=%@&retornado1IT=%@&retornado2IT=%@&retornado3IT=%@&sql_extra=%@&sql_extra_otro=%@",numero_pagina,items_por_pagina,tablaIT,buscadoIT,retornado1IT,retornado2IT,retornado3IT,self.sql_extra,self.campoBuscar.text] withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"consulta" willContinueLoading:false];
}

- (void)viewDidLoad
{
    [self.tableview setBackgroundView: nil];
    
    APIConnection = [[iwantooAPIConnection alloc] init];
    APIConnection.delegationListener = self;
    
    CGRect  marco = self.tableview.frame;
    marco.size.height = screenHeight-49-alturaStatus;
    marco.origin.y=49+alturaStatus;
    self.tableview.frame=marco;
    
    retornado1IT=@"";
    retornado2IT=@"";
    retornado3IT=@"";
    
    if(self.sonFotos)
    {
        tablaIT = @"fotos";
        buscadoIT = @"id";
        retornado1IT=@"titulofoto";
        retornado2IT=@"archivofoto";
    }
    else
    {
        tablaIT = [APIConnection getStringJSON:self.diccionario withKey:@"tablaIT" widthDefValue:@""];
        buscadoIT = [APIConnection getStringJSON:self.diccionario withKey:@"buscadoIT" widthDefValue:@""];
        NSArray *arregloTemporal = [self.camposRetornados componentsSeparatedByString:@","];
        retornado1IT=[arregloTemporal objectAtIndex:0];
        if([arregloTemporal count]>1)
            retornado2IT=[arregloTemporal objectAtIndex:1];
        if([arregloTemporal count]>2)
            retornado3IT=[arregloTemporal objectAtIndex:2];
    }
    
    
    
    
    
    indice = [[NSMutableArray alloc] init];
    
    numero_pagina=1;
    items_por_pagina=self.items_por_pagina_pasar;
    
    [self.tableview addInfiniteScrollingWithActionHandler:^{
        numero_pagina++;
        [self cargaIndice];
    }];
    
    // refrescamos el datasource desde el tableview
    [self.tableview addPullToRefreshWithActionHandler:^{
        numero_pagina = 1;
        [self cargaIndice];
        [self.tableview.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:1];
    }];
    
    [self cargaIndice];
    
    [super viewDidLoad];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [indice count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *elementoActual = [indice objectAtIndex:indexPath.row];
    NSString *modo = [APIConnection getStringJSON:elementoActual withKey:@"modo" widthDefValue:@""];
    
    NSString *MyIdentifier = @"formCeldaIT";
    if([modo isEqualToString:@"subirImagen"])
    {
        MyIdentifier = @"formCeldaIT";
    }
    else if(self.sonFotos)
    {
        MyIdentifier=@"formCeldaImagen";
    }
    else
        MyIdentifier = @"formCeldaIT";
    
    cellFormMemo *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[cellFormMemo alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    NSString *cadena = [APIConnection getStringJSON:elementoActual withKey:retornado1IT widthDefValue:@""];
    
    if([[elementoActual objectForKey:@"idreal"] isEqualToString:self.actual])
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    if(!self.sonFotos)
    {
        NSString *campoValor = [APIConnection getStringJSON:elementoActual withKey:retornado2IT widthDefValue:@""];
        if(![retornado2IT isEqual:@""] && ![campoValor isEqual:@""])
            cadena = [NSString stringWithFormat:@"%@ %@",cadena,campoValor];
        
        campoValor = [APIConnection getStringJSON:elementoActual withKey:retornado3IT widthDefValue:@""];
        if(![retornado3IT isEqual:@""] && ![campoValor isEqual:@""])
            cadena = [NSString stringWithFormat:@"%@ %@",cadena,campoValor];
        
        cell.texto.text = cadena;
    
    }
    
    if(self.sonFotos)
    {
        [cell.imagen setImage:nil];;
        [cell.imagen setImageWithURL:[NSURL URLWithString:[self extraeArchivoReal:[APIConnection getStringJSON:elementoActual withKey:@"archivofoto" widthDefValue:@""] conModo:@"M"]]];
        cell.texto.text = [APIConnection getStringJSON:elementoActual withKey:@"titulofoto" widthDefValue:@""];

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *elementoActual = [indice objectAtIndex:indexPath.row];
    NSString *modo = [APIConnection getStringJSON:elementoActual withKey:@"modo" widthDefValue:@""];
    
    if([modo isEqualToString:@"subirImagen"])
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
        NSString *valorIT = [APIConnection getStringJSON:elementoActual withKey:@"idreal" widthDefValue:@""];
        NSString *cadena1 = [APIConnection getStringJSON:elementoActual withKey:retornado1IT widthDefValue:@""];
        
        NSString *cadena2=@"";
        NSString *cadena3=@"";
        
        NSString *campoValor;
        if(![retornado2IT isEqual:@""])
        {
            campoValor = [APIConnection getStringJSON:elementoActual withKey:retornado2IT widthDefValue:@""];
            cadena2 = campoValor;
        }
        if(![retornado3IT isEqual:@""])
        {
            campoValor = [APIConnection getStringJSON:elementoActual withKey:retornado3IT widthDefValue:@""];
            cadena3 = campoValor;
        }
        
        self.actual = [elementoActual objectForKey:@"idreal"];
        [self.tableview reloadData];
        [self.delegate devuelveValorIT:self.diccionario
                             conIDReal:valorIT
                       conretornado1IT:cadena1
                       conretornado2IT:cadena2
                       conretornado3IT:cadena3 conSonFotos:self.sonFotos];
        [self dismissViewControllerAnimated:true completion:^{ }];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.sonFotos)
    {
        NSDictionary *elementoActual = [indice objectAtIndex:indexPath.row];
        NSString *modo = [APIConnection getStringJSON:elementoActual withKey:@"modo" widthDefValue:@""];
        if([modo isEqualToString:@"subirImagen"])
            return 45;
        else
            return 90;
    }
    else return 36;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cerrar:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{ }];
}

- (void)viewDidUnload {
    [self setTableview:nil];
    [self setCampoBuscar:nil];
    [super viewDidUnload];
}

- (IBAction)buscar:(id)sender {
    [self.campoBuscar resignFirstResponder];
    numero_pagina=1;
    [self cargaIndice];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.campoBuscar resignFirstResponder];
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
    
    
    NSString *campo=[APIConnection getStringJSON:self.diccionario withKey:@"nombre" widthDefValue:@""];
    stringToPass = self.tabla;
    stringToPass1 = self.idreal;
    
    [APIConnection connectAPI:@"subirFoto.php?" withData:@"" withMethod:@"POST" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"subirFoto" willContinueLoading:false];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(UzysImageCropperViewController *)cropper
{
    stringToPass=@"";
    [_imgCropperViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

