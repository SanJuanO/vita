//
//  baseVentanaViewController.h
//  kiwilimontest
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 24/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "navigationViewController.h"
#import "editarCatViewController.h"
#import "firmaViewController.h"
#import "headerPrincipal.h"
#import "menuLateral.h"
#import "barraSocial.h"
#import "timeline.h"
#import "selectorClase.h"
#import <MessageUI/MessageUI.h>

#import <CoreLocation/CoreLocation.h>
// incluimos protocolos de header, menuLateral y UIPopOver
@interface baseVentanaViewController : UIViewController<headerPrincipalProtocol,menuLateralProtocol,UIPopoverControllerDelegate,APIConnectionDelegate,headerPrincipalProtocol,UIActionSheetDelegate,UIImagePickerControllerDelegate,firmaProtocol,UIAlertViewDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,MFMailComposeViewControllerDelegate>
{
    // para el menu lateral
    menuLateral *menuLateralVista;
    NSLayoutConstraint *imageViewLeft;
    // para popovers
    UIPopoverController *popOver;
    iwantooAPIConnection *APIConnection;
    long pagina,porpagina;
    NSDictionary *jsonOriginal;
    NSMutableArray *indice,*indiceTipos,*arregloRelaciones;
    UIRefreshControl *refreshControl;
    selectorClase *selector,*selector2;
    long selectorAltura,selector2Altura;
    NSArray *selectorArreglo,*selector2Arreglo;
    BOOL animarRegreso,abreSelector2,selectorCargarContenido;
    NSString *URLCompartir,*subirTabla,*subirRegistro,*subirTexto,*subirImagen1,*subirImagen2;
    NSString *operacionPublicar;
;
    NSString *tituloPrincipal;
    long selectorSeleccionado;

    NSString *URLCompartirPost;
    
}

@property (strong) UIPopoverController *popoverMenu;
@property (strong) UIPopoverController *popoverImageViewController;
@property (nonatomic,strong) NSString *ventanaActual,*ventanaActual2,*idreal,*subirTextoIntermedio,*subirImagen1Intermedio,*subirImagen2Intermedio,*modoTimeline,*cancelarTaps;
-(void)abreFirma;
@property (nonatomic,strong) NSMutableDictionary *diccionario;
-(void)abreURLDirecta:(NSString *)URLAbrir conModo:(NSString *)modo conOperacion:(NSString *)operacion conIdreal:(NSString *)idreal;
-(void)abreHerramienta:(NSString *)cual conDiccionario:(NSDictionary *)diccionario;
-(void)abreMiPerfil;
-(void)firmaRegreso:(NSString *)operacion;
@property (nonatomic) long multiplicadorFuenteActual;
@property (nonatomic,strong) NSString *colorFuenteLocal;
-(NSString *)leeCalendario:(NSString *)tipoCal conidregistrocal:(NSString *)idregistrocal conidusuariocal:(NSString *)idusuariocal;
-(void)guardaCalendario:(NSString *)tipoCal conidregistrocal:(NSString *)idregistrocal conidusuariocal:(NSString *)idusuariocal conidcalendariocal:(NSString *)idcalendariocal;
-(void)borrarCalendario:(NSString *)tipoCal conidregistrocal:(NSString *)idregistrocal conidusuariocal:(NSString *)idusuariocal;


@end


