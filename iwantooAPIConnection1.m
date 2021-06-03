//
//  iwantooAPIConnection.m
//  iwantoo
//
//  Created by Abogado Arturo on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iwantooAPIConnection.h"


@implementation iwantooAPIConnection
@synthesize connection = _connection;
@synthesize senderValue = _senderValue;
@synthesize delegationListener = _delegationListener;
@synthesize willContinueLoading = _willContinueLoading;
@synthesize noMostrarNoHayInternet = _noMostrarNoHayInternet;
UIAlertView *alertView;
UIAlertView *alertViewIndicator;
UIActivityIndicatorView *spinner;

// This is where the rest of the magic happens.
// Here we are taking in our string hash, placing that inside of a C Char Array, then parsing it through the SHA256 encryption method.
- (NSString*)computeSHA256DigestForString:(NSString*)input
{
    
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA256(data.bytes, data.length, digest);
    
    // Setup our Objective-C output.
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

// generamos la URL completa para hacer la conexión
- (NSString *)securedSHA256DigestHashForPIN:(NSString *)cadena conMetodo:(NSString *)metodo conDatos:(NSString *)datos
{
    NSString *datosConvertir=@"";
    NSString *datosEnviar=@"";
    if([metodo isEqualToString:@"GET"] && ![datos isEqualToString:@""]) // es get y hay datos
    {
        datosConvertir = [NSString stringWithFormat:@"/%@/",datos];
        datosEnviar = [NSString stringWithFormat:@"&%@",datos];
    }
    // NSString *cadenaConvertir = [NSString stringWithFormat:@"761f7814c32745d17fdf698d29a013%@/%@%@OYzlB3iqSUSrN5pXW63bfIyGVHXq6C",metodo,cadena,datosConvertir];
    NSString *cadenaConvertir = [NSString stringWithFormat:@"761f7814c32745d17fdf698d29a013%@/%@OYzlB3iqSUSrN5pXW63bfIyGVHXq6C",metodo,cadena];
   
    cadenaConvertir = [cadenaConvertir stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *finalHash = [NSString stringWithFormat:@"http://graph.kiwilimon.com/%@?api_key=OYzlB3iqSUSrN5pXW63bfIyGVHXq6C&digest=%@%@",cadena,[self computeSHA256DigestForString:cadenaConvertir],datosEnviar];
    return finalHash;
}

/*
 - (NSString *)securedSHA256DigestHashForPIN:(NSString *)cadena conMetodo:(NSString *)metodo
 {
 NSString *cadenaConvertir = [NSString stringWithFormat:@"761f7814c32745d17fdf698d29a013%@/%@OYzlB3iqSUSrN5pXW63bfIyGVHXq6C",metodo,cadena];
 cadenaConvertir = [cadenaConvertir stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 NSString *finalHash = [NSString stringWithFormat:@"http://graph.kiwilimon.com/%@?api_key=OYzlB3iqSUSrN5pXW63bfIyGVHXq6C&digest=%@",cadena,[self computeSHA256DigestForString:cadenaConvertir]];
 return finalHash;
 }*/



-(void)createAlert:(NSString *)title withMessage:(NSString *)message
{    
    if([title isEqualToString:@"ERROR"])
        [SVProgressHUD showErrorWithStatus:message];
    else
        [SVProgressHUD showSuccessWithStatus:message];
}
-(void)createAlertIndicator:(NSString *)title withMessage:(NSString *)message
{
    [SVProgressHUD showWithStatus:message maskType:SVProgressHUDMaskTypeClear];
   
}
-(void)removeAlertIndicator
{
    [SVProgressHUD dismiss]; 
}

// responds if there is an internet connection
-(BOOL)hasConnectivity {
    NSString *noHayInternet = @"No tienes conexión a internet";
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                if(!self.noMostrarNoHayInternet) [SVProgressHUD showErrorWithStatus:noHayInternet];
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    if(!self.noMostrarNoHayInternet) [SVProgressHUD showErrorWithStatus:noHayInternet];
    return NO;
    /*
    if(!self.noMostrarNoHayInternet) [SVProgressHUD showErrorWithStatus:noHayInternet];
    return NO;*/
}


-(void)connectAPI:(NSString *)APIEndPoint withData:(NSString *)APIdata withMethod:(NSString *)APIMethod withContentType:(NSString *)APIContentType  withShowAlert:(BOOL)showAlert onErrorReturn:(BOOL)onErrorReturn withSender:(NSString *)sender willContinueLoading:(BOOL)willContinue{
    
    if(self.willContinueLoading)
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    if([self hasConnectivity]) // we should check if there is an internet connection available
    {
        onErrorReturnValue = onErrorReturn;
        self.senderValue = sender;
       
        self.willContinueLoading = willContinue;
        if(showAlert)
           [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        
        //if there is a connection going on just cancel it.
        [self.connection cancel];
        
        //initialize new mutable data
        NSMutableData *data = [[NSMutableData alloc] init];
        receivedData = data;
        
        if([APIMethod isEqualToString: @""]) APIMethod=@"GET";
        
        NSString *tempURL = [self securedSHA256DigestHashForPIN:APIEndPoint conMetodo:APIMethod conDatos:APIdata];
        NSLog(@"%@",tempURL);
        NSURL *url = [NSURL URLWithString: tempURL];
      
        //initialize a request from url
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
        
        //set http method
        
        [request setHTTPMethod:APIMethod];
        [request setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly]; // NSURLRequestReloadIgnoringCacheData
        
      //  NSLog(@"%@ %@", tempURL,APIdata);
        
        if([sender isEqualToString: @"imageUpload"]) // vamos a subir la linda imagen
        {
            NSData *imgData=UIImagePNGRepresentation(self.imageToUpload);
            
            NSString *boundary = @"ARCFormBoundary6jx108jywkfyldi";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            NSString *imgName = @"mypicture";
            NSString *emptyString = @"";
            
            NSMutableData  *body = [[NSMutableData alloc] init];
           
            [body appendData:[[NSString stringWithFormat:@"--%@\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\n\n"] dataUsingEncoding:NSUTF8StringEncoding]];
           
            [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"receta\"\n\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", stringToPass] dataUsingEncoding:NSUTF8StringEncoding]]; // pass the name value            
            [body appendData:[[NSString stringWithFormat:@"\n--%@\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            //NSString *tempo = [[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding];
            
            [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"--%@\r\n%@",boundary,APIdata]] dataUsingEncoding:NSUTF8StringEncoding]]; //include data info
            [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"foto\"; filename=\"%@.png\"\r\n",imgName]] dataUsingEncoding:NSUTF8StringEncoding]]; //img name
            [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n%@",emptyString] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Add Image imgData is Declare as Above.
            [body appendData:[NSData dataWithData:imgData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [request setHTTPBody:body];
            
            
        }
        else
        {
            if([APIContentType isEqualToString: @""]) APIContentType=APIContentType;
            [request setValue:APIContentType forHTTPHeaderField:@"Content-Type"];
            if([APIMethod isEqualToString:@"POST"])
            {
                NSString *postData = APIdata;
                [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
            }
        }
        //initialize a post data
        
        
        //initialize a connection from request
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        [self.connection start];
    }
    /*else {
        [self createAlert:@"Error" withMessage:@"Internet Connection"];
    }*/
}

-(void)connectionCancel
{
    [SVProgressHUD dismiss];
    [self.connection cancel];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
   
    receivedData = nil;
    self.connection = nil;
    
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"Error"];
}

// this method returns the errors obtained in the errors array, if there is no erros array, then returns the errorText directly
-(NSString *)extractErrors:(NSDictionary *)json withError:(NSString *)errorText
{
    // read json response
    NSString *message = @"";
    
    @try {
        NSDictionary* errors =[json objectForKey:@"errors"];
        if([errors count]>0)
        {
            for(id listErrors in errors)
            {
                message = [NSString stringWithFormat:@"%@",[listErrors objectForKey:@"message"]]; 
            }
        }
    }
    @catch (NSException *exception) {
        if([message isEqualToString:@""])
            message = [NSString stringWithFormat:@"%@",errorText];
    }
    @finally {
       
    }
    return message;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    if([self.senderValue isEqualToString:@"imagen"])
    {
        NSData *data2;
        UIImage *image = [UIImage imageWithData:receivedData];
        if([jpegFilePath2 rangeOfString:@".png"].location != NSNotFound)
            data2 = [NSData dataWithData:UIImagePNGRepresentation(image)];//1.0f = 100% quality
        else data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
        [data2 writeToFile:jpegFilePath2 atomically:YES];
        [self downloadImages];
    }
    else
    {
        
        if(!self.willContinueLoading && ![self.senderValue isEqualToString:@"sincronizarReceta"])
            [SVProgressHUD dismiss];
        
        NSError* error;
        // make json object
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
        //NSLog(@"%@",json);
        // read error
        NSString* errorValue; // =[json objectForKey:@"error"];
        NSDictionary *errorsDictionary; //  = [json objectForKey:@"error"];
        
        // if not json we assign a default error
        if(!json) errorValue = @"Unknown Error";
        
        // access only if it can  && [self.delegationListener respondsToSelector:(@selector(APIresponse:errorValue:senderValue:))]
        if([self.delegationListener conformsToProtocol:(@protocol(APIConnectionDelegate))])
        {
            
            // extracts errors
            NSString *messageAlert;
            NSString *errorDescription = @"";
            if(errorValue!=nil && errorValue != (id)[NSNull null])
            {
                messageAlert = [self extractErrors:errorsDictionary withError:errorValue];
                errorDescription =[NSString stringWithFormat:@"%@",[json objectForKey:@"error_description"]];
                
                if(onErrorReturnValue)
                {
                    [self.delegationListener APIresponse:json: messageAlert : self.senderValue];
                }
                else // if(!onErrorReturnValue)
                {
                    
                    [self createAlert:@"ERROR" withMessage:messageAlert];
                }
            }
            else // everything was fine, so we responde to the caller with the json through delegation
            {
                [self.delegationListener APIresponse:json: messageAlert : self.senderValue];
            }
        }
    }
}






// FUNCTIONS THAT WILL HELP US TO INTERPRET JSON WITH EXCEPTIONS
-(NSDictionary *)getDictionaryJSON:(id)dictionary withKey:(NSString *)key
{
    @try {
        NSDictionary *newDictionary  = [dictionary objectForKey:key];
        if([newDictionary isKindOfClass:[NSNull class]]) return NULL;
        else return newDictionary;
    }
    @catch (NSException *exception) {
        return NULL;
    }
    @finally {
        
    }
}

-(NSMutableArray *)getArrayJSON:(id)dictionary withKey:(NSString *)key
{
    @try {
        NSMutableArray *newArray  = [dictionary objectForKey:key];
        if([newArray isKindOfClass:[NSNull class]]) return NULL;
        else return newArray;
    }
    @catch (NSException *exception) {
        return NULL;
    }
    @finally {
        
    }
}

-(NSString *)getStringJSON:(id)dictionary withKey:(NSString *)key widthDefValue:(NSString *)defValue
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
    newString = [NSString stringWithFormat:@"%@",newString];
    return newString;
}

