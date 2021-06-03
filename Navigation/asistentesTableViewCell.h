//
//  asistentesTableViewCell.h
//  centrovita
//
//  Created by Laura Fernández on 29/01/16.
//  Copyright © 2016 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface asistentesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nombre;
@property (weak, nonatomic) IBOutlet UILabel *tipo;
@property (weak, nonatomic) IBOutlet UIImageView *boton;

@end
