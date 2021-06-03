//
//  timelineCeldaNoticia.h
//  cut
//
//  Created by Guillermo on 24/07/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timelineCeldaNoticia : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vistaPrincipal;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UIImageView *imagen;
@property (weak, nonatomic) IBOutlet UILabel *intro;
@property (weak, nonatomic) IBOutlet UIView *linea;
@property (weak, nonatomic) IBOutlet UILabel *precio;
@end
