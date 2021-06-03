//
//  timelineCeldaPag.h
//  centrovita
//
//  Created by Guillermo on 11/01/16.
//  Copyright © 2016 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timelineCeldaPag : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fechapag;
@property (weak, nonatomic) IBOutlet UILabel *statusNombrepag;
@property (weak, nonatomic) IBOutlet UILabel *totalpag;
@property (weak, nonatomic) IBOutlet UILabel *modoNombrepag;
@property (weak, nonatomic) IBOutlet UILabel *confirmacionpag;
@property (weak, nonatomic) IBOutlet UIView *vistaPrincipal;
@property (weak, nonatomic) IBOutlet UIView *vistaSecundaria;

@end
