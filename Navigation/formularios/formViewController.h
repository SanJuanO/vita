//
//  formViewController.h
//  otroEjemplo
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 13/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "formCelda.h"
#import "formKSEnhancedKeyboard.h"
#import "iwantooAPIConnection.h"
#import "formMemoITViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "formMemoViewController.h"
#import "mapaViewController.h"
#import "UzysImageCropperViewController.h"

@protocol formViewProtocol <NSObject>
@optional
-(void)formRegresaGuardando:(NSString *)idreal;
-(void)formRegresaCerrar;
@end

@interface formViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,celdaFormProtocol,KSEnhancedKeyboardDelegate,APIConnectionDelegate,formITProtocol,CLLocationManagerDelegate,formMProtocol,UINavigationControllerDelegate,formMapaProtocol,UIActionSheetDelegate,UIImagePickerControllerDelegate,UzysImageCropperDelegate>
{
    NSMutableArray *indice,*indiceGrupos,*indiceCamposITs,*indiceEquivalenciasITs,*indiceEncadenadosITs,*indiceEncadenadosRelacionadosITs;
    NSString *tipoActual;
    NSMutableArray *selectorTextos,*selectorValores;
    long rowActual;
    UITextField *campoActual;
    BOOL tecladoAbierto;
    NSMutableDictionary *indiceValores,*diccionarioValoresDefault;
    long sectionReal,rowReal;
    iwantooAPIConnection *APIConnection;
    id<formViewProtocol> delegate;
    NSString *camposConsulta;
    BOOL cerrarPorError;
    double currentLat,currentLon;
    CLLocationManager *locationManager;
    NSString *pieFormulario,*cabezaFormulario;
    NSString *campoSubirFoto;
    
}
@property (strong, nonatomic) IBOutlet UIView *vistaTecladoVacio;
@property (strong, nonatomic) IBOutlet UIPickerView *selector;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIDatePicker *fecha;
@property (strong, nonatomic) NSMutableArray *formItems;
@property (strong, nonatomic) formKSEnhancedKeyboard *enhancedKeyboard;
@property (nonatomic) BOOL remoto,location;
@property (nonatomic,assign) id<formViewProtocol> delegate;
@property (weak, nonatomic) IBOutlet UIButton *cerrarButton;
@property (weak, nonatomic) IBOutlet UIButton *guardarButton;
@property (nonatomic,strong) NSString *formulario,*formularioArchivo,*operacion,*idreal,*titulo,*variablesExtrasGuardar,*cp;
@property (nonatomic,retain) UzysImageCropperViewController *imgCropperViewController;
@end

