//
//  firmaViewController.h
//  tenerMascota
//
//  Created by GUILLERMO FERNANDEZ M on 07/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iwantooAPIConnection.h"


@protocol firmaProtocol <NSObject>
-(void)firmaRegreso:(NSString *)operacion;
@end

@interface firmaViewController : UIViewController<APIConnectionDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    iwantooAPIConnection *APIConnection;
    id<firmaProtocol> delegate;
    NSString *formActual;
    BOOL entroFBLogin;
    NSString *idbote;
    BOOL saliendo;
}
@property (weak, nonatomic) IBOutlet UIButton *entrarAMiCuenta;
@property (weak, nonatomic) IBOutlet UIButton *olvidemicontrasena;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (nonatomic,assign) id<firmaProtocol> delegate;
@property (nonatomic,strong) NSString *operacion;


@property (weak, nonatomic) IBOutlet UIView *vista1Datos;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *posicion;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alineacionVistaDatos1;


@property (weak, nonatomic) IBOutlet UIButton *terminos;


@end