-(BOOL)getBOOLJSON:(id)dictionary withKey:(NSString *)key widthDefValue:(BOOL)defValue
{
    @try {
        BOOL newBool  = [[dictionary objectForKey:key] boolValue];

        return newBool;
    }
    @catch (NSException *exception) {
        return defValue;
    }
    @finally {
        
    }    
}

-(int)getIntJSON:(id)dictionary withKey:(NSString *)key widthDefValue:(NSString *)defValue
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

-(float)getFloatJSON:(id)dictionary withKey:(NSString *)key widthDefValue:(NSString *)defValue
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

-(NSString *)encodeText:(NSString *)textToEncode
{
    textToEncode = [textToEncode stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    textToEncode = [textToEncode stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    return textToEncode;
}

-(void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath
{
    NSString *pathWithNoFileName = [directoryName stringByDeletingLastPathComponent];
    
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:pathWithNoFileName];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
}

-(NSString *)generaImagen:(NSString *)imagenTexto conFolder:(NSString *)folder conTipo:(NSString *)tipo conDef:(NSString *)def conReceta:(NSString *)receta conLocal:(BOOL)local
{
    imagenTexto = [NSString stringWithFormat:@"%@",imagenTexto];
    NSString *iExtra=@"";
    if(![imagenTexto isEqual:[NSNull null]])
    {
        if(![imagenTexto isEqualToString:@""] && ![imagenTexto isEqualToString:@"<null>"])
        {
            NSString *extension,*imagenTextoTemporal,*servidorReal;
            
            if([imagenTexto length]>4)
            {
                imagenTextoTemporal = [imagenTexto substringWithRange:NSMakeRange(0,[imagenTexto length]-4)];
                extension = [imagenTexto substringWithRange:NSMakeRange([imagenTexto length]-4,4)];
                
                if(![extension isEqualToString:@".jpg"] && ![extension isEqualToString:@".png"]) // no tiene extensión;
                {
                    extension = @".jpg";
                    imagenTextoTemporal = imagenTexto;
                }
            }
            else
            {
                extension = @".jpg";
                imagenTextoTemporal = imagenTexto;
            }
            
            if(local) servidorReal = @"";
            else servidorReal = GAPIURLImages;
            if([folder isEqualToString:@"clasificacionHome"])
            {
                extension=@".png";
                iExtra=@"i";
                folder=@"clasificacion";
            }
            if([folder isEqualToString:@"recetaimagen"])
                imagenTexto = [NSString stringWithFormat:@"%@%@/%@/%@%@%@%@",servidorReal,folder,receta,tipo,iExtra,imagenTextoTemporal,extension];
            else
                imagenTexto = [NSString stringWithFormat:@"%@%@/%@/%@%@%@%@",servidorReal,folder,imagenTextoTemporal,tipo,iExtra,imagenTextoTemporal,extension];
        }
        else imagenTexto = @"";
    }
    else imagenTexto = @"";
    
    if([imagenTexto isEqualToString:@""])
    {
        NSString *tamano = @"120";
        if([tipo isEqualToString:imagenThumb]) tamano = @"120";
        imagenTexto = [NSString stringWithFormat:@"%@/images/logo-o-%@.png",GAPIURLImages,tamano];
    }
    return imagenTexto;
}

// arrancamos la descarga de imagenes
-(void)iniciaDescargaImagenes:(NSMutableArray *)imagenes conClave:(NSString *)clave conModo:(NSString *)modo
{
    modoDescargaImagenes = modo;
    descargandoImagen = -1;
    [imagesDownload removeAllObjects];
    claveReceta = clave;
    imagesDownload = [NSMutableArray arrayWithArray:imagenes];
    if([imagesDownload count]>0)
        [self downloadImages];
    else [self terminamosFotos];
}

// descargar imagenes
-(void)downloadImages
{
    self.senderValue = @"imagen";
    descargandoImagen++;
    if(descargandoImagen<[imagesDownload count])
    {
        NSString *filenameUse = @"";
        NSDictionary *diccionario;
        diccionario = [imagesDownload objectAtIndex:descargandoImagen];
        
        if([[diccionario objectForKey:@"modoInterno"] isEqualToString:@"IP"]) // solo descargamos las que son de internet propio
        {
            filenameUse=[self generaImagen:[diccionario objectForKey:@"imagen"] conFolder:@"recetaimagen" conTipo:imagenCompleta conDef:@"" conReceta:claveReceta conLocal:true];
        }
        
        if(![filenameUse isEqualToString:@""]) // aun no la hemos descargado, descarguemos
        {
            
            NSString *urlDownload = [NSString stringWithFormat:@"%@%@",GAPIURLImages,filenameUse];
            
            jpegFilePath2 = [NSString stringWithFormat:@"%@/%@",APIDocDir,filenameUse];
            [self createDirectory:filenameUse atFilePath:APIDocDir];
            
            NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlDownload]
                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            [self.connection cancel];
            self.connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
            NSMutableData *data = [[NSMutableData alloc] init];
            receivedData = data;
            [self.connection start];
            
            if([modoDescargaImagenes isEqualToString:@"normal"])
               [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%d/%d",descargandoImagen,[imagesDownload count]-1] maskType:SVProgressHUDMaskTypeBlack];
        }
        else
        {
            [self downloadImages];
        }
    }
    else [self terminamosFotos];
    
    
    
    
}


-(void)terminamosFotos
{
    self.senderValue = tempSender;
        
    if([modoDescargaImagenes isEqualToString:@"normal"])
        [SVProgressHUD showSuccessWithStatus:@"Agregado a Mi recetario"];
    else
    {
        // llamamos el delegate por si acaso hay muchas recetas
        [self.delegationListener APIresponse:nil :@"" :@"termineFotosMiRecetario"];
    }
    
    
}





@end
