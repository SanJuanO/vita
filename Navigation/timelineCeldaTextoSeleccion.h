//
//  timelineCeldaTextoSeleccion.h
//  centrovita
//
//  Created by Guillermo on 23/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol timelineCeldaTextoSeleccionProtocol <NSObject>
@optional
-(void)seleccionarTextoSeleccion:(long)cual;
@end

@interface timelineCeldaTextoSeleccion : UITableViewCell
{
    id<timelineCeldaTextoSeleccionProtocol> delegate;
}
@property (weak, nonatomic) IBOutlet UIView *vistaPrincipal;
@property (weak, nonatomic) IBOutlet UILabel *texto;
@property (weak, nonatomic) IBOutlet UIView *fondo;
@property (weak, nonatomic) IBOutlet UIButton *checado;
@property (nonatomic,assign) id<timelineCeldaTextoSeleccionProtocol> delegate;
-(void)pintaChecado:(NSString *)checado conOcultaSelector:(NSString *)ocultaSelector conEditando:(BOOL)editando;
@end

