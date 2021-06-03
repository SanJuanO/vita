//
//  timelineCeldaAudio.h
//  centrovita
//
//  Created by Guillermo on 26/11/15.
//  Copyright © 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface timelineCeldaAudio : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icono1;
@property (weak, nonatomic) IBOutlet UIImageView *icono2;
@property (weak, nonatomic) IBOutlet UILabel *nombre;
@property (weak, nonatomic) IBOutlet UIButton *boton;
@property (nonatomic,strong) NSString *audioArchivo,*titulo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;
-(void)pintaBotones;
@end
