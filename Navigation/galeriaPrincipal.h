//
//  galeriaPrincipal.h
//  kiwilimon
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 18/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "galeriaPrincipalCelda.h"
#import "iwantooAPIConnection.h"
@protocol galeriaPrincipalProtocol <NSObject>
-(void)abreFotoVideoDesdeGaleria:(NSDictionary *)elemento;
@end



@interface galeriaPrincipal : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *indice;
    int actual;
    CGPoint scrollPositionBeforeRotation;
    NSString *costoTextoLocal;
    NSInteger paginaActual;
    float anchoFuturo;
    BOOL tablaInterna;
    id<galeriaPrincipalProtocol> delegate;
    NSString *campoImagenLocal,*campoTextoLocal;
    iwantooAPIConnection *APIConnection;
}
@property (weak, nonatomic) IBOutlet UIPageControl *paginador;
@property (weak, nonatomic) IBOutlet UICollectionView *contenedor;
@property (nonatomic,strong) IBOutlet UIView *view;
-(void)pintaGaleria:(NSMutableArray *)indicePasado enTabla:(BOOL)tabla conPaginaActual:(int)pagina conCampoImagen:(NSString *)campoImagen conCampoTexto:(NSString *)campoTexto  conCostoTexto:(NSString *)costoTexto;
-(void)yaRote;
@property (nonatomic,assign) id<galeriaPrincipalProtocol> delegate;
@property (nonatomic,strong) NSString *modo;
@end




