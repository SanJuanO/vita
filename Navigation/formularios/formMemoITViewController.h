//
//  formMemoITViewController.h
//  tenerMascota
//
//  Created by GUILLERMO FERNANDEZ MERCHANT on 15/08/13.
//  Copyright (c) 2013 Imagen Central. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "iwantooAPIConnection.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UzysImageCropperViewController.h"


@protocol formITProtocol <NSObject>
-(void)devuelveValorIT:(NSMutableDictionary *)diccionario conIDReal:(NSString *)idReal conretornado1IT:(NSString *)retornado1IT conretornado2IT:(NSString *)retornado2IT conretornado3IT:(NSString *)retornado3IT conSonFotos:(BOOL)sonFotos;
@end

@interface formMemoITViewController : UIViewController<APIConnectionDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UzysImageCropperDelegate>
{
    iwantooAPIConnection *APIConnection;
    int numero_pagina,items_por_pagina;
    NSMutableArray *indice;
    NSString *tablaIT,*buscadoIT,*retornado1IT,*retornado2IT,*retornado3IT;
    id<formITProtocol> delegate;
    UIImageView *fullview;
}

@property (weak, nonatomic) IBOutlet UITextField *campoBuscar;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableDictionary *diccionario;
@property (nonatomic,assign) id<formITProtocol> delegate;
@property (nonatomic,strong) NSString *sql_extra,*camposRetornados,*actual,*imagen,*idreal,*tabla;
@property (nonatomic) int items_por_pagina_pasar;
@property (nonatomic) BOOL sonFotos;
@property (nonatomic,retain) UzysImageCropperViewController *imgCropperViewController;
@end




