//
//  headerPrincipal.h
//  kiwilimon
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 16/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol headerPrincipalProtocol <NSObject>
-(void)menuLateralMuestra;
-(void)popViewController;
-(void)veAlHome;
-(void)scrollToTop;
-(void)abreURLDirecta:(NSString *)URLAbrir;
@optional
-(void)abreBuscador;
-(void)refrescarContenido;
-(void)cambiaFuente;
-(void)cambiaColorFuente;

-(void)clicEnCalendario;
@end

@interface headerPrincipal : UIView
{
    id<headerPrincipalProtocol> delegate;
    NSString *modoBotonHome;

}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *derechaTitulo;
@property (nonatomic,strong) IBOutlet UIView *view;
@property (nonatomic,assign) id<headerPrincipalProtocol> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imagenKiwi;
@property (weak, nonatomic) IBOutlet UIButton *botonBack;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *subtitulo;
-(void)inicializa:(NSString *)titulo conSubtitulo:(NSString *)subtitulo conBotonBack:(BOOL)botonBack conBuscador:(BOOL)buscador conTipoBotonHome:(NSString *)tipoBotonHome;
@property (weak, nonatomic) IBOutlet UIView *vistaAbajo;
@property (weak, nonatomic) IBOutlet UIButton *botonHome;
@property (weak, nonatomic) IBOutlet UIButton *botonBuscador;
@property (weak, nonatomic) IBOutlet UIView *vistaHome;

@property (weak, nonatomic) IBOutlet UIView *fondo1;
@property (weak, nonatomic) IBOutlet UIView *fondo1Linea;
@property (weak, nonatomic) IBOutlet UIButton *botonLateral;
@property (weak, nonatomic) IBOutlet UIImageView *logoPrincipal;
@property (weak, nonatomic) IBOutlet UIView *fondo2LineaHome;
@property (weak, nonatomic) IBOutlet UIButton *botonCalendario;

@property (weak, nonatomic) IBOutlet UIView *fondo2Home;
@property (weak, nonatomic) IBOutlet UIView *fondo2Abajo;
@property (weak, nonatomic) IBOutlet UIView *fondo2Linea1;
-(void)pintaElementos;
@end
