//
//  iwantooAPIConnection.m
//  iwantoo
//
//  Created by Abogado Arturo on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "iwantooAPIConnection.h"
#import "SVProgressHUD.h"
#import <sqlite3.h>
#import "AppDelegate.h"
@implementation iwantooAPIConnection
#import "databaseOperations.h"
#import "globales.h"


@synthesize connection = _connection;
@synthesize senderValue = _senderValue;
@synthesize delegationListener = _delegationListener;
@synthesize willContinueLoading = _willContinueLoading;
@synthesize imageToUpload=_imageToUpload;
UIAlertView *alertView;
UIAlertView *alertViewIndicator;
UIActivityIndicatorView *spinner;

- (AppDelegate*)appDelegate {
    return (AppDelegate*)[[UIApplication sharedApplication] delegate];
}


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
    NSUUID *oNSUUID = [[UIDevice currentDevice] identifierForVendor];
    NSString *strUniqueIdentifier= oNSUUID.UUIDString;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *fechaHoy = [df stringFromDate:[NSDate date]];

    NSString *datosEnviar=@"";
    if([metodo isEqualToString:@"GET"]) // es get y hay datos
    {
        if(![datos isEqualToString:@""])
            datosEnviar = [NSString stringWithFormat:@"&%@",datos];
        //cadena = [NSString stringWithFormat:@"%@&idioma_actual=%@",cadena,APIlocale];
    }
    // concatenamos el secret, con la url, con el api_key con el token
    NSString *cadenaConvertir = [NSString stringWithFormat:@"12dsus87393932isdsasaksaksa88hashashsa823822/%@%@/appCut2015/%@/%@",GAPIURL,cadena,token,fechaHoy];
    
    cadenaConvertir = [cadenaConvertir stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    cadena = [cadena stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *GAPIURL2=GAPIURL;
    if([self.senderValue isEqualToString:@"revisaBote"])
        GAPIURL2=@"http://www.boteoteleton.org.mx/boteo2015/app/";
    
    NSString *finalHash = [NSString stringWithFormat:@"%@%@&api_key=appCut2015&digest=%@%@&fechahoy=%@&token=%@&version=2.0&responsables=%@",GAPIURL2,cadena,[self computeSHA256DigestForString:cadenaConvertir],datosEnviar,fechaHoy,token,tokenManager];

    return finalHash;
}


// responds if there is an internet connection
-(BOOL)hasConnectivity {
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
    
    return NO;
    
    // return YES;
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
        
        NSString *tempURL=@"";
        
        if([sender isEqualToString:@"vimeo"])
        {
            tempURL=APIEndPoint;
        }
        else
        {
            //float currentLatG=0,currentLonG=0;
            // forzamos geolocalización y ciudad en su caso
            //if([APIMethod isEqualToString:@"GET"])
            //    APIEndPoint = [NSString stringWithFormat:@"%@&latitud=%f&longitud=%f&",APIEndPoint,currentLatG,currentLonG];
            
            tempURL = [self securedSHA256DigestHashForPIN:APIEndPoint conMetodo:APIMethod conDatos:APIdata];
        }
        NSURL *url = [NSURL URLWithString: tempURL];
        NSLog(@"%@",tempURL);
        //initialize a request from url
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
        
        
        if([sender isEqualToString:@"vimeo"])
        {
            [request setValue:@"bearer 9e2da0c651765752a4160d72bc47be23" forHTTPHeaderField:@"Authorization"];
        }
        
        //set http method
        
        [request setHTTPMethod:APIMethod];
        [request setCachePolicy:NSURLCacheStorageAllowedInMemoryOnly]; // NSURLRequestReloadIgnoringCacheData
        [request setTimeoutInterval:20.0];
        
        //initialize a post data
        NSString *postData = APIdata;
        
        if([sender rangeOfString:@"subirFoto"].location != NSNotFound || ([sender isEqualToString:@"guardarRegistro"] && self.imageToUpload) || ([sender isEqualToString:@"guardarDeposito"] && self.imageToUpload))
        {
            NSData *imgData=UIImageJPEGRepresentation(self.imageToUpload, 90); // UIImagePNGRepresentation(self.imageToUpload);
            NSString *boundary = @"ARCFormBoundary6jx108jywkfyldi";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            
            NSString *emptyString = @"";
            
            
            NSMutableData  *body = [[NSMutableData alloc] init];
            //  parameter token
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"_method\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"POST%@", emptyString] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n%@",emptyString] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]]; // we should pass an aditional parameter to the api
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"stringToPass\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", stringToPass] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"stringToPass1\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", stringToPass1] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"stringToPass2\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@", stringToPass2] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSArray *campos=[postData componentsSeparatedByString:@"&"];
            if([campos count]>0)
            {
                for(int i=0; i<=[campos count]-1; i++)
                {
                    NSArray *camposPartidos=[[campos objectAtIndex:i] componentsSeparatedByString:@"="];
                    
                    if([camposPartidos count]==2)
                    {
                        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",[camposPartidos objectAtIndex:0]] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"%@", [camposPartidos objectAtIndex:1]] dataUsingEncoding:NSUTF8StringEncoding]];
                        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                    }
                }
            }
            
            int x = arc4random() % 100000;
            NSString *imgName = [NSString stringWithFormat:@"imagen%d",x];
            [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"imagen\"; filename=\"%@.jpg\"\r\n",imgName]] dataUsingEncoding:NSUTF8StringEncoding]]; //img name
            [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n%@",emptyString] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Add Image imgData is Declare as Above.
            [body appendData:[NSData dataWithData:imgData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [request setHTTPBody:body];
            stringToPass = @"";
            stringToPass2 = @"";
            stringToPass1 = @"";
            
            
        }
        else if([sender isEqualToString:@"subirAudioNota"] || [sender isEqualToString:@"subirAudioCaso"])
        {
            NSArray *pathComponents = [NSArray arrayWithObjects:
                                       [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                       @"audioGenerado.m4a",
                                       nil];
            NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
            NSData *file1Data = [[NSData alloc] initWithContentsOfFile:[outputFileURL path]];
            NSString *boundary = @"ARCFormBoundary6jx108jywkfyldi";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSString *emptyString = @"";
            
            NSMutableData  *body = [[NSMutableData alloc] init];
            
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"_method\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"POST%@", emptyString] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n%@",emptyString] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]]; // we should pass an aditional parameter to the api
            
            int x = arc4random() % 100000;
            NSString *imgName = [NSString stringWithFormat:@"audio%d",x];
            [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.m4a\"\r\n",imgName]] dataUsingEncoding:NSUTF8StringEncoding]]; //img name
            [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n%@",emptyString] dataUsingEncoding:NSUTF8StringEncoding]];
            
            // Add Image imgData is Declare as Above.
            [body appendData:[NSData dataWithData:file1Data]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [request setHTTPBody:body];
            
            
            
            stringToPass = @"";
            stringToPass2 = @"";
            stringToPass1 = @"";
        }
        else
        {
            if([APIContentType isEqualToString: @""]) APIContentType=GAPIContentType;
            [request setValue:APIContentType forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        //initialize a connection from request
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        
        if(![self.senderValue  isEqualToString: @"refresh_token"])// save current connection, in case we have to call it again, only if we are not refreshing token
        {
            APIEndPointH = APIEndPoint;
            dataH = postData;
            methodH = APIMethod;
            contentTypeh = APIContentType;
            senderH = sender;
            showAlertH = showAlert;
            errorReturnH = onErrorReturn;
            continueLoadingH = willContinue;
        }

        
        [self.connection start];
    }
    else {
        [self mostrarAvisoNoInternet];
    }
}

-(void)mostrarAvisoNoInternet
{
    if([self.delegationListener respondsToSelector:@selector(mostrarAvisoNoInternet)])
    {
        [SVProgressHUD showErrorWithStatus:@"Error de conexión"];
        [self.delegationListener mostrarAvisoNoInternet];
    }
    else
        [SVProgressHUD showErrorWithStatus:@"No se encontró una conexión a internet"];
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
    [self mostrarAvisoNoInternet];
}

-(void)evaluateToken:(NSDictionary *)json
{
    // solo entra si la respuesta fue correcta
    NSDictionary *response = [self getDictionaryJSON:json withKey:@"response"];
    NSString* accessToken = [self getStringJSON:response withKey:@"token" widthDefValue:@""];
    NSString* refresh_token = [self getStringJSON:response withKey:@"refresh_token" widthDefValue:@""];

    if(![accessToken isEqualToString:@""]) // it worked, we can sign in
    {
        token = accessToken;
        [SVProgressHUD dismiss];
        [self saveConfig:@"token" withValue1:accessToken];
        [self saveConfig:@"refresh_token" withValue1:refresh_token];
        
        if([self.senderValue isEqualToString:@"refresh_token"] && ![senderH isEqualToString:@"refresh_token"] && ![senderH isEqualToString:@""])// call connection again, we have refreshed the token
        {
            
            [self connectAPI:APIEndPointH withData:dataH withMethod:methodH withContentType:contentTypeh withShowAlert:showAlertH onErrorReturn:errorReturnH withSender:senderH willContinueLoading:false];
         
            // reset historical variables
            APIEndPointH = @"";
            dataH = @"";
            methodH = @"";
            contentTypeh = @"";
            authenticationH = @"";
            senderH = @"";
            
        }
    }
    else
    {
        [self.delegationListener APIresponse:json: @"error" : self.senderValue];
        [self createAlert:@"Error" withMessage:@"Error desconocido"];
    }
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    //assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
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
        
        NSURL *jpegFilePath2URL = [NSURL fileURLWithPath:jpegFilePath2];
        [self addSkipBackupAttributeToItemAtURL:jpegFilePath2URL];
        [self downloadImages];;
    }
    else
    {
        
        if(!self.willContinueLoading)
            [SVProgressHUD dismiss];
        
        NSError* error;
        // make json object
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
        // read error
        
        NSDictionary *meta=[self getDictionaryJSON:json withKey:@"meta"];
        NSString* code=[NSString stringWithFormat:@"%d",[self getIntJSON:meta withKey:@"code" widthDefValue:@"0"]];
        
        
        // if not json we assign a default error
        if(!json || !meta) code = @"200";
        
        
        if([self.delegationListener conformsToProtocol:(@protocol(APIConnectionDelegate))])
        {
            // extracts errors
            NSString *errorDescription = [self getStringJSON:meta withKey:@"mensaje" widthDefValue:@""];
            NSString *erroMSN = @"";
            if([errorDescription isEqualToString:@""])
                errorDescription =[self getStringJSON:meta withKey:@"detail" widthDefValue:@""];
            erroMSN =[NSString stringWithFormat:@"%@",[meta objectForKey:@"msn"]];
            
            if(code!=nil && code != (id)[NSNull null] && ![code isEqualToString:@"200"])
            {
                if([code isEqualToString:@"100"]) // el token expiro
                {
                    NSString *data = [NSString stringWithFormat:@"sauth.refreshtoken.php?modo=refresh_token&token=%@&refresh_token=%@",token,[self readConfig:@"refresh_token"]];
                    [self connectAPI:data withData:@"" withMethod:@"GET" withContentType:@"" withShowAlert:true onErrorReturn:false withSender:@"refresh_token" willContinueLoading:true];
                }
                
                else
                {                    
                    [SVProgressHUD dismiss];
                    
                    if([self.senderValue isEqualToString:@"refresh_token"] || [erroMSN isEqualToString:@"no token"] || [erroMSN isEqualToString:@"delete token"])
                    {
                        [self limpiaSesion];
                    }
                    
                    if([code isEqualToString:@"101"]) // debes estar firmado y no lo estás limpiamos la sesión
                         [self limpiaSesion];
                    
                    if(onErrorReturnValue)
                    {
                        
                        [self.delegationListener APIresponse:json: errorDescription : self.senderValue];
                    }
                    else // if(!onErrorReturnValue)
                    {
                        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", ) message:errorDescription delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                        [alerta show];
                    }
                }
            }
            else // everything was fine, so we responde to the caller with the json through delegation
            {
                if([self.senderValue isEqualToString:@"refresh_token"])
                {
                    [self evaluateToken:json];
                }
                else if([self.senderValue isEqualToString:@"sincroniza"])
                {
                    [self processSyncDatabase:json];
                }
                else
                {
                    if(![errorDescription isEqualToString:@""])
                    {
                        NSString *mensajeMostrar = [self getStringJSON:meta withKey:@"mensajeMostrar" widthDefValue:@""];
                        if([mensajeMostrar isEqualToString:@"alert"])
                        {
                            UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Aviso" message:errorDescription delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
                            [alerta show];
                        }
                    }
                    [self.delegationListener APIresponse:json: errorDescription : self.senderValue];
                }
                
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
        if(newString==NULL || [newString isEqual: [NSNull null]] || newString==nil)
            newString = defValue;
    }
    newString=[NSString stringWithFormat:@"%@",newString];
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

-(NSMutableArray *)getArrayJSON:(id)dictionary withKey:(NSString *)key
{
    @try {
        NSMutableArray *newArray  = [[dictionary objectForKey:key] mutableCopy];
        if([newArray isKindOfClass:[NSNull class]]) return NULL;
        else return newArray;
    }
    @catch (NSException *exception) {
        return NULL;
    }
    @finally {
        
    }
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

-(NSString *)generaImagen:(NSString *)imagenTexto conFolder:(NSString *)folder conTipo:(NSString *)tipo conDef:(NSString *)def
{
    if(![imagenTexto isEqual:[NSNull null]])
    {
        if(![imagenTexto isEqualToString:@""])
        {
            imagenTexto = [imagenTexto substringWithRange:NSMakeRange(0,[imagenTexto length]-4)];
            imagenTexto = [NSString stringWithFormat:@"%@%@/%@/%@%@.jpg",GAPIURLImages,folder,imagenTexto,tipo,imagenTexto];
        }
        else imagenTexto = @"";
    }
    else imagenTexto = @"";
    return imagenTexto;
}



-(void)evaluaDescarga:(NSString *)campo conDiccionario:(NSDictionary *)diccionario
{
    if(![[diccionario objectForKey:campo] isEqualToString:@""] && ![[diccionario objectForKey:campo] isEqualToString:@"0"])
    {
        if([campo isEqualToString:@"tablaquetienefotosnormales"])
        {
            if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",APIDocDir,[diccionario objectForKey:campo]]])
            {
                [imagesDownload addObject:[diccionario objectForKey:campo]];
                [imagesDownloadFields addObject:campo];
            }
            
        }
        else
        {
            if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",APIDocDir,[self extraeArchivoReal:[diccionario objectForKey:campo] conModo:@"M"]]])
            {
                [imagesDownload addObject:[self extraeArchivoReal:[diccionario objectForKey:campo] conModo:@"M"]];
                [imagesDownloadFields addObject:campo];
            }
            if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",APIDocDir,[self extraeArchivoReal:[diccionario objectForKey:campo] conModo:@"N"]]])
            {
                [imagesDownload addObject:[self extraeArchivoReal:[diccionario objectForKey:campo] conModo:@"N"]];
                [imagesDownloadFields addObject:campo];
            }

          
        }
        

    }
}

-(NSMutableDictionary *)procesaDiccionario:(id)readItem
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithDictionary:readItem];
    for(NSString* key in [dic allKeys]) // para cada elemento sustituimos con datos de la base de datos
    {
        NSString *valor=[self getStringJSON:dic withKey:key widthDefValue:@""];
        valor=[valor stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
        [dic setObject:valor forKey:key];
    }
    return dic;
}

// procesa la sincronizacion
-(void)processSyncDatabase:(NSDictionary *)json
{
    NSDictionary *data = [self getDictionaryJSON:json withKey:@"Data"];
    NSDictionary *readDictionary;
    NSMutableDictionary *readItem;
    if(data != NULL)
    {
        
        readDictionary = [self getDictionaryJSON:data withKey:@"error"];
        if(readDictionary != NULL) // hubo errores
        {
            for (id readItem in readDictionary)
            {
                [SVProgressHUD dismiss];
                [self.delegationListener APIresponse:nil: [readItem objectForKey:@"valor"] : self.senderValue];
            }
        }
        else // no hubo errores todo bien
        {
            NSString *fechaUltima = @"";
            readDictionary = [self getDictionaryJSON:data withKey:@"mensajes"];
            if(readDictionary != NULL) // hubo errores
            {
                for (id readItem in readDictionary)
                {
                    fechaUltima = [readItem objectForKey:@"fechaultima"];
                }
            }
            
            
            
            // sync med
            readDictionary = [self getDictionaryJSON:data withKey:@"med"];
            for (id readItemBase in readDictionary)
            {
                readItem=[NSMutableDictionary dictionaryWithDictionary:[self procesaDiccionario:readItemBase]];
                NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO med (id,activo,nombremed,abrevmed,descargado) VALUES ('%@','%@','%@','%@','%@')",
                                 [readItem objectForKey:@"idreal"],[readItem objectForKey:@"activo"],[readItem objectForKey:@"nombremed"],[readItem objectForKey:@"abrevmed"],descargado];
                [self databaseUpdate: sql];
                
            }
            
            // sync eq
            readDictionary = [self getDictionaryJSON:data withKey:@"eq"];
            for (id readItemBase in readDictionary)
            {
                readItem=[NSMutableDictionary dictionaryWithDictionary:[self procesaDiccionario:readItemBase]];
                NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO eq (id,activo,imedidaeq,cantidadeq,imedidaigualeq,descargado) VALUES ('%@','%@','%@','%@','%@','%@')",
                                 [readItem objectForKey:@"idreal"],[readItem objectForKey:@"activo"],[readItem objectForKey:@"imedidaeq"],[readItem objectForKey:@"cantidadeq"],[readItem objectForKey:@"imedidaigualeq"],descargado];
                [self databaseUpdate: sql];
                
            }
            
            tempSender = self.senderValue;
            
            
            
        }
    }
}



// descargar imagenes
-(void)downloadImages
{
    BOOL encontrado;
    descargandoImagen++;
    if(descargandoImagen<=[imagesDownload count]-1)
    {
        NSString *filenameUse = [imagesDownload objectAtIndex:descargandoImagen];
        
        // busquemos si ya descargamos la imagen en esta sincronizacion
        encontrado = false;
        for(int j=0; j<=[arregladoDescargados count]-1; j++)
        {
            if([[arregladoDescargados objectAtIndex:j] isEqualToString:filenameUse])
            {
                encontrado = true;
                break;
            }
        }
        
        
        
        if(!encontrado) // aun no la hemos descargado, descarguemos
        {
            
            [arregladoDescargados addObject:filenameUse]; // agregamos a los descargados
            
            // generamos el nombre del archivo, en general es el que descargaremos
            NSString *urlDownload = [NSString stringWithFormat:@"%@%@",GAPIURLImages,[imagesDownload objectAtIndex:descargandoImagen]];
            jpegFilePath2 = [NSString stringWithFormat:@"%@/%@",APIDocDir,filenameUse];
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:jpegFilePath2];
            
            if(!fileExists)
            {
                
                [self createDirectory:[imagesDownload objectAtIndex:descargandoImagen] atFilePath:APIDocDir];
                if(![[imagesDownloadFields objectAtIndex:descargandoImagen] isEqualToString:@"estilos"]) // no son estilos
                    self.senderValue = @"imagen";
                else // son estilos
                    self.senderValue = @"estilos";
                
                NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:urlDownload]
                                                          cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                [self.connection cancel];
                self.connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
                NSMutableData *data = [[NSMutableData alloc] init];
                receivedData = data;
                [self.connection start];
                [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"%d/%lu",descargandoImagen,[imagesDownload count]-1] maskType:SVProgressHUDMaskTypeBlack];
            }
            else
                [self downloadImages];
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
    [SVProgressHUD dismiss];
    // llamamos APIresponse porque ya terminamos, dependiendo del senderValue es lo que haremos
    [self.delegationListener termineCiudad];
}

