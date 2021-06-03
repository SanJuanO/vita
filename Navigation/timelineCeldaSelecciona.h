//
//  timelineCeldaSelecciona.h
//  cut
//
//  Created by Guillermo on 15/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timelineCeldaSelecciona : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imagen1;
@property (weak, nonatomic) IBOutlet UIImageView *imagen2;
@property (weak, nonatomic) IBOutlet UILabel *titulo;
@property (weak, nonatomic) IBOutlet UILabel *subtitulo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alturatitulo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *izquierdatitulo;
@property (weak, nonatomic) IBOutlet UIView *linea;

@end
