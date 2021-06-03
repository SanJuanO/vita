//
//  headerEncuentro.h
//  centrovita
//
//  Created by Guillermo on 22/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol headerEncuentroProtocol <NSObject>
-(void)encuentroAtras;
-(void)encuentroAdelante;
@end

@interface headerEncuentro : UIView
{
    id<headerEncuentroProtocol> delegate;

}
@property (nonatomic,assign) id<headerEncuentroProtocol> delegate;
@property (nonatomic,strong) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *botonAnterior;
@property (weak, nonatomic) IBOutlet UIButton *botonSiguiente;
@property (weak, nonatomic) IBOutlet UILabel *etiqueta;
-(void)inicializa:(NSString *)titulo conPaso:(long)paso conPasos:(long)pasos;
@end
