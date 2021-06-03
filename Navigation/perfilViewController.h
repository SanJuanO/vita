//
//  perfilViewController.h
//  cut
//
//  Created by Guillermo on 30/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import "baseVentanaViewController.h"
#import <UIKit/UIKit.h>
@interface perfilViewController : baseVentanaViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIScrollViewDelegate>
{
    int noti,refl,acti,encu;
    NSMutableArray *escolaridades;
}

@property (weak, nonatomic) IBOutlet headerPrincipal *headerPrincipal;

@property (weak, nonatomic) IBOutlet UISwitch *notificaciones;
@property (weak, nonatomic) IBOutlet UISwitch *reflexion;
@property (weak, nonatomic) IBOutlet UISwitch *actividades;
@property (weak, nonatomic) IBOutlet UISwitch *encuentros;
@property (weak, nonatomic) IBOutlet UITextField *nombre;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *contrasena;
@property (weak, nonatomic) IBOutlet UITextField *confirmar;
@property (weak, nonatomic) IBOutlet UITextField *celular;
@property (weak, nonatomic) IBOutlet UITextField *telefono;
@property (weak, nonatomic) IBOutlet UIDatePicker *nacimiento;
@property (weak, nonatomic) IBOutlet UIPickerView *escolaridad;
@property (weak, nonatomic) IBOutlet UITextField *profesion;

@end
