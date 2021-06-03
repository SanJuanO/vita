//
//  seleccionaSubirViewController.h
//  cut
//
//  Created by Guillermo on 15/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//


#import "baseVentanaViewController.h"
#import <UIKit/UIKit.h>
#import "timeline.h"

@protocol seleccionaSubirProtocol <NSObject>
@optional
-(void)APIresponse:(NSDictionary *)json :(NSString *)errorValue :(NSString *)senderValue;
-(void)avisoPublicacion:(NSString *)texto;
-(void)subeVideoOperacionPaso3;
@end



@interface seleccionaSubirViewController : baseVentanaViewController<timelineProtocol,UITextFieldDelegate>
{
    NSMutableArray *existentes;
    long paso;
    id<seleccionaSubirProtocol> delegate;
}
@property (nonatomic,assign) id<seleccionaSubirProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *cargando;

@property (weak, nonatomic) IBOutlet UIView *cubierta;

@property (weak, nonatomic) IBOutlet UIButton *botonsiguiente;
@property (weak, nonatomic) IBOutlet headerPrincipal *headerPrincipal;
@property (weak, nonatomic) IBOutlet timeline *timelineBuscador;
@property (weak, nonatomic) IBOutlet UIView *vistaBuscador;
@property (weak, nonatomic) IBOutlet UITextField *textoBuscador;
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (nonatomic,strong) UIImage *imagenObjeto;
@property (nonatomic,strong) NSString *subirTablaReal,*subirRegistroReal,*subirTextoReal,*subirImagen1Real,*subirImagen2Real;
-(void)detieneAudio:(BOOL)cerrar;
@end
