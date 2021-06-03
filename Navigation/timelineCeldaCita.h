//
//  timelineCeldaCita.h
//  centrovita
//
//  Created by Guillermo on 08/06/17.
//  Copyright © 2017 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol timelineCeldaCitaProtocol <NSObject>
@optional
-(void)calificaCita:(long)cual conCalificacion:(NSString *)calificacion;
-(void)abreSede:(NSString *)idsede;
@end

@interface timelineCeldaCita : UITableViewCell
{
    id<timelineCeldaCitaProtocol> delegate;

}
@property (nonatomic,assign) id<timelineCeldaCitaProtocol> delegate;

@property (weak, nonatomic) IBOutlet UIView *vistaPrincipal;
@property (weak, nonatomic) IBOutlet UIView *vistaSecundaria;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *subtitulo;
@property (weak, nonatomic) IBOutlet UIView *vistaFecha;
@property (weak, nonatomic) IBOutlet UILabel *dia;
@property (weak, nonatomic) IBOutlet UILabel *mes;
@property (weak, nonatomic) IBOutlet UILabel *sede;
@property (weak, nonatomic) IBOutlet UIImageView *asistencia;
@property (weak, nonatomic) IBOutlet UIView *calificacion;
@property (weak, nonatomic) IBOutlet UIImageView *stara0;
@property (weak, nonatomic) IBOutlet UIImageView *stara1;
@property (weak, nonatomic) IBOutlet UIImageView *stara2;
@property (weak, nonatomic) IBOutlet UIImageView *stara3;
@property (weak, nonatomic) IBOutlet UIImageView *stara4;
@property (nonatomic) BOOL calificar;
@property (nonatomic,strong) NSString *idsede;
-(void)pintaCalificacion:(NSString *)valorProceso;
-(void)pintaElementos;
@end
