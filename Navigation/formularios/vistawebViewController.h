//
//  vistawebViewController.h
//  voluntariosapp
//
//  Created by Guillermo on 01/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iwantooAPIConnection.h"

@interface vistawebViewController : UIViewController<UIWebViewDelegate,APIConnectionDelegate,UIDocumentInteractionControllerDelegate>
{
    UIDocumentInteractionController *controller;
    iwantooAPIConnection *APIConnection;
    NSString  *filePath;
}
@property (weak, nonatomic) IBOutlet UIWebView *pagina;
@property (weak, nonatomic) IBOutlet UIButton *siguiente;
@property (weak, nonatomic) IBOutlet UIButton *anterior;
@property (weak, nonatomic) IBOutlet UIView *barraInferior;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *cargando;
@property (nonatomic,strong) NSString *url,*modo,*textoHTML;
@property (weak, nonatomic) IBOutlet UIButton *bCompartir;

@end
