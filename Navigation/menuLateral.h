//
//  menuLateral.h
//  kiwilimontest
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 23/05/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol menuLateralProtocol <NSObject>
-(void)menuLateralOculta;
-(void)abreHerramienta:(NSString *)cual conDiccionario:(NSDictionary *)diccionario;
-(void)abreURLDirecta:(NSString *)URLAbrir conModo:(NSString *)modo conOperacion:(NSString *)operacion conIdreal:(NSString *)idreal;
@end

@interface menuLateral : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *elementos;
    id<menuLateralProtocol> delegate;
    long weekday;
}
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (weak, nonatomic) IBOutlet UITableView *contenedor;
@property (nonatomic, weak) IBOutlet UITableViewCell *celdaMenuLateral;
@property (nonatomic,assign) id<menuLateralProtocol> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *usuarioimagen;
@property (weak, nonatomic) IBOutlet UILabel *usuarionombre;
@property (weak, nonatomic) IBOutlet UIButton *usuarioboton;
@property (weak, nonatomic) IBOutlet UIButton *usuarioPerfil;
@property (weak, nonatomic) IBOutlet UIView *vista;

@property (weak, nonatomic) IBOutlet UIImageView *imagenPerfil;

-(void)acomoda;
-(void)generaMenu;

@end