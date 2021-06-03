//
//  timelineCeldaBotones.h
//  micartelera
//
//  Created by Guillermo on 06/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol timelineGeneralBotonesProtocol <NSObject>
@optional
-(void)abreBotones:(NSString *)cadena conModo:(NSString *)modo;
@end

@interface timelineCeldaBotones : UITableViewCell
{
    NSString *telefono1,*telefono2;
    id<timelineGeneralBotonesProtocol> delegate;
}
@property (weak, nonatomic) IBOutlet UIButton *botonTelefono1;
@property (weak, nonatomic) IBOutlet UIButton *botonTelefono2;

@property (nonatomic,assign) id<timelineGeneralBotonesProtocol> delegate;
@property (weak, nonatomic) IBOutlet UIView *linea;
@property (nonatomic,strong) NSDictionary *diccionario;
-(void)pintaBotones;
@end