//
//  formMemoViewController.h
//  tenerMascota
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 21/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol formMProtocol <NSObject>
-(void)devuelveTexto:(NSString *)texto conCampo:(NSString *)campo;
@end

@interface formMemoViewController : UIViewController
{
    id<formMProtocol> delegate;
}
@property (weak, nonatomic) IBOutlet UILabel *tituloPrincipal;
@property (weak, nonatomic) IBOutlet UITextView *texto;
@property (nonatomic,strong) NSString *textoValor;
@property (nonatomic,strong) NSString *cualCampo,*titulo;
@property (nonatomic,assign) id<formMProtocol> delegate;
@end



