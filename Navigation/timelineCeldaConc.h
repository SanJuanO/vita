//
//  timelineCeldaConc.h
//  centrovita
//
//  Created by Guillermo on 10/01/16.
//  Copyright © 2016 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol celdaConcProtocol <NSObject>
@optional -(void)concPagar:(long)cual;
@end

@interface timelineCeldaConc : UITableViewCell
{
    id<celdaConcProtocol> delegate;

}

@property (weak, nonatomic) IBOutlet UIView *vistaSecundaria;
@property (weak, nonatomic) IBOutlet UILabel *concepto;
@property (weak, nonatomic) IBOutlet UILabel *timporte;
@property (weak, nonatomic) IBOutlet UILabel *tdescuento;
@property (weak, nonatomic) IBOutlet UILabel *ttotal;
@property (weak, nonatomic) IBOutlet UILabel *importe;

@property (weak, nonatomic) IBOutlet UILabel *descuento;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UIButton *botonPagar;
@property (nonatomic,assign) id<celdaConcProtocol> delegate;
@property (weak, nonatomic) IBOutlet UIView *vistaPrincipal;


@end

