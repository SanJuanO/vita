//
//  timelineGeneralSeparador.h
//  cut
//
//  Created by Guillermo on 11/08/15.
//  Copyright (c) 2015 Tammy L Coron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timelineGeneralSeparador : UITableViewCell

-(void)pintaFondo:(NSString *)color;
@property (weak, nonatomic) IBOutlet UIView *linea;

@end