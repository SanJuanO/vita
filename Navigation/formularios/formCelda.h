//
//  formCelda.h
//  otroEjemplo
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 14/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "formUITextField.h"

@protocol celdaFormProtocol <NSObject>
-(void)actualizaModelo:(NSString *)valor conReal:(NSString *)real conActual:(long)actual conActualiza:(BOOL)actualiza;
@end

@interface formCelda : UITableViewCell<UITextFieldDelegate>
{
    id<celdaFormProtocol> delegate;
    NSMutableArray *selectorTextos,*selectorValores;
    float incrementoSlider;
}
@property (weak, nonatomic) IBOutlet UISwitch *elswitch;
@property (weak, nonatomic) IBOutlet formUITextField *campo;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *error;
@property (strong, nonatomic) NSString *tipo,*subtipo,*valorReal;
@property (nonatomic) long sectionReal,rowReal;
@property (strong, nonatomic) NSMutableDictionary *diccionario;
@property (weak, nonatomic) IBOutlet UISlider *elslider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *elcontrol;
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
-(void)pintaPickerInterno;
-(void)pintaSlider;
-(void)pintaCampo;
-(void)pintaCampoIT;
-(void)pintaCampoM;
-(void)pintaCampoAI;
@property (nonatomic,assign) id<celdaFormProtocol> delegate;
@end