-(void)limpiaSesion
{
    token=@"";
    uid=@"0";
    tokenCMS=@"";
    tokenName=@"";
    tokenImagen=@"";
    tokenTeam=@"0";
    tokenMember=@"0";
    tokenManager=@"0";
    // tokenTeam,tokenMember,tokenManager
    
    [self saveConfig:@"token" withValue1:@""];
    [self saveConfig:@"uid" withValue1:@"0"];
    [self saveConfig:@"tokenCMS" withValue1:@""];
    [self saveConfig:@"tokenName" withValue1:@""];
    [self saveConfig:@"tokenImagen" withValue1:@""];
    [self saveConfig:@"refresh_token" withValue1:@""];
    [self saveConfig:@"tokenTeam" withValue1:@"0"];
    [self saveConfig:@"tokenMember" withValue1:@"0"];
    [self saveConfig:@"tokenManager" withValue1:@"0"];
    
   /* PFInstallation *installation = [PFInstallation currentInstallation];
    [installation setObject:[NSNumber numberWithInt:[uid intValue]] forKey:@"uid"];
    [installation setObject:[NSNumber numberWithInt:[tokenTeam intValue]] forKey:@"tokenTeam"];
    [installation setObject:[NSNumber numberWithInt:[tokenMember intValue]] forKey:@"tokenMember"];
    [installation setObject:[NSNumber numberWithInt:[tokenManager intValue]] forKey:@"tokenManager"];
    [installation saveInBackground];*/
    NSMutableDictionary *losTags = [[NSMutableDictionary alloc] init];
    [losTags setObject:@"" forKey:@"uid"];
    [losTags setObject:@"" forKey:@"tokenTeam"];
    [losTags setObject:@"" forKey:@"tokenMember"];
    [losTags setObject:@"" forKey:@"tokenManager"];
    [losTags setObject:@"0" forKey:@"refdiaria"];
    [losTags setObject:@"0" forKey:@"notificaciones"];
    [OneSignal sendTags:losTags];

    [OneSignal getTags:^(NSDictionary* tags) {
        tagsDictionary = tags;
    }];
    
}

-(void)muestraErrorFirma:(NSString *)mensaje
{
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", ) message:mensaje delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    [alerta show];
}




@end
