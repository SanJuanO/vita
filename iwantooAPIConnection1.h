//
//  iwantooAPIConnection.h
//  iwantoo
//
//  Created by Abogado Arturo on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "globales.h"
#import "SVProgressHUD.h"

#import <Security/Security.h>
#import <CommonCrypto/CommonHMAC.h>

@protocol APIConnectionDelegate <NSObject>

@optional
-(void)APIresponse:(NSDictionary *)json : (NSString *)errorValue : (NSString *)senderValue;
@end

@interface iwantooAPIConnection : NSObject <NSURLConnectionDataDelegate>
{
    id<APIConnectionDelegate> delegationListener;
    NSMutableData *receivedData;
    BOOL onErrorReturnValue;
    NSString *APIEndPointH,*dataH,*methodH,*contentTypeh,*authenticationH,*senderH;
    BOOL showAlertH,errorReturnH,continueLoadingH;
    
    NSString *descargado;
    NSString *jpegFilePath2;
    
    NSMutableArray *imagesDownload;
    NSMutableArray *imagesDownloadFields;
    NSMutableArray *arregladoDescargados;
    int descargandoImagen;
    NSString *tempSender;
    
    NSString *claveReceta;
    
    NSString *modoDescargaImagenes;
}

@property (nonatomic,assign) id<APIConnectionDelegate> delegationListener;
@property (nonatomic,weak) NSURLConnection *connection;
@property (nonatomic,strong) NSString *senderValue;
@property (nonatomic) BOOL willContinueLoading;

@property (nonatomic,strong) UIImage *imageToUpload;
@property (nonatomic) BOOL noMostrarNoHayInternet;
// @property (nonatomic) int willContinueReal;

-(void)connectAPI:(NSString *)APIEndPoint withData:(NSString *)APIdata withMethod:(NSString *)APIMethod withContentType:(NSString *)APIContentType withShowAlert:(BOOL)showAlert onErrorReturn:(BOOL)onErrorReturn withSender:(NSString *)sender willContinueLoading:(BOOL)willContinue;

-(NSDictionary *)getDictionaryJSON:(id)dictionary withKey:(NSString *)key;
-(NSString *)getStringJSON:(id)dictionary withKey:(NSString *)key widthDefValue:(NSString *)defValue;
-(BOOL)getBOOLJSON:(id)dictionary withKey:(NSString *)key widthDefValue:(BOOL)defValue;
-(int)getIntJSON:(id)dictionary withKey:(NSString *)key widthDefValue:(NSString *)defValue;
-(float)getFloatJSON:(id)dictionary withKey:(NSString *)key widthDefValue:(NSString *)defValue;
-(NSMutableArray *)getArrayJSON:(id)dictionary withKey:(NSString *)key;
-(void)createAlert:(NSString *)title withMessage:(NSString *)message;
-(void)connectionCancel;
-(NSString *)encodeText:(NSString *)textToEncode;
-(NSString *)generaImagen:(NSString *)imagenTexto conFolder:(NSString *)folder conTipo:(NSString *)tipo conDef:(NSString *)def conReceta:(NSString *)receta conLocal:(BOOL)local;

-(BOOL)hasConnectivity;
-(void)iniciaDescargaImagenes:(NSMutableArray *)imagenes conClave:(NSString *)clave conModo:(NSString *)modo;

@end
